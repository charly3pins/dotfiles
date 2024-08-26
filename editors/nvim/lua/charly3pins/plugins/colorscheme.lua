return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		vim.cmd("colorscheme gruvbox")
	end,
}
-- return {
-- 	"folke/tokyonight.nvim",
-- 	priority = 1000, -- Make sure to load this before all the other start plugins.
-- 	init = function()
-- 		-- Load the colorscheme here.
-- 		-- Like many other themes, this one has different styles, and you could load
-- 		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
-- 		vim.cmd.colorscheme("tokyonight-night")
-- 	end,
-- }
-- return {
-- 	"craftzdog/solarized-osaka.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {},
-- 	config = function()
-- 		vim.cmd("colorscheme solarized-osaka")
-- 	end,
-- }
