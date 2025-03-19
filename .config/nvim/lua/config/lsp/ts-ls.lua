local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

return function()
    require('lspconfig').ts_ls.setup {
        settings = {
            typescript = {
                --inlayHints = {
                --    includeInlayParameterNameHints = 'all',
                --    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                --    includeInlayFunctionParameterTypeHints = true,
                --    includeInlayVariableTypeHints = true,
                --    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                --    includeInlayPropertyDeclarationTypeHints = true,
                --    includeInlayFunctionLikeReturnTypeHints = true,
                --    includeInlayEnumMemberValueHints = true,
                --}
            },
            javascript = {
                --inlayHints = {
                --    includeInlayParameterNameHints = 'all',
                --    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                --    includeInlayFunctionParameterTypeHints = true,
                --    includeInlayVariableTypeHints = true,
                --    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                --    includeInlayPropertyDeclarationTypeHints = true,
                --    includeInlayFunctionLikeReturnTypeHints = true,
                --    includeInlayEnumMemberValueHints = true,
                --}
            }
        },
        commands = {
            OrganizeImports = {
                organize_imports,
                description = "Organize Imports"
            }
        }
    }
end
