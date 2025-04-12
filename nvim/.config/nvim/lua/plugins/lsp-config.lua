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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            vim.cmd([[autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })]])
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.go",
                callback = function()
                    vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
                end,
            })

            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.templ.setup({
                capabilities = capabilities,
            })

            lspconfig.htmx.setup({
                capabilities = capabilities,
            })
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show documentation for what is under cursor" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Smart rename" })
            vim.keymap.set(
                "n",
                "<leader>D",
                "<cmd>Telescope diagnostics bufnr=0<CR>",
                { desc = "Show buffer diagnostics" }
            )
            vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

            local function toggle_diagnostic_virtual_lines()
                local current_config = vim.diagnostic.config()
                local new_value = not current_config.virtual_lines
                vim.diagnostic.config({ virtual_lines = new_value })
            end

            vim.keymap.set(
                "n",
                "<leader>dl",
                toggle_diagnostic_virtual_lines,
                { desc = "Toggle diagnostic virtual lines" }
            )
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })
        end,
    },
}
