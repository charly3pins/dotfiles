return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require "mason"

    -- import mason-lspconfig
    local mason_lspconfig = require "mason-lspconfig"

    local mason_tool_installer = require "mason-tool-installer"

    -- enable mason and configure icons
    mason.setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    mason_lspconfig.setup {
      -- list of servers for mason to install
      ensure_installed = {
        "gopls",
        "lua_ls",
        "bashls",
        "html",
        "htmx",
        "tailwindcss",
        "templ",
        "terraformls",
        "ts_ls",
        "cssls",
        "pyright",
        "sqlls",
        "dockerls",
        "copilot",
      },
    }

    mason_tool_installer.setup {
      ensure_installed = {
        "prettier", -- formatter for json, html, css, markdown
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- js/ts linter and formatter
        "golangci-lint", -- go linter
      },
    }
    local lspconfig = require "lspconfig"

    lspconfig.ts_ls.setup {
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
    }
  end,
}
