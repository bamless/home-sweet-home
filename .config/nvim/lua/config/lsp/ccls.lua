return function(on_attach)
    require('lspconfig').ccls.setup {
        init_options = {
            compilationDatabaseDirectory = "build",
        },
        on_attach = on_attach,
    }
end
