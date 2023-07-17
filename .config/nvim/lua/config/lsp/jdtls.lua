return function()
    require('lspconfig').jdtls.setup {
        settings = {
            java = {
                signatureHelp = { enabled = true },
                inlayHints = {
                    parameterNames = { enabled = "literals" }
                },
            }
        }
    }
end
