return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.diagnostics.golangci_lint,
        },
      }

      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup {
        ensure_installed = {
          "goimports",
          "golangci-lint",
          "prettier",
          "pylint",
          "stylua",
          "ts-standard",
        },
        handlers = {
          function() end, -- disables automatic setup of all null-ls sources
          stylua = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.stylua)
          end,
          shfmt = function(source_name, methods)
            -- custom logic
            require("mason-null-ls").default_setup(source_name, methods) -- to maintain default behavior
          end,
        },
      }
    end,
  },
}
