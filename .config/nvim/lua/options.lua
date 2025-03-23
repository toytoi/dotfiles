require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both"

o.expandtab = true
o.shiftwidth = 3
o.smartindent = true
o.tabstop = 3
o.softtabstop = 3

o.relativenumber = true

-- vim.api.nvim_create_autocmd("FileType", {
--    pattern = { "c", "cpp" },
--    callback = function()
--       vim.opt_local.tabstop = 2
--       vim.opt_local.shiftwidth = 2
--       vim.opt_local.softtabstop = 2
--    end,
-- })
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "c", "cpp" },
   callback = function()
      local current_file = vim.fn.expand "%:p" -- Get the absolute path of the current file
      local current_dir = vim.fn.expand "%:p:h" -- Get the directory of the current file
      local clang_format_path = current_dir .. "/.clang-format"

      if vim.fn.filereadable(clang_format_path) == 1 then
         -- .clang-format file exists, assume Linux kernel format (8-width tabs)
         vim.opt_local.tabstop = 8
         vim.opt_local.shiftwidth = 8
         vim.opt_local.softtabstop = 8
      else
         -- .clang-format file does not exist, use GNU format (2-width tabs)
         vim.opt_local.tabstop = 2
         vim.opt_local.shiftwidth = 2
         vim.opt_local.softtabstop = 2
      end
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = { "python" },
   callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
   end,
})

o.clipboard = "unnamedplus"
o.incsearch = true
o.ignorecase = true
o.smartcase = true

o.scrolloff = 8
o.sidescrolloff = 8

o.linebreak = true

o.swapfile = true
