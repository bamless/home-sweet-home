return function()
    require('lspconfig').rust_analyzer.setup {
        settings = {
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
                diagnostics = {
                    enable = true,
                    experimental = {
                        enable = true,
                    },
                },
                cargo = {
                     features = { "ssr", "csr" }
                }
            },
        },
    }
end
