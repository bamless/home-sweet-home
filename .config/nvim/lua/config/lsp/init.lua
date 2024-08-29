--local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
return {
    -- Language servers configurations
    lsps = {
        clangd = require('config.lsp.clangd'),
        lua_ls = require('config.lsp.lua_ls'),
        jdtls = require('config.lsp.jdtls'),
        pyright = require('config.lsp.pyright'),
        rust_analyzer = require('config.lsp.rust-analyzer'),
        tsserver = require('config.lsp.tsserver'),
        gopls = require('config.lsp.gopls'),
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
            --         vim.lsp.buf.format { async = false }
            --     end
            -- })
        end

        -- Enable inlay hints if supported by neovim and LSP
        if client.supports_method("textDocument/inlayHint") and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- Enable inlay hints by default
            vim.keymap.set("n", "<leader>h", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
            end, opts)
        end

        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)

        -- Other LSP function keybindings
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, opts)
        vim.keymap.set("n", "<leader>ss", telescope.treesitter, opts)
        vim.keymap.set("n", "<leader>sr", telescope.lsp_references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>dd", telescope.diagnostics, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
}
