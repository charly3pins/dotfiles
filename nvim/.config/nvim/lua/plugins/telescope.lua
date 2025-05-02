return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.setup {
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected items to quickfix list
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }
      local builtin = require "telescope.builtin"
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Fuzzy find files in cwd" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })

      require("telescope").load_extension "ui-select"
    end,
  },
}
