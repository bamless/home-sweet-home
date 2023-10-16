local path = require('lspconfig/util').path

local mason_registry = require("mason-registry")
local pylsp = mason_registry.get_package("python-lsp-server")
local pylsp_path = pylsp:get_install_path()

if path.exists(pylsp_path) and not path.exists(pylsp_path .. '/venv/bin/mypy') then
    vim.cmd [[ PylspInstall pylsp-mypy ]]
    vim.cmd [[ PylspInstall pylsp-rope ]]
end
