return function()
    require('lspconfig').jdtls.setup {
        settings = {
            java = {
                signatureHelp = { enabled = true },
                completion = {
                    guessMethodArguments = false
                },
                inlayHints = {
                    parameterNames = { enabled = "literals" }
                },
            }
        }
    }
end
