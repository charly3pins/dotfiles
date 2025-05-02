local set = vim.keymap.set

set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- window management
set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
set("n", "<leader>ss", "<C-w>=", { desc = "Make splits same size" })
set("n", "<leader>sq", "<cmd>close<CR>", { desc = "Close current split" })

-- disable arrow keys in normal mode
set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- lua exec
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })
