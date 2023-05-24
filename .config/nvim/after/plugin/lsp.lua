local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local telescope = require('telescope.builtin')

    if client.supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
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
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end

lsp.on_attach(on_attach)
-- Call custom lst configurations
require('config.lsp')(on_attach)
lsp.setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = {
            spacing = 4,
        },
        -- Use a function to dynamically turn signs off
        -- and on, using buffer local variables
        signs = function(_, bufnr)
            return vim.b[bufnr].show_signs == true
        end,
        -- Disable a feature
        update_in_insert = false,
    }
)

vim.diagnostic.config({
    virtual_text = true
})
