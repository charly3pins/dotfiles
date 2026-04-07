return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig_defaults = require("lspconfig").util.default_config
      lspconfig_defaults.capabilities =
        vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
          vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
          vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
          vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
          vim.keymap.set("n", "gr", "<cmd>lua vi.lsp.buf.references()<cr>", opts)
          vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

          vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
          vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
          local function toggle_diagnostic_virtual_lines()
            local current_config = vim.diagnostic.config()
            local new_value = not current_config.virtual_lines
            vim.diagnostic.config { virtual_lines = new_value }
          end
          vim.keymap.set("n", "<leader>dl", toggle_diagnostic_virtual_lines, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

          vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
          -- Formatting is handled by conform.nvim
          -- Use <leader>gf for formatting
          vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        end,
      })

      -- Setup mason and mason-lspconfig
      require("mason").setup {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      }

      require("mason-lspconfig").setup {
        ensure_installed = {
          "bashls",
          "cssls",
          "dockerls",
          "gopls",
          "html",
          "htmx",
          "lua_ls",
          "pyright",
          "sqlls",
          "tailwindcss",
          "templ",
          "terraformls",
          "ts_ls",
        },
      }

      -- LSP server-specific configurations
      -- Using vim.lsp.config (Neovim 0.11+ API)
      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            format = {
              convertQuotes = "single",
            },
          },
          javascript = {
            format = {
              convertQuotes = "single",
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
        callback = function(args)
          local clients = vim.lsp.get_clients { bufnr = args.buf }
          for _, client in ipairs(clients) do
            if client.name == "ts_ls" then
              local params = vim.lsp.util.make_range_params(vim.fn.bufwinid(args.buf), client.offset_encoding)
              params.context = { only = { "source.organizeImports" } }
              client.request("textDocument/codeAction", params, function(err, res)
                if err or not res or #res == 0 then
                  return
                end
                local action = res[1]
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit)
                end
              end, args.buf)
            end
          end
        end,
      })
    end,
  },
}
