return function()
    -- We use nvim-jdtls, so this needs to be empty in order to not setup it two times
    -- require('lspconfig').jdtls.setup {
    --     on_attach = function(client, bufnr)
    --         local opts = { buffer = bufnr, remap = false }
    --         vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    --     end,
    --     settings = {
    --         java = {
    --             signatureHelp = { enabled = true },
    --             completion = {
    --                 guessMethodArguments = false
    --             },
    --             inlayHints = {
    --                 parameterNames = { enabled = "literals" }
    --             },
    --         }
    --     }
    -- }
end
