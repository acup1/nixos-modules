"""Operate an existing Zen browser through its local WebDriver BiDi endpoint."""
import base64
import json
import sys
from collections import deque
from contextlib import contextmanager, suppress
from pathlib import Path
from threading import Lock
from typing import Literal

from mcp.server.fastmcp import FastMCP, Image
from websocket import WebSocketException, create_connection

port = int(sys.argv[1])
server = FastMCP("zen")
snapshot_script = Path(__file__).with_name("snapshot.js").read_text(encoding="utf-8")
keys = {
    "Backspace": "\ue003", "Tab": "\ue004", "Enter": "\ue007", "Shift": "\ue008",
    "Control": "\ue009", "Alt": "\ue00a", "Escape": "\ue00c", "Space": "\ue00d",
    "PageUp": "\ue00e", "PageDown": "\ue00f", "End": "\ue010", "Home": "\ue011",
    "ArrowLeft": "\ue012", "ArrowUp": "\ue013", "ArrowRight": "\ue014", "ArrowDown": "\ue015",
    "Insert": "\ue016", "Delete": "\ue017", "Meta": "\ue03d",
}


class BrowserSession:
    def __init__(self):
        self.socket = create_connection(
            f"ws://127.0.0.1:{port}/session", timeout=20,
            suppress_origin=True, http_no_proxy=["127.0.0.1"],
        )
        self.command_id = 0
        self.selected_tab = None
        self.messages = deque(maxlen=500)
        try:
            self.call("session.new", capabilities={})
            self.call("session.subscribe", events=["log.entryAdded"])
        except Exception:
            self.close()
            raise

    def close(self):
        self.socket.close()

    def call(self, method, **params):
        self.command_id += 1
        self.socket.send(json.dumps({"id": self.command_id, "method": method, "params": params}))
        while True:
            message = json.loads(self.socket.recv())
            if message.get("method") == "log.entryAdded":
                self.messages.append(message["params"])
            if message.get("id") != self.command_id:
                continue
            if message.get("type") == "error":
                raise ValueError(f"{method}: {message.get('message') or message['error']}")
            return message["result"]

    def tabs(self):
        result = self.call("browsingContext.getTree", maxDepth=0)
        return [
            {"tab_id": tab["context"], "url": tab["url"], "selected": tab["context"] == self.selected_tab}
            for tab in result["contexts"]
        ]

    def target(self, tab_id):
        if tab_id is not None:
            return tab_id
        tabs = self.tabs()
        for tab in tabs:
            if tab["selected"]:
                return tab["tab_id"]
        if len(tabs) == 1:
            return tabs[0]["tab_id"]
        raise ValueError("Use browser_tabs to select a tab or pass its tab_id.")

    def navigate(self, context, url):
        return self.call("browsingContext.navigate", context=context, url=url, wait="interactive")

    def script(self, method, context, **params):
        response = self.call(
            f"script.{method}", target={"context": context}, awaitPromise=True, **params,
        )
        if response["type"] == "exception":
            raise ValueError(response["exceptionDetails"]["text"])
        return response["result"]

    def element(self, context, selector):
        result = self.call(
            "browsingContext.locateNodes", context=context, maxNodeCount=2,
            locator={"type": "css", "value": selector},
        )
        nodes = result["nodes"]
        if len(nodes) != 1:
            raise ValueError("The CSS selector must match exactly one element. Try browser_snapshot.")
        return {"sharedId": nodes[0]["sharedId"]}


session = None
session_lock = Lock()


@contextmanager
def connection():
    global session
    with session_lock:
        try:
            if session is None:
                session = BrowserSession()
            yield session
        except (OSError, WebSocketException) as error:
            if session is not None:
                session.close()
                session = None
            raise ValueError(
                f"Zen connection on 127.0.0.1:{port}: {error}. Start zen-mcp-browser.",
            ) from error


@server.tool()
def browser_tabs(
    action: Literal["list", "new", "select", "close"] = "list",
    tab_id: str | None = None, url: str | None = None,
) -> dict[str, object]:
    """List tabs, open one (optionally at a URL), or select or close a tab by ID."""
    with connection() as browser:
        if action == "new":
            browser.selected_tab = browser.call("browsingContext.create", type="tab")["context"]
            if url is not None:
                browser.navigate(browser.selected_tab, url)
        elif action == "select":
            context = browser.target(tab_id)
            browser.call("browsingContext.activate", context=context)
            browser.selected_tab = context
        elif action == "close":
            context = browser.target(tab_id)
            browser.call("browsingContext.close", context=context)
            if browser.selected_tab == context:
                browser.selected_tab = None
        return {"tabs": browser.tabs()}


@server.tool()
def browser_navigate(url: str, tab_id: str | None = None) -> dict[str, object]:
    """Open a URL in the selected tab and wait until the document is interactive."""
    with connection() as browser:
        return browser.navigate(browser.target(tab_id), url)


@server.tool()
def browser_history(
    action: Literal["back", "forward", "reload"], tab_id: str | None = None,
) -> dict[str, object]:
    """Go back or forward in the tab's history, or reload it."""
    with connection() as browser:
        context = browser.target(tab_id)
        if action == "reload":
            return browser.call("browsingContext.reload", context=context, wait="interactive")
        browser.call("browsingContext.traverseHistory", context=context, delta=-1 if action == "back" else 1)
        return {"tab_id": context, "action": action}


