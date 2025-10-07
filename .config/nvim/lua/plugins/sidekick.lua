-- return {
--   "folke/sidekick.nvim",
--   event = "VeryLazy",
--   opts = {},
-- }
return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {},

  keys = {
    {
      "<leader>an",
      function()
        local sk = require "sidekick"
        if not sk.nes_jump_or_apply() then
          vim.notify("Theree no NES active suggestions", vim.log.levels.INFO)
        end
      end,
      mode = { "n", "i" },
      desc = "Sidekick: apply or skip NES suggestion",
    },
    {
      "<leader>ar",
      function()
        require("sidekick").nes_request()
      end,
      mode = { "n", "i" },
      desc = "Sidekick: force NES suggestion",
    },
  },
}
