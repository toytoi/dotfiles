local lint = require "lint"

lint.linters_by_ft = {
   python = { "flake8", "mypy" },
}

lint.linters.flake8.args = {
   "--max-line-length=120",
   "--max-complexity=10",
   "--select=B,B9,C,D,DAR,E,F,N,RST,S,W",
   "--ignore=E203,E501,RST201,RST203,RST301,W503,F401",
   "--per-file-ignores=tests/*:S101",
   "--format=%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
}

lint.linters.mypy.args = {
   "--strict",
   "--warn-unreachable",
   "--allow-untyped-calls",
   "--ignore-missing-imports",
   "--no-disallow-any-generics",
   "--implicit-reexport",
   "--show-column-numbers",
   "--no-error-summary",
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
   callback = function()
      local ft = vim.bo.filetype
      local linters = lint.linters_by_ft[ft] or {}
      local available = vim.tbl_filter(function(name)
         local linter = lint.linters[name]
         local cmd = type(linter) == "table" and linter.cmd or name
         return vim.fn.executable(cmd) == 1
      end, linters)
      if #available > 0 then
         lint.try_lint(available)
      end
   end,
})
