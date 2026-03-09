return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup {
      ensure_installed = {
        -- Formatters
        "black", -- python formatter
        "eslint_d", -- js/ts formatter
        "goimports", -- go formatter
        "isort", -- python import formatter
        "prettier", -- json, html, css, markdown formatter
        "stylua", -- lua formatter

        -- Linters
        "eslint_d", -- js/ts linter
        "golangci-lint", -- go linter
        "pylint", -- python linter
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    }
  end,
}
