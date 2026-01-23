require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "jsonls", "yamlls", "taplo", "pyright" }

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end
