---
-- Configure LSP servers
---

local lsp_zero = require('lsp-zero')
local lsp_configs = require('config.lsp')

lsp_zero.extend_lspconfig {
    set_lsp_keymaps = false,
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        local telescope = require('telescope.builtin')

        -- LSP formatting support
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
        end

        -- Enable inlay hints if supported by neovim and language server
        if client.supports_method("textDocument/inlayHints") and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint(bufnr, true)
            vim.keymap.set("n", "<leader>h", function() vim.lsp.inlay_hint(bufnr) end, opts)
        end

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>sr", function() telescope.lsp_references() end, opts)
        vim.keymap.set("n", "<leader>ss", function() telescope.treesitter() end, opts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>dd", function() telescope.diagnostics() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
}

require('mason').setup()
require('mason-lspconfig').setup()

local handlers_config = {
    function(server_name)
        require('lspconfig')[server_name].setup {}
    end
}

local custom_configs = lsp_configs
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
        update_in_insert = true,
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
