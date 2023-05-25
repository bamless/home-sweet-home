return function()
    require('lspconfig').ccls.setup {
        on_attach = require('config.lsp').on_attach,
        init_options = {
            compilationDatabaseDirectory = "build",
        },
    }
end
