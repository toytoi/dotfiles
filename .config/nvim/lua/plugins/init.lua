return {
   {
      "stevearc/conform.nvim",
      event = "BufWritePre", -- uncomment for format on save
      config = function()
         require "configs.conform"
      end,
   },

   -- These are some examples, uncomment them if you want to see them work!
   {
      "neovim/nvim-lspconfig",
      config = function()
         require("nvchad.configs.lspconfig").defaults()
         require "configs.lspconfig"
      end,
   },

   {
      "Julian/lean.nvim",
      event = { "BufReadPre *.lean", "BufNewFile *.lean" },
      dependencies = {
         "nvim-lua/plenary.nvim",
      },
      opts = {
         mappings = true,
      },
   },

   {
      "mfussenegger/nvim-lint",
      event = { "BufWritePost", "BufEnter", "InsertLeave" },
      config = function()
         require "configs.lint"
      end,
   },

   {
      "williamboman/mason.nvim",
      opts = {
         -- ensure_installed = {
         --     "lua-language-server",
         --     "stylua",
         --     "html-lsp",
         --     "css-lsp",
         --     "prettier",
         --     "clangd",
         --     "clang-format",
         --     "pyright",
         --     "jdtls",
         -- },
      },
   },

   {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
         opts.ensure_installed = opts.ensure_installed or {}
         vim.list_extend(opts.ensure_installed, {
            "vim",
            "cpp",
            "lua",
            "vimdoc",
            "html",
            "css",
            "java",
            "c",
            "markdown",
            "markdown_inline",
         })
         return opts
      end,
      config = function(_, opts)
         require("nvim-treesitter.configs").setup(opts)
         require("configs.treesitter_compat").setup()
      end,
   },

   {
      "nvim-lua/plenary.nvim",
      {
         "nvchad/ui",
         config = function()
            require "nvchad"
         end,
      },
   },

   {
      "lervag/vimtex",
      ft = { "tex", "markdown" },
      init = function()
         vim.g.tex_flavor = "latex"
         vim.g.vimtex_quickfix_mode = 0
         vim.g.vimtex_mappings_enabled = 1
         vim.g.vimtex_syntax_enabled = 1
         vim.g.vimtex_indent_enabled = 0

         vim.g.vimtex_view_method = "zathura"
         vim.g.vimtex_context_pdf_viewer = "zathura"
         vim.g.vimtex_view_skim_sync = 1
         vim.g.vimtex_view_skim_activate = 1
         -- vim.g.snipmate_snippets_path = '~/.config/snippets/'
      end,
   },
   {
      "iurimateus/luasnip-latex-snippets.nvim",
      -- vimtex isn't required if using treesitter
      requires = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
      config = function()
         require("luasnip-latex-snippets").setup()
         -- or setup({ use_treesitter = true })
         require("luasnip").config.setup { enable_autosnippets = true }
         -- Modify existing snippets using higher priority and util function from luasnip-latex-snippets
         local ls = require "luasnip"
         local s = ls.snippet
         local i = ls.insert_node
         local fmta = require("luasnip.extras.fmt").fmta
         local utils = require "luasnip-latex-snippets.util.utils"
         local not_math = utils.with_opts(utils.not_math, true) -- when using treesitter, change false to true

         ls.add_snippets("tex", {
            s(
               { trig = "mk", snippetType = "autosnippet", priority = 100 },
               fmta("$<>$<>", { i(1), i(2) }),
               { condition = not_math }
            ),
            -- ...
         })
      end,
   },

   {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown" },
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
      opts = {
         -- Rendered headings use bold + color highlights
         heading = {
            enabled = true,
            sign = false,
            icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
         },
         -- Code blocks get a background highlight
         code = {
            enabled = true,
            sign = false,
            style = "full",  -- "full" shows language label + background, "normal" just background
            width = "block",
         },
         -- Bullet points replaced with icons
         bullet = {
            enabled = true,
            icons = { "●", "○", "◆", "◇" },
         },
         -- Checkboxes
         checkbox = {
            enabled = true,
            unchecked = { icon = "󰄱 " },
            checked = { icon = "󰱒 " },
         },
         -- Tables get borders
         pipe_table = {
            enabled = true,
            style = "full",
         },
         -- Only render in normal mode so you can still edit cleanly
         render_modes = { "n", "c" },
      },
   },

   -- {
   --     "nvchad/base46",
   --     lazy = true,
   --     build = function()
   --         require("base46").load_all_highlights()
   --     end,
   -- },
   --
   -- {
   --     require "nvchad.lsp.renamer"(),
   -- },
}
