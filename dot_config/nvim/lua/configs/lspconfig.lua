require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "jsonls", "yamlls", "taplo", "pyright" }

for _, lsp in ipairs(servers) do
  local cmd = vim.lsp.config[lsp] and vim.lsp.config[lsp].cmd
  if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
    vim.lsp.enable(lsp)
  end
end
