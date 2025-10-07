vim.g.mapleader = " "

-- install lazy
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

-- add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

-- general setup
require "options"
require "keymaps"
require "filetypes"
require "autocmds"
require "terminal"

-- set up lazy, and load my `lua/plugins/` folder
require("lazy").setup({ import = "plugins" }, {
  ui = { border = "rounded" },
  change_detection = {
    notify = false,
  },
  -- no plugins use luarocks, better to disable this
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      -- Stuff I don't use.
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Active LSP from Copilot automtically if your Neovim is 0.11 or higher
if vim.fn.has "nvim-0.11" == 1 then
  vim.schedule(function()
    local ok, _ = pcall(vim.lsp.enable, "copilot")
    if ok then
      vim.notify("Copilot LSP enabled", vim.log.levels.INFO)
    end
  end)
end
