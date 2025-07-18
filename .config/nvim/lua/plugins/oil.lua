return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {
      default_file_explorer = true,
      columns = {},
      keymaps = {
        ["q"] = "actions.close",
      },
      delete_to_trash = true,
      view_options = { show_hidden = true },
      skip_confirmation_for_simple_edits = true,
    }

    -- Open parent directory in current window
    vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    -- Open parent directory in floating window
    vim.keymap.set("n", "<space><space>-", require("oil").toggle_float)
  end,
}
