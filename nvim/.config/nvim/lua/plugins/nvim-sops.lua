return {
  "lucidph3nx/nvim-sops",
  event = { "BufEnter" },
  keys = {
    { "<leader>se", vim.cmd.SopsEncrypt, desc = "[S]ops [E]ncrypt File" },
    { "<leader>sd", vim.cmd.SopsDecrypt, desc = "[S]ops [D]ecrypt File" },
  },
}
