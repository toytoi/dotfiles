-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {
    mason = {
        cmd = true,
        pkgs = {
            "lua-language-server",
            "stylua",
            "html-lsp",
            "css-lsp",
            "prettier",
            "clangd",
            "clang-format",
            "pyright",
            "jdtls",
            "typescript-language-server",
        },
    },
}

M.ui = {
    theme = "sweetpastel",
    cheatsheet = { theme = "simple" },
    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
    transparency = true,
}

M.base46 = {
    theme = "sweetpastel",
    transparency = true,
    changed_themes = {
        sweetpastel = {
            base_30 = {
                grey_fg = "#808080",
                -- grey_fg2 = "#ffb7c5",
                grey = "#e6d0d4",
                pink = "#ffb7c5",
                blue = "#b7e9ff",
                cyan = "#b7fff1",
                green = "#b7ffcd",
                vibrant_green = "#c5ffb7",
                purple = "#f1b7ff",
            },
        },
    },
}

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    highlight = { hex = true, lspvars = true },
}

M.cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
}

M.lsp = {
    siganture = true,
}

-- mason = { cmd = true, pkgs = {} },

return M