@server.tool()
def browser_snapshot(tab_id: str | None = None) -> dict[str, object]:
    """Read the current document's visible text and list controls with CSS selectors."""
    with connection() as browser:
        result = browser.script("evaluate", browser.target(tab_id), expression=f"({snapshot_script})()")
        return json.loads(result["value"])


@server.tool()
def browser_click(selector: str, tab_id: str | None = None) -> dict[str, str]:
    """Click the element matching a CSS selector using WebDriver pointer input."""
    with connection() as browser:
        context = browser.target(tab_id)
        element = browser.element(context, selector)
        browser.script(
            "callFunction", context, functionDeclaration="e => e.scrollIntoView({block: 'center', inline: 'center'})",
            arguments=[element],
        )
        browser.call("input.performActions", context=context, actions=[{
            "type": "pointer", "id": "mouse", "parameters": {"pointerType": "mouse"},
            "actions": [
                {"type": "pointerMove", "x": 0, "y": 0, "origin": {"type": "element", "element": element}},
                {"type": "pointerDown", "button": 0},
                {"type": "pointerUp", "button": 0},
            ],
        }])
        return {"tab_id": context, "selector": selector}


@server.tool()
def browser_type(selector: str, text: str, tab_id: str | None = None) -> dict[str, str]:
    """Replace the text in an editable input, textarea, or contenteditable element."""
    with connection() as browser:
        context = browser.target(tab_id)
        element = browser.element(context, selector)
        browser.script(
            "callFunction", context,
            functionDeclaration="""(element, text) => {
                if (element.matches(":disabled") || element.readOnly)
                    throw new Error("The field is disabled or read-only.");
                element.focus();
                if (element instanceof HTMLTextAreaElement || element instanceof HTMLInputElement
                    && ["text", "search", "url", "tel", "email", "password", "number"].includes(element.type)) {
                    const prototype = element instanceof HTMLTextAreaElement
                        ? HTMLTextAreaElement.prototype : HTMLInputElement.prototype;
                    Object.getOwnPropertyDescriptor(prototype, "value").set.call(element, text);
                } else if (element.isContentEditable) {
                    element.textContent = text;
                } else {
                    throw new Error("Choose an editable text field.");
                }
                element.dispatchEvent(new InputEvent("input", {
                    bubbles: true, composed: true, data: text, inputType: "insertReplacementText"
                }));
            }""",
            arguments=[element, {"type": "string", "value": text}],
        )
        return {"tab_id": context, "selector": selector}


@server.tool()
def browser_press_key(
    key: str, modifiers: list[Literal["Shift", "Control", "Alt", "Meta"]] | None = None,
    tab_id: str | None = None,
) -> dict[str, str]:
    """Press a key such as Enter, Escape, or a single character in the focused page element."""
    value = keys.get(key, key)
    if len(value) != 1:
        raise ValueError("Use a single character or a key name such as Enter, Tab or ArrowDown.")
    chord = list(dict.fromkeys([*(keys[modifier] for modifier in modifiers or []), value]))
    key_actions = [{"type": "keyDown", "value": key_value} for key_value in chord]
    key_actions.extend({"type": "keyUp", "value": key_value} for key_value in reversed(chord))
    with connection() as browser:
        context = browser.target(tab_id)
        browser.call("input.performActions", context=context, actions=[
            {"type": "key", "id": "keyboard", "actions": key_actions},
        ])
        return {"tab_id": context, "key": key}


@server.tool()
def browser_evaluate(expression: str, tab_id: str | None = None) -> dict[str, object]:
    """Evaluate a JavaScript expression in the current document and return its BiDi value."""
    with connection() as browser:
        return browser.script(
            "evaluate", browser.target(tab_id), expression=expression,
            serializationOptions={"maxObjectDepth": 4},
        )


@server.tool()
def browser_console_messages(tab_id: str | None = None) -> list[dict[str, object]]:
    """Read up to 50 console entries and JS errors observed for the tab since MCP connected."""
    with connection() as browser:
        context = browser.target(tab_id)
        browser.call("session.status")
        return [
            {key: entry[key] for key in ("level", "type", "text", "timestamp") if key in entry}
            for entry in browser.messages
            if entry["source"].get("context") == context
        ][-50:]


@server.tool()
def browser_take_screenshot(tab_id: str | None = None, full_page: bool = False) -> Image:
    """Capture the selected tab's viewport or full document as a PNG image."""
    with connection() as browser:
        result = browser.call(
            "browsingContext.captureScreenshot", context=browser.target(tab_id),
            origin="document" if full_page else "viewport", format={"type": "image/png"},
        )
        return Image(data=base64.b64decode(result["data"], validate=True), format="png")


if __name__ == "__main__":
    try:
        server.run(transport="stdio")
    finally:
        if session is not None:
            with suppress(OSError, ValueError, WebSocketException):
                session.socket.settimeout(2)
                session.call("session.end")
            session.close()
