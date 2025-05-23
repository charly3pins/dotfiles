return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {}

    -- Open parent directory in current window
    vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    -- Open parent directory in floating window
    vim.keymap.set("n", "<space><space>-", require("oil").toggle_float)
  end,
}
