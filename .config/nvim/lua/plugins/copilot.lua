return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = "<M-.>",
          accept_word = "<M-w>",
          accept_line = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-/>",
        },
      },
      filetypes = {
        markdown = true,
        yaml = true,
        go = true,
        lua = true,
      },
    },
  },
}
