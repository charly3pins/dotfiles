return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require "cmp"
      local cmp_select = { behavior = cmp.SelectBehavior.Insert }
      cmp.setup {
        sources = {
          { name = "nvim_lsp" },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm { select = true },
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<Tab>"] = cmp.mapping.select_next_item { behaviour = cmp.SelectBehavior.Insert },
          ["<S-Tab>"] = cmp.mapping.select_prev_item { behaviour = cmp.SelectBehavior.Insert },
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
      }
    end,
  },
}
