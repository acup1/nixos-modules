() => {
  const clean = value => (value || "").replace(/\s+/g, " ").trim();
  function selectorFor(element) {
    if (element.id) {
      const id = "#" + CSS.escape(element.id);
      if (document.querySelectorAll(id).length === 1) return id;
    }
    const path = [];
    for (let current = element; current; current = current.parentElement) {
      let index = 1;
      for (let sibling = current.previousElementSibling; sibling; sibling = sibling.previousElementSibling) {
        if (sibling.localName === current.localName) index++;
      }
      path.unshift(CSS.escape(current.localName) + ":nth-of-type(" + index + ")");
    }
    return path.join(" > ");
  }
  const controls = document.querySelectorAll(
    "a[href], button, input:not([type=hidden]), textarea, select, summary, " +
    "[contenteditable=true], [tabindex]:not([tabindex='-1']), " +
    "[role=button], [role=link], [role=checkbox], [role=radio], [role=combobox], " +
    "[role=menuitem], [role=tab], [role=textbox], [role=switch]"
  );
  const elements = [];
  for (const element of controls) {
    if (!element.getClientRects().length || getComputedStyle(element).visibility !== "visible") continue;
    const labelledBy = clean(element.getAttribute("aria-labelledby")).split(" ").filter(Boolean);
    const name = element.getAttribute("aria-label")
      || labelledBy.map(id => document.getElementById(id)?.textContent).join(" ").trim()
      || Array.from(element.labels || []).map(label => label.innerText).join(" ")
      || element.innerText || element.getAttribute("placeholder") || element.getAttribute("title");
    elements.push({
      selector: selectorFor(element),
      role: element.getAttribute("role") || element.localName,
      type: element.getAttribute("type") || undefined,
      name: clean(name).slice(0, 180),
      disabled: element.matches(":disabled") || element.getAttribute("aria-disabled") === "true",
    });
    if (elements.length === 100) break;
  }
  const text = document.body?.innerText || "";
  return JSON.stringify({
    url: location.href,
    title: document.title,
    text: text.trim().slice(0, 12000),
    elements,
  });
}
