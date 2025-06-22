return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local lspconfig = require "lspconfig"
      lspconfig.gopls.setup {
        capabilities = capabilities,
      }

      vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })]]
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
        end,
      })
      local custom_format = function()
        if vim.bo.filetype == "templ" then
          local bufnr = vim.api.nvim_get_current_buf()
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local cmd = "templ fmt " .. vim.fn.shellescape(filename)

          vim.fn.jobstart(cmd, {
            on_exit = function()
              -- Reload the buffer only if it's still the current buffer
              if vim.api.nvim_get_current_buf() == bufnr then
                vim.cmd "e!"
              end
            end,
          })
        else
          vim.lsp.buf.format()
        end
      end
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.templ",
        callback = custom_format,
      })

      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { "html", "templ" },
      }
      lspconfig.templ.setup {
        capabilities = capabilities,
        filetypes = { "templ" },
        settings = {
          templ = {
            enable_snippets = true,
          },
        },
      }
      lspconfig.htmx.setup {
        capabilities = capabilities,
        filetypes = { "html", "templ" },
      }
      lspconfig.tailwindcss.setup {
        capabilities = capabilities,
        filetypes = { "templ", "astro", "javascript", "typescript", "react" },
        settings = {
          tailwindCSS = {
            includeLanguages = {
              templ = "html",
            },
          },
        },
      }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        -- cmd = { "npx", "typescript-language-server", "--stdio" },
      }

      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" })
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
      vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

      local function toggle_diagnostic_virtual_lines()
        local current_config = vim.diagnostic.config()
        local new_value = not current_config.virtual_lines
        vim.diagnostic.config { virtual_lines = new_value }
      end

      vim.keymap.set("n", "<leader>dl", toggle_diagnostic_virtual_lines, { desc = "Toggle diagnostic virtual lines" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })
    end,
  },
}
