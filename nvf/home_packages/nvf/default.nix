{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere entryAfter;
  inherit (lib.generators) mkLuaInline;
in {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "onedark";
        style = "darker";
        transparent = true;
      };
      ui.borders.enable = true;

      luaConfigRC.mini-comment = entryAfter ["globalsScript"] ''
        require("mini.comment").setup({
          mappings = {
            comment = "<leader>/",
            comment_line = "<leader>/",
            comment_visual = "<leader>/",
            textobject = "<leader>/",
          },
        })
      '';
      startPlugins = [pkgs.vimPlugins.mini-nvim];
      options = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        softtabstop = 2;
      };
      dashboard.alpha.enable = true;
      lazy.plugins.alpha-nvim.after = ''
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⡀⠀⠀⡐⡕⡱⡀⠀⡌⡎⡲⡠⠀⡀⡆⡇⢆⠀⠀⠀⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢜⢌⢎⠤⡐⡜⡜⢜⠜⡜⡌⡎⡪⡪⡊⡎⡜⢜⠬⡠⡢⡱⣑⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⢜⢔⢄⢄⢕⢅⢇⠇⡇⢇⢎⢎⢎⢎⢪⢸⢨⢢⢣⢃⢇⢇⠇⡇⡎⢎⢆⢎⢄⢔⢔⢕⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⢐⢅⢇⢕⢕⢅⢇⢕⢕⢕⠕⡕⡱⡸⡨⡪⢪⢊⢎⢪⢊⢎⢆⢇⢇⢎⢎⢎⢜⢌⢆⢇⢎⠂⠀⢀⢀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢄⢆⠅⠀⠀⢀⡀⠀",
                "⠀⠀⡀⡄⠀⠨⢪⢒⢄⡀⠀⠀⠀⠀⠀⠀⠀⠨⡪⡪⢪⢢⠣⡣⡱⡸⡰⡱⡡⡣⡪⡪⢪⢊⢎⢜⢜⠜⡜⢜⢜⢸⢰⢱⢸⢰⢱⢡⢣⢱⢑⢕⢅⢇⢕⢕⢕⢱⠁⠀⠀⠀⠀⠀⢠⠸⡨⡢⡣⠁⠀⠀⡢⣒⠀",
                "⠀⢔⢕⢜⠀⠀⢕⠕⡕⢜⢄⠀⠀⠀⠀⠀⠀⠈⡢⡣⢣⢃⢇⢇⢣⢱⢱⢸⢨⢪⠢⡣⡣⢣⢣⢱⢸⠸⡸⡘⡌⡎⡪⡢⡣⡱⡡⡣⡱⡑⡕⡅⡇⡕⢕⢅⢇⢕⠁⠀⠀⠀⠀⢐⢜⢜⠜⡜⠬⠀⢀⢰⢑⢆⡃",
                "⠨⡪⡢⡣⡣⡀⢕⢕⢕⠕⡕⡄⠀⠀⡪⡪⡊⡎⢆⢇⢇⢇⢕⢕⢱⢑⢕⢜⢌⢆⢇⢇⢎⢎⢪⢸⢘⢜⠜⡜⢜⢜⢸⢨⢪⢸⢨⠪⡊⡎⡪⡸⡨⡪⡪⡪⡸⡰⡱⡱⡑⡕⠀⢪⢢⠣⡣⡣⢫⢐⢜⠜⡜⡔⠀",
                "⠈⢪⢢⢣⢪⠪⡢⢣⠪⡪⡪⡂⠀⠀⠐⡱⡡⡣⡣⢣⢪⢢⢣⢱⠱⡑⡕⡅⡇⡣⡱⡑⡅⡇⢇⢣⠣⡃⡇⢇⢇⢕⢕⢱⢡⢣⢱⢱⢱⠱⡑⡕⢕⢱⢸⢨⢪⢸⢰⢑⢕⠁⠀⠐⢕⠕⡕⡜⡜⢜⠜⡜⡌⠂⠀",
                "⠀⠀⠑⡕⡜⢜⢜⢜⢜⢌⠖⠠⡐⡔⡔⡜⡌⡆⡇⡇⡣⡱⡡⡣⡣⡣⡣⡱⡑⡕⢕⠕⡕⢕⢕⢕⢕⢕⢕⠕⡕⡅⡇⡣⡱⡑⡕⡅⡇⡣⡣⡣⡣⡣⢣⢱⢑⢅⢇⢣⢕⢔⢔⢄⠅⡣⡣⡱⡸⡸⡸⠈⠀⠀⠀",
                "⠀⠀⠀⠀⠘⠘⢔⢕⢜⠬⡀⠈⢎⢪⢸⢰⠱⡑⡕⡜⡜⢜⢌⢎⢆⢇⢎⢪⠪⡪⡪⣪⣾⣆⠀⠁⠪⡢⡣⢣⠣⡪⢪⣾⣆⠈⠈⢎⢜⢜⢌⢆⢇⢎⢎⢎⢪⠪⡪⡊⡆⡇⡕⢥⢑⢜⢌⢎⠊⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠱⡡⡣⡣⡒⡄⡇⡣⡱⡱⡱⡑⡕⡜⡜⢜⢔⢕⢜⢜⢸⢸⢨⠢⠹⣿⡿⠀⠀⠀⢕⢜⢜⢜⠌⠸⣿⡟⠀⠀⠨⡪⡢⡣⡱⡡⡣⡱⡸⡸⡸⡘⡌⡎⡪⡸⡸⡘⡌⠎⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢜⠜⡌⡎⢎⢪⢪⢸⢘⢌⢎⢪⢪⢢⢣⢱⢸⠸⡰⡱⡡⠀⠀⠀⠀⠀⠀⢜⢌⢆⢇⠆⠀⠀⠀⠀⠀⢐⢜⢔⢕⢱⢑⢕⢱⠱⡸⡨⡪⡪⢪⠪⡊⡎⡪⢌⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⢀⢔⢕⠕⡕⢕⠕⡱⡑⡅⡇⢇⢣⢣⢱⢸⢨⢪⢢⢣⢣⢱⢸⢰⢀⡀⡀⡠⡸⡘⡜⡌⡖⢍⢆⡀⣀⢠⢰⢸⢰⢑⢕⢱⢑⢕⠕⡕⢕⢱⠱⠸⡘⠜⢜⠜⡜⡌⡇⡕⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠐⢕⢜⢜⢜⢌⠐⠔⡐⡡⢊⢑⠕⡱⢑⢅⢇⢕⢅⢇⢕⢕⢱⢑⢕⢜⢜⠜⣌⠊⠊⠘⠈⠊⡢⡣⡱⡑⡅⡇⡎⢎⢪⠪⡪⢢⠣⢃⠣⠑⠌⠌⡐⠅⠅⡣⡣⡱⡑⠕⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠆⡇⡎⡪⡄⠈⠔⡐⡀⠀⠈⠀⠑⠐⠡⡡⠑⢅⠣⡑⢕⠱⡡⢣⠪⡪⢢⢣⢢⢠⢰⠸⡘⡌⢎⠪⡊⡊⡊⡪⢘⠨⠂⠅⠊⠀⠁⠀⠀⡐⠌⠌⢐⢜⢌⢎⠊⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢎⢪⢪⢡⠀⠂⡊⠄⠀⠀⠀⠀⠀⠀⠈⠀⠈⠀⠂⠁⠈⠂⠁⠈⠂⠂⠂⠂⠂⠑⠈⠐⠁⠊⠐⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡐⠌⠂⠠⡪⢪⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠱⡑⡕⡀⠀⠑⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠌⠀⠠⡸⡸⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠊⡎⡂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢜⠌⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠪⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠎⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ",
        }

        -- -- Кнопки меню
        -- dashboard.section.buttons.val = {
        --   dashboard.button("f", "  Найти файл",    ":Telescope find_files<CR>"),
        --   dashboard.button("r", "  Недавние файлы", ":Telescope oldfiles<CR>"),
        --   dashboard.button("g", "  Поиск текста",  ":Telescope live_grep<CR>"),
        --   dashboard.button("n", "  Новый файл",    ":ene <BAR> startinsert<CR>"),
        --   dashboard.button("q", "  Выйти",         ":qa<CR>"),
        -- }

        -- Футер
        dashboard.section.footer.val = "Crab worlD"
        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"

        local function set_alpha_colors()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#e63a00" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#a63a00" })
        end

        -- Применяем сразу и при каждой смене темы
        set_alpha_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_alpha_colors,
        })

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.footer.opts.hl = "AlphaFooter"

        alpha.setup(dashboard.opts)
      '';
      luaConfigRC.rounded-borders = entryAnywhere ''
        -- LSP окна (hover, diagnostics)
        vim.lsp.handlers["textDocument/hover"] =
          vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

        vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

        vim.diagnostic.config({
          float = { border = "rounded" },
        })

        -- Все floating окна по умолчанию
        local orig_open_win = vim.api.nvim_open_win
        vim.api.nvim_open_win = function(buf, enter, opts)
          if opts.relative and opts.relative ~= "" and not opts.border then
            opts.border = "rounded"
          end
          return orig_open_win(buf, enter, opts)
        end
      '';

      extraPlugins = {
        nvim-colorizer = {
          package = pkgs.vimPlugins.nvim-colorizer-lua;
        };
        render-markdown = {
          package = pkgs.vimPlugins.render-markdown-nvim;
          setup = ''
            require('render-markdown').setup({})
          '';
        };
        image-nvim = {
          package = pkgs.vimPlugins.image-nvim;
          setup = ''
            require('image').setup({
              backend = "kitty", -- или "ueberzug", "sixel"
              integrations = {
                markdown = {
                  enabled = true,
                  clear_in_insert_mode = false,
                  download_remote_images = true,
                  only_render_image_at_cursor = false,
                },
                typst = {
                  enabled = false,
                },
              },
              max_width = 100,
              max_height = 20,
            })
          '';
        };
      };

      luaConfigRC.colorizer = ''
        require("colorizer").setup({
          filetypes = { "*" },
          user_default_options = {
            RGB      = true,
            RRGGBB   = true,
            names    = true,
            RRGGBBAA = true,
            rgb_fn   = true,
            hsl_fn   = true,
            css      = true,
            css_fn   = true,
            mode     = "background", -- "foreground" or "virtualtext"
          },
        })
      '';

      lazy.plugins.conform-nvim.after = ''
        local conform = require("conform")
        conform.formatters.sqlfluff = {
          command = "sqlfluff-tsql",
          stdin = false,
        }
        conform.formatters_by_ft.sql = { "sqlfluff" }

        require("conform").setup({
          format_on_save = {
            timeout_ms = 10000,
            lsp_fallback = false,
          },
        })
      '';

      extraPackages = with pkgs; [
        wl-clipboard
        imagemagick
        sqlfluff
        (pkgs.writeShellScriptBin "sqlfluff-tsql" ''
          tmpfile=$(mktemp /tmp/sqlfluff-XXXXXX.sql)
          cat | sed 's/#\([A-Za-z]\)/__TEMP__\1/g' > "$tmpfile"
          sqlfluff fix --dialect tsql --disable-progress-bar "$tmpfile" > /dev/null 2>&1
          cat "$tmpfile" | sed 's/__TEMP__\([A-Za-z]\)/#\1/g'
          rm -f "$tmpfile"
        '')
      ];
      binds = {
        whichKey.enable = true;
      };

      terminal.toggleterm = {
        enable = true;
        setupOpts.float_opts.border = "rounded";
        lazygit.enable = true;
      };

      filetree.neo-tree = {
        enable = true;
        setupOpts = {
          close_if_last_window = true;
          auto_clean_after_session_restore = true;
          sources = [
            "filesystem"
            "buffers"
            "git_status"
            "diagnostics"
          ];
          source_selector = {
            winbar = true;
            statusline = false;
            content_layout = "center";
            tabs_layout = "equal";
            show_separator_on_edge = false;
            sources = [
              {
                source = "filesystem";
                display_name = "  File";
              }
              {
                source = "buffers";
                display_name = " 󰈚 Bufs";
              }
              {
                source = "git_status";
                display_name = " 󰊢 Git";
              }
              {
                source = "diagnostics";
                display_name = " 󰒡 Diagnostic";
              }
            ];
          };
          default_component_configs = {
            indent = {
              indent_size = 2;
              padding = 0;
              with_markers = true;
              indent_marker = "│";
              last_indent_marker = "└";
              highlight = "NeoTreeIndentMarker";
              with_expanders = true;
              expander_collapsed = "";
              expander_expanded = "";
              expander_highlight = "NeoTreeExpander";
            };
            icon = {
              folder_closed = "";
              folder_open = "";
              folder_empty = "";
              folder_empty_open = "";
              default = "󰈙";
              highlight = "NeoTreeFileIcon";
            };
            modified = {
              symbol = "";
              highlight = "NeoTreeModified";
            };
            git_status = {
              symbols = {
                added = "";
                deleted = "";
                modified = "";
                renamed = "➜";
                untracked = "★";
                ignored = "◌";
                unstaged = "✗";
                staged = "✓";
                conflict = "";
              };
            };
          };
          commands = {
            system_open = mkLuaInline ''
              function(state)
                (vim.ui.open or vim.fn.jobstart)({ "xdg-open", state.tree:get_node():get_id() })
              end
            '';
            parent_or_close = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                if node:has_children() and node:is_expanded() then
                  state.commands.toggle_node(state)
                else
                  require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                end
              end
            '';
            child_or_open = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                if node:has_children() then
                  if not node:is_expanded() then
                    state.commands.toggle_node(state)
                  else
                    if node.type == "file" then
                      state.commands.open(state)
                    else
                      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                    end
                  end
                else
                  state.commands.open(state)
                end
              end
            '';
            copy_selector = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local filename = node.name
                local modify = vim.fn.fnamemodify

                local vals = {
                  ["BASENAME"] = modify(filename, ":r"),
                  ["EXTENSION"] = modify(filename, ":e"),
                  ["FILENAME"] = filename,
                  ["PATH (CWD)"] = modify(filepath, ":."),
                  ["PATH (HOME)"] = modify(filepath, ":~"),
                  ["PATH"] = filepath,
                  ["URI"] = vim.uri_from_fname(filepath),
                }

                local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
                if vim.tbl_isempty(options) then
                  vim.notify("No values to copy", vim.log.levels.WARN)
                  return
                end
                table.sort(options)
                vim.ui.select(options, {
                  prompt = "Choose to copy to clipboard:",
                  format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
                }, function(choice)
                  local result = vals[choice]
                  if result then
                    vim.notify(("Copied: " .. result))
                    vim.fn.setreg("+", result)
                  end
                end)
              end
            '';
            find_in_dir = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("telescope.builtin").find_files({ cwd = path })
              end
            '';
            toggleterm_float = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("toggleterm.terminal").Terminal:new({ dir = path, direction = "float" }):toggle()
              end
            '';
            toggleterm_horizontal = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("toggleterm.terminal").Terminal:new({ dir = path, direction = "horizontal" }):toggle()
              end
            '';
            toggleterm_vertical = mkLuaInline ''
              function(state)
                local node = state.tree:get_node()
                local path = node.type == "file" and node:get_parent_id() or node:get_id()
                require("toggleterm.terminal").Terminal:new({ dir = path, direction = "vertical" }):toggle()
              end
            '';
          };
          window = {
            width = 30;
            mappings = {
              "<space>" = false;
              "[b" = "prev_source";
              "]b" = "next_source";
              "F" = "find_in_dir";
              "O" = "system_open";
              "<S-CR>" = "system_open";
              "Y" = "copy_selector";
              "h" = "parent_or_close";
              "l" = "child_or_open";
              "Tf" = "toggleterm_float";
              "Th" = "toggleterm_horizontal";
              "Tv" = "toggleterm_vertical";
            };
            fuzzy_finder_mappings = {
              "<C-j>" = "move_cursor_down";
              "<C-k>" = "move_cursor_up";
            };
          };
          filesystem = {
            follow_current_file = {
              enabled = true;
              leave_dirs_open = false;
            };
            hijack_netrw_behavior = "open_current";
            use_libuv_file_watcher = true;
            filtered_items = {
              hide_gitignored = true;
              hide_dotfiles = false;
            };
          };
          event_handlers = [
            {
              event = "neo_tree_buffer_enter";
              handler = mkLuaInline ''
                function(_)
                  vim.opt_local.signcolumn = "auto"
                  vim.opt_local.foldcolumn = "0"
                end
              '';
            }
          ];
        };
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      statusline.lualine = {
        enable = true;
        # theme = "tokyonight";
      };
      # luaConfigRC.lualine-custom = entryAfter ["lualine"] ''
      #   require("lualine").setup({
      #     options = {
      #       theme = "tokyonight",
      #       component_separators = { left = "+", right = "+" },
      #       section_separators   = { left = "+", right = "+" },
      #     },
      #   })
      # '';

      tabline = {
        nvimBufferline.enable = true;
      };
      telescope.enable = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        lspconfig.enable = true;
        lspSignature.enable = true;
      };

      autocomplete.nvim-cmp.enable = true;

      languages = {
        nix = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
          # format.type = "alejandra";
        };
        markdown = {
          enable = true;
          treesitter.enable = true;
        };
        python = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
          # format.type = "black"; # или "ruff"
        };
        lua = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };
        sql = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          format.type = ["sqlfluff"];
          treesitter.enable = true;
        };
        rust = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };
        go = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          treesitter.enable = true;
        };
        clang = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          #format.enable = true;
        };
        bash = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        terraform = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        hcl = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        tex = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
        typescript = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          #format.enable = true;
        };
        json = {
          enable = true;
          # lsp.enable = true;
          treesitter.enable = true;
          format.enable = true;
        };
      };

      keymaps = [
        {
          key = "<Esc>";
          mode = "n";
          action = "<cmd>nohlsearch<CR>";
          silent = true;
          desc = "Снять подсветку поиска";
        }
        {
          # Открыть/закрыть дерево
          key = "<leader>e";
          mode = "n";
          action = "<cmd>Neotree toggle<CR>";
          silent = true;
          desc = "Toggle file tree";
        }
        {
          # Переключить фокус на дерево / обратно
          key = "<leader>o";
          mode = "n";
          action = "<cmd>lua if vim.bo.filetype == 'neo-tree' then vim.cmd.wincmd('p') else vim.cmd.Neotree('focus') end<CR>";
          silent = true;
          desc = "Toggle file tree focus";
        }
        {
          key = "<leader>c";
          mode = "n";
          action = "<cmd>Bdelete<CR>";
          silent = true;
          desc = "Close buffer";
        }
        # Отключаем Cmd+Space во всех режимах
        {
          key = "<D-Space>";
          mode = "n";
          action = "<Nop>";
          noremap = true;
        }
        {
          key = "<D-Space>";
          mode = "v";
          action = "<Nop>";
          noremap = true;
        }
        {
          key = "<D-Space>";
          mode = "i";
          action = "<Nop>";
          noremap = true;
        }

        # Tab — следующий буфер, Shift+Tab — предыдущий
        {
          key = "<Tab>";
          mode = "n";
          action = "<cmd>bnext<CR>";
          silent = true;
          desc = "Следующий буфер";
        }
        {
          key = "<S-Tab>";
          mode = "n";
          action = "<cmd>bprevious<CR>";
          silent = true;
          desc = "Предыдущий буфер";
        }
        # Плавающий терминал
        {
          key = "<leader>tf";
          mode = "n";
          action = "<cmd>ToggleTerm direction=float<CR>";
          silent = true;
          desc = "Плавающий терминал";
        }
        # Горизонтальный снизу
        {
          key = "<leader>th";
          mode = "n";
          action = "<cmd>ToggleTerm direction=horizontal<CR>";
          silent = true;
          desc = "Горизонтальный терминал";
        }
        # Вертикальный справа
        {
          key = "<leader>tv";
          mode = "n";
          action = "<cmd>ToggleTerm direction=vertical<CR>";
          silent = true;
          desc = "Вертикальный терминал";
        }
        {
          key = "<C-'>";
          mode = ["n" "i" "v" "t"];
          action = "<cmd>ToggleTerm<CR>";
          silent = true;
          desc = "toggle terminal";
        }
        # Закрыть терминал по Esc (внутри терминального режима)
        {
          key = "<Esc>";
          mode = "t";
          action = "<C-\\><C-n>";
          silent = true;
          desc = "Выйти из терминального режима";
        }
        {
          key = "<C-s>";
          mode = ["n" "i" "v"];
          action = "<cmd>w<CR>";
          silent = true;
          desc = "Сохранить файл";
        }
        # Изменение размера сплитов
        {
          key = "<C-Up>";
          mode = "n";
          action = "<cmd>resize +2<CR>";
          silent = true;
          desc = "Увеличить высоту";
        }
        {
          key = "<C-Down>";
          mode = "n";
          action = "<cmd>resize -2<CR>";
          silent = true;
          desc = "Уменьшить высоту";
        }
        {
          key = "<C-Left>";
          mode = "n";
          action = "<cmd>vertical resize -2<CR>";
          silent = true;
          desc = "Уменьшить ширину";
        }
        {
          key = "<C-Right>";
          mode = "n";
          action = "<cmd>vertical resize +2<CR>";
          silent = true;
          desc = "Увеличить ширину";
        }
      ];
    };
  };
}
