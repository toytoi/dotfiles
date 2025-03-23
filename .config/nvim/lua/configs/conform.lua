local options = {
   formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettier" },
      html = { "prettier" },
      -- c_cpp = { "clang-format" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      python = { "black", "isort" },
      -- java = { "google-java-format" },
   },
   formatters = {
      ["clang-format"] = {
         command = "clang-format",
         prepend_args = function()
            return {
               "-style=file",
               "--verbose",
               "--fallback-style=GNU",
            }
         end,
      },
      -- Lua
      stylua = {
         prepend_args = {
            "--column-width",
            "80",
            "--line-endings",
            "Unix",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "3",
            "--quote-style",
            "AutoPreferDouble",
         },
      },
      -- Python
      black = {
         command = "black",
         prepend_args = {
            "--line-length",
            "80",
         },
      },
      isort = {
         prepend_args = {
            "--profile",
            "black",
         },
      },
   },

   format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
   },
}

require("conform").setup(options)
