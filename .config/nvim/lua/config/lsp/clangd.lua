return function()
    local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
    require('lspconfig').clangd.setup {
        cmd = {
            mason_path .. "clangd",
            "--function-arg-placeholders=0",
            "--offset-encoding=utf-16",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--fallback-style=llvm",
        }
    }
end
