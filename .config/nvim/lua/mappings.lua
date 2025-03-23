require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>cc", ":VimtexCompile<CR>", { desc = "Vimtex: Compile" })
map("n", "<leader>cv", ":VimtexView<CR>", { desc = "Vimtex: View" })
map("n", "<leader>cq", ":VimtexStop<CR>", { desc = "Vimtex: Stop" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
