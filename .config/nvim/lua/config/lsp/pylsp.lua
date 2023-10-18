return function()
    require('lspconfig').pylsp.setup {
        settings = {
            pylsp = {
                plugins = {
                    -- linter options
                    pylint = { enabled = false },
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    flake8 = { enabled = false },
                    ruff = { enabled = true },
                    -- type checker
                    pylsp_mypy = {
                        enabled = true,
                        overrides = { '--ignore-missing-imports', true },
                        live_mode = true
                    },
                    -- import sorting
                    pyls_isort = { enabled = true },
                    -- rope_autoimport = { enabled = true },
                }
            }
        }
    }
end
