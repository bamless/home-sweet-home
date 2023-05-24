return function(on_attach)
    require('config.lsp.ccls')(on_attach)
    require('config.lsp.python')(on_attach)
end
