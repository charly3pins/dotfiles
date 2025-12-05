return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>gf",
        function()
          require("conform").format { async = true, lsp_fallback = false }
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        go = { "goimports" },
      },

      formatters = {
        eslint_d = {
          args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        },
      },

      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    },
  },
}
