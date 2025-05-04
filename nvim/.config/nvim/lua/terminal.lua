local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
    vim.bo.filetype = "terminal"
  end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()

  -- Enter terminal mode automatically
  vim.defer_fn(function()
    vim.api.nvim_feedkeys("i", "n", false)
  end, 50)
end)

-- Closes terminal with C-d
vim.keymap.set({ "n", "t" }, "<C-d>", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd.close()
  end
end)
