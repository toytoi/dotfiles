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
        opts = {
            ensure_installed = {
                "vim",
                "cpp",
                "lua",
                "vimdoc",
                "html",
                "css",
                "java",
                "c",
            },
        },
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
