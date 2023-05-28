---
-- Configure LSP servers
---

local lsp_zero = require('lsp-zero')
local lsp_configs = require('config.lsp')

lsp_zero.extend_lspconfig {
    set_lsp_keymaps = false,
    on_attach = lsp_configs.on_attach
}

require('mason').setup()
require('mason-lspconfig').setup()

local handlers_config = {
    function(server_name)
        require('lspconfig')[server_name].setup {}
    end
}

local custom_configs = lsp_configs.lsp
for lsp_name, config_fn in pairs(custom_configs) do
    handlers_config[lsp_name] = config_fn
end

require('mason-lspconfig').setup_handlers(handlers_config)

---
-- Diagnostic config
---

lsp_zero.set_sign_icons {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
}

vim.diagnostic.config {
    virtual_text = true
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = {
            spacing = 4,
        },
        -- Disable a feature
        update_in_insert = false,
    }
)

---
-- Snippet config
---

require('luasnip').config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
})

require('luasnip.loaders.from_vscode').lazy_load()

---
-- Autocompletion
---

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require('cmp')
local cmp_config = lsp_zero.defaults.cmp_config({})
table.insert(cmp_config.sources, { name = 'nvim_lsp_signature_help' })
cmp.setup(cmp_config)

---
-- Lightbulb
---

-- Show a lightbulb icon when there are available LSP actions.
require("nvim-lightbulb").setup {
  sign = { enabled = false },
  virtual_text = { enabled = true, text = "💡" },
  autocmd = { enabled = true },
}
