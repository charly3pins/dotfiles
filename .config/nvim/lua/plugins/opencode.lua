local opencode_cmd = "opencode --port"
local sidebar = { win = { position = "right", width = 0.4 } }

return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = { input = { enabled = true }, picker = { enabled = true }, terminal = { enabled = true } },
    },
  },
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, vim.tbl_deep_extend("force", sidebar, { win = { enter = false } }))
        end,
      },
    }

    vim.o.autoread = true

    -- Alt works through tmux and doesn't add <leader> lag in terminal mode
    vim.keymap.set({ "n", "t" }, "<M-o>", function()
      require("snacks.terminal").toggle(opencode_cmd, sidebar)
    end, { desc = "Toggle opencode sidebar" })

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask "@this: "
    end, { desc = "Ask opencode about this" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "opencode prompts (explain/review/test…)" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator "@this "
    end, { desc = "Add range to opencode", expr = true })

    vim.keymap.set("n", "goo", function()
      return require("opencode").operator "@this " .. "_"
    end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command "session.half.page.up"
    end, { desc = "Scroll opencode up" })

    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command "session.half.page.down"
    end, { desc = "Scroll opencode down" })
  end,
}
