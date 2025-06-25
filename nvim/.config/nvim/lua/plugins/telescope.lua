return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.setup {
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
        extensions = {
          fzf = {},
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }

      telescope.load_extension "fzf"
      telescope.load_extension "ui-select"

      local builtin = require "telescope.builtin"

      vim.keymap.set("n", "<space>fd", builtin.find_files, { desc = "Find files in directory" })
      vim.keymap.set("n", "<space>en", function()
        builtin.find_files {
          cwd = vim.fn.stdpath "config",
        }
      end, { desc = "Edit neovim config" })
      vim.keymap.set("n", "<leader>fg", require "plugins.telescope.multi-ripgrep", { desc = "Find string in cwd" })
    end,
  },
}
