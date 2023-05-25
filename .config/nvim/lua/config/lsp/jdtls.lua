return function()
    require('lspconfig').jdtls.setup {
        settings = {
            java = {
                signatureHelp = { enabled = true },
            }
        }
    }
end
