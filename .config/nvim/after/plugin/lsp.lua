---
-- Configure LSP servers
---

local lsp_zero = require('lsp-zero')
local lsp_configs = require('config.lsp')

lsp_zero.extend_lspconfig {
    set_lsp_keymaps = false,
    on_attach = lsp_configs.on_attach,
}

require('mason').setup()
require('mason-lspconfig').setup()

local handlers = {
    function(server_name)
        require('lspconfig')[server_name].setup {}
    end
}

local configs = lsp_configs.lsps
for lsp_name, config in pairs(configs) do
    handlers[lsp_name] = config
end

require('mason-lspconfig').setup_handlers(handlers)

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
        update_in_insert = false,
        severity_sort = true,
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
-- Limit size of autocompletion popup
cmp_config.formatting = {
  format = function(_, vim_item)
    vim_item.abbr = string.sub(vim_item.abbr, 1, 140)
    return vim_item
  end
}
-- table.insert(cmp_config.sources, { name = 'nvim_lsp_signature_help' })
cmp.setup(cmp_config)

require('lsp_signature').setup {
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
        border = "single"
    },
    hint_enable = false,
    doc_lines = 0,
}

---
-- Lightbulb
---

-- Show a lightbulb icon when there are available LSP actions.
require("nvim-lightbulb").setup {
    sign = { enabled = false },
    virtual_text = { enabled = true, text = "💡" },
    autocmd = { enabled = true },
}
