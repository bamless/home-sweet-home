return function()
    require('lspconfig').rust_analyzer.setup {
        settings = {
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    }
end
