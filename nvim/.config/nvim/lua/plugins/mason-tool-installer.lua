return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup {
        ensure_installed = {
          "stylua",
          "prettier",
          "goimports",
          "golangci-lint",
          "eslint_d",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      }
    end,
  },
}
