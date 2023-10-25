-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
    -- Language servers configurations
    lsps = {
        clangd = require('config.lsp.clangd'),
        lua_ls = require('config.lsp.lua_ls'),
        jdtls = require('config.lsp.jdtls'),
        pylsp = require('config.lsp.pylsp'),
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

            -- Auto formatting on save
            -- vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --     group = augroup,
            --     buffer = bufnr,
            --     callback = function()
            --         vim.lsp.buf.format(opts)
            --     end
            -- })
        end

        -- Enable inlay hints if supported by neovim and LSP
        if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint(bufnr, true) -- Enable inlay hints by default
            vim.keymap.set("n", "<leader>h", function() vim.lsp.inlay_hint(bufnr) end, opts)
        end

        -- Add keymaps to trigger LSP functions
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>wr", function() telescope.lsp_references() end, opts)
        vim.keymap.set("n", "<leader>ws", function() telescope.lsp_dynamic_workspace_symbols() end, opts)
        vim.keymap.set("n", "<leader>ss", function() telescope.treesitter() end, opts)
        vim.keymap.set("n", "<leader>sr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>dd", function() telescope.diagnostics() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
}
