return {
    "stevearc/oil.nvim",
    config = function()
        local oil = require("oil")
        oil.setup()
        vim.keymap.set("n", "<C-_>", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}
