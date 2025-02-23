return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- import mason_tool_installer
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"gopls",
				"html",
				"htmx",
				"lua_ls",
				"templ",
				"tailwindcss",
				"astro",
				-- "tsserver",
				"terraformls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"goimports", -- go formatter
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"golangci-lint", -- go linter
				"pylint", -- python linter
				"ts-standard", -- typescript formatter
			},
		})
	end,
}
