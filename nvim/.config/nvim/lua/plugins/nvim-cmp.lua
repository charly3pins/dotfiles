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
          { name = "copilot" },
          { name = "nvim_lsp" },
        },
        window = {
          -- Make the completion menu bordered
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          -- Explicitly request documentation
          docs = { auto_open = false },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm { select = true },
          ["<C-Space>"] = cmp.mapping.complete(),
          ["/"] = cmp.mapping.close(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- local copilot = require "copilot.suggestion"
            -- if copilot.is_visible() then
            --   copilot.accept()
            -- else
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item { behaviour = cmp.SelectBehavior.Insert },
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ["<C-d>"] = function()
            if cmp.visible_docs() then
              cmp.close_docs()
            else
              cmp.open_docs()
            end
          end,
        },
      }
    end,
  },
}
