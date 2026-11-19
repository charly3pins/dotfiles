local opencode_cmd = "opencode"
local sidebar = { win = { position = "right", width = 0.4 } }

return {
  "nickjvandyke/opencode.nvim",
  -- main supports OpenCode v2; tagged releases are v1-only
  branch = "main",
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

    -- Types "path:Lx-Ly " into the sidebar input without submitting, so it can't land in another session
    vim.keymap.set({ "n", "x" }, "<leader>oo", function()
      local a, b = vim.fn.line ".", vim.fn.line "v"
      if vim.fn.mode() == "n" then
        b = a
      end
      local ref = require("opencode").format {
        buf = 0,
        from = { math.min(a, b) },
        to = { math.max(a, b) },
        rel = vim.fn.getcwd(),
      }
      if not ref then
        return
      end
      local term = require("snacks.terminal").get(opencode_cmd, sidebar)
      vim.api.nvim_chan_send(vim.bo[term.buf].channel, ref .. " ")
      term:focus()
    end, { desc = "Put code reference in opencode sidebar" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "opencode prompts (explain/review/test…)" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator "@this "
    end, { desc = "Add range to opencode", expr = true })

    vim.keymap.set("n", "goo", function()
      return require("opencode").operator "@this " .. "_"
    end, { desc = "Add line to opencode", expr = true })
  end,
}
