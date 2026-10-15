{lib, pkgs, ...}: let
  localColorways = pkgs.vscode-utils.buildVscodeExtension {
    pname = "acup-local-colorways";
    version = "1.0.0";
    vscodeExtPublisher = "acup";
    vscodeExtName = "local-colorways";
    vscodeExtUniqueId = "acup.local-colorways";
    src = ./local-theme;
    sourceRoot = "local-theme";
    meta.license = lib.licenses.mit;
  };

  codexExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "openai";
      name = "chatgpt";
      version = "26.51007.21434";
      arch = "darwin-arm64";
      hash = "sha256-JKSbsmx4QLw43Kle0Pj3L6+9bUYNO0ggyaapbaT9MPs=";
    };
  };

  mapCommand = before: command: {
    inherit before;
    commands = [command];
    silent = true;
  };
  normalKey = key: command: {
    inherit key command;
    when = "editorTextFocus && vim.active && vim.mode == 'Normal' && !inDebugRepl";
  };
  terminalSequence = key: text: {
    inherit key;
    command = "workbench.action.terminal.sendSequence";
    args = {inherit text;};
    when = "terminalFocus";
  };
  toggleTerminal = "workbench.action.terminal.toggleTerminal";
  terminalWhen = "terminalFocus || (editorTextFocus && vim.active && !inDebugRepl)";
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) ["vscode"];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.vscodevim.vim
        codexExtension
        localColorways
      ];

      userSettings = {
        "workbench.colorTheme" = "Ocean High Contrast";

        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.detectIndentation" = false;
        "editor.lineNumbers" = "relative";
        "editor.formatOnSave" = true;
        "workbench.editor.enablePreview" = false;

        "vim.leader" = "<space>";
        "vim.useSystemClipboard" = true;
        "vim.useCtrlKeys" = true;
        "vim.hlsearch" = true;
        "vim.incsearch" = true;
        # nvf defaults to case-sensitive search.
        "vim.ignorecase" = false;
        "vim.smartcase" = false;
        "vim.handleKeys" = {
          "<C-s>" = false;
        };

        "vim.normalModeKeyBindingsNonRecursive" = [
          (mapCommand ["<Esc>"] ":nohlsearch")
          (mapCommand ["<leader>" "e"] "workbench.action.toggleSidebarVisibility")
          (mapCommand ["<leader>" "c"] "workbench.action.closeActiveEditor")
          (mapCommand ["<leader>" "/"] "editor.action.commentLine")

          # Native equivalents of the enabled Telescope and lazygit mappings.
          (mapCommand ["<leader>" "f" "f"] "workbench.action.quickOpen")
          (mapCommand ["<leader>" "f" "g"] "workbench.action.findInFiles")
          (mapCommand ["<leader>" "f" "b"] "workbench.action.showAllEditors")
          (mapCommand ["<leader>" "f" "t"] "workbench.action.showCommands")
          (mapCommand ["<leader>" "f" "s"] "workbench.action.gotoSymbol")
          (mapCommand ["<leader>" "f" "l" "s" "b"] "workbench.action.gotoSymbol")
          (mapCommand ["<leader>" "f" "l" "s" "w"] "workbench.action.showAllSymbols")
          (mapCommand ["<leader>" "f" "l" "r"] "editor.action.goToReferences")
          (mapCommand ["<leader>" "f" "l" "i"] "editor.action.goToImplementation")
          (mapCommand ["<leader>" "f" "l" "D"] "editor.action.revealDefinition")
          (mapCommand ["<leader>" "f" "l" "t"] "editor.action.goToTypeDefinition")
          (mapCommand ["<leader>" "f" "l" "d"] "workbench.actions.view.problems")
          (mapCommand ["<leader>" "f" "v" "s"] "workbench.view.scm")
          (mapCommand ["<leader>" "g" "g"] "workbench.view.scm")

          # nvf's default LSP mappings.
          (mapCommand ["<leader>" "l" "g" "d"] "editor.action.revealDefinition")
          (mapCommand ["<leader>" "l" "g" "D"] "editor.action.revealDeclaration")
          (mapCommand ["<leader>" "l" "g" "t"] "editor.action.goToTypeDefinition")
          (mapCommand ["<leader>" "l" "g" "i"] "editor.action.goToImplementation")
          (mapCommand ["<leader>" "l" "g" "r"] "editor.action.goToReferences")
          (mapCommand ["<leader>" "l" "g" "n"] "editor.action.marker.next")
          (mapCommand ["<leader>" "l" "g" "p"] "editor.action.marker.prev")
          (mapCommand ["<leader>" "l" "e"] "editor.action.showHover")
          (mapCommand ["<leader>" "l" "S"] "workbench.action.gotoSymbol")
          (mapCommand ["<leader>" "l" "w" "s"] "workbench.action.showAllSymbols")
          (mapCommand ["<leader>" "l" "h"] "editor.action.showHover")
          (mapCommand ["<leader>" "l" "s"] "editor.action.triggerParameterHints")
          (mapCommand ["<leader>" "l" "n"] "editor.action.rename")
          (mapCommand ["<leader>" "l" "a"] "editor.action.quickFix")
          (mapCommand ["<leader>" "l" "f"] "editor.action.formatDocument")

          # VS Code uses its terminal panel in place of ToggleTerm's float.
          (mapCommand ["<leader>" "t" "f"] toggleTerminal)
          {
            before = ["<leader>" "t" "h"];
            commands = [
              "workbench.action.positionPanelBottom"
              "workbench.action.terminal.focus"
            ];
            silent = true;
          }
          {
            before = ["<leader>" "t" "v"];
            commands = [
              "workbench.action.positionPanelRight"
              "workbench.action.terminal.focus"
            ];
            silent = true;
          }
        ];

        "vim.visualModeKeyBindingsNonRecursive" = [
          (mapCommand ["<leader>" "/"] "editor.action.commentLine")
        ];

        "terminal.integrated.commandsToSkipShell" = [
          toggleTerminal
          "workbench.action.focusActiveEditorGroup"
        ];
      };

      keybindings = [
        # Native bindings also work when Vim does not receive Tab or Ctrl keys.
        (normalKey "tab" "workbench.action.nextEditor")
        (normalKey "shift+tab" "workbench.action.previousEditor")
        (normalKey "ctrl+up" "workbench.action.increaseViewHeight")
        (normalKey "ctrl+down" "workbench.action.decreaseViewHeight")
        (normalKey "ctrl+left" "workbench.action.decreaseViewWidth")
        (normalKey "ctrl+right" "workbench.action.increaseViewWidth")
        {
          key = "ctrl+s";
          command = "workbench.action.files.save";
          when = "editorTextFocus && vim.active && !inDebugRepl";
        }
        {
          key = "ctrl+'";
          command = toggleTerminal;
          when = terminalWhen;
        }
        {
          key = "ctrl+t";
          command = toggleTerminal;
          when = terminalWhen;
        }
        {
          key = "escape";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus && !terminalFindVisible && !terminalSuggestWidgetVisible";
        }

        # Karabiner turns Linux Ctrl shortcuts into Cmd shortcuts in GUI apps.
        # Convert them back to control characters inside VS Code's terminal.
        (terminalSequence "cmd+a" (builtins.fromJSON ''"\u0001"''))
        (terminalSequence "cmd+b" (builtins.fromJSON ''"\u0002"''))
        (terminalSequence "cmd+c" (builtins.fromJSON ''"\u0003"''))
        (terminalSequence "cmd+d" (builtins.fromJSON ''"\u0004"''))
        (terminalSequence "cmd+f" (builtins.fromJSON ''"\u0006"''))
        (terminalSequence "cmd+g" (builtins.fromJSON ''"\u0007"''))
        (terminalSequence "cmd+i" (builtins.fromJSON ''"\u0009"''))
        (terminalSequence "cmd+k" (builtins.fromJSON ''"\u000b"''))
        (terminalSequence "cmd+l" (builtins.fromJSON ''"\u000c"''))
        (terminalSequence "cmd+n" (builtins.fromJSON ''"\u000e"''))
        (terminalSequence "cmd+o" (builtins.fromJSON ''"\u000f"''))
        (terminalSequence "cmd+p" (builtins.fromJSON ''"\u0010"''))
        (terminalSequence "cmd+q" (builtins.fromJSON ''"\u0011"''))
        (terminalSequence "cmd+r" (builtins.fromJSON ''"\u0012"''))
        (terminalSequence "cmd+s" (builtins.fromJSON ''"\u0013"''))
        (terminalSequence "cmd+t" (builtins.fromJSON ''"\u0014"''))
        (terminalSequence "cmd+v" (builtins.fromJSON ''"\u0016"''))
        (terminalSequence "cmd+w" (builtins.fromJSON ''"\u0017"''))
        (terminalSequence "cmd+x" (builtins.fromJSON ''"\u0018"''))
        (terminalSequence "cmd+shift+z" (builtins.fromJSON ''"\u0019"''))
        (terminalSequence "cmd+z" (builtins.fromJSON ''"\u001a"''))
        {
          key = "cmd+shift+c";
          command = "workbench.action.terminal.copySelection";
          when = "terminalFocus";
        }
        {
          key = "cmd+shift+v";
          command = "workbench.action.terminal.paste";
          when = "terminalFocus";
        }
      ];
    };
  };
}
