return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				css = { "prettier", stop_after_first = true },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "yamlfmt" },
				markdown = { "prettier" },
				lua = { "stylua", stop_after_first = true },
				python = { "isort", "black" },
				-- go = { "goimports", "gofmt" },
				go = { "gofumpt", "golines", "goimports-reviser" }, -- testing mode
				templ = { "prettier" }, -- testing mode
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>cp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				if vim.g.disable_autoformat then
					return
				end
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
