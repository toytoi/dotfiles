local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local servers = { "html", "cssls", "ts_ls", "pyright", "jdtls" }

-- Check if we are on Neovim 0.11 (which triggers the error)
if vim.fn.has "nvim-0.11" == 1 then
   -- 1. Setup standard servers
   for _, lsp in ipairs(servers) do
      -- Assign config to the native Neovim global
      vim.lsp.config[lsp] = {
         on_attach = on_attach,
         on_init = on_init,
         capabilities = capabilities,
      }
      -- Enable the server
      vim.lsp.enable(lsp)
   end

   -- 2. Setup clangd (Custom config)
   vim.lsp.config.clangd = {
      on_attach = function(client, bufnr)
         client.server_capabilities.documentFormattingProvider = false
         client.server_capabilities.documentRangeFormattingProvider = false
         on_attach(client, bufnr)
      end,
      on_init = on_init,
      capabilities = capabilities,
   }
   vim.lsp.enable "clangd"
else
   -- Fallback for Neovim 0.10 (The old way, to keep compatibility)
   local lspconfig = require "lspconfig"

   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = on_attach,
         on_init = on_init,
         capabilities = capabilities,
      }
   end

   lspconfig.clangd.setup {
      on_attach = function(client, bufnr)
         client.server_capabilities.documentFormattingProvider = false
         client.server_capabilities.documentRangeFormattingProvider = false
         on_attach(client, bufnr)
      end,
      on_init = on_init,
      capabilities = capabilities,
   }
end
