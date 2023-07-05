return {
    -- Language servers configurations
    lsps = {
        lua_ls = require('config.lsp.lua_ls'),
        jdtls = require('config.lsp.jdtls'),
        pyright = require('config.lsp.pyright'),
        rust_analyzer = require('config.lsp.rust-analyzer'),
        tsserver = require('config.lsp.tsserver'),
    },

    -- Keybindings configuration
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        local telescope = require('telescope.builtin')

        -- LSP formatting support
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
        end

        -- Enable inlay hints if supported by neovim and language server
        if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
            print("INLAY")
            vim.lsp.inlay_hint(bufnr, true) -- Enable inlay hints by default
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
    end,
}
