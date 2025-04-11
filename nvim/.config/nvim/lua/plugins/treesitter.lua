return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"vrischmann/tree-sitter-templ",
		},
		config = function()
			vim.filetype.add({
				extension = {
					templ = "templ",
				},
			})
			local config = require("nvim-treesitter.configs")
			config.setup({
				-- auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				ensure_installed = {
					"go",
					"templ",
					"json",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"dart",
					"python",
				},
			})
		end,
	},
}
