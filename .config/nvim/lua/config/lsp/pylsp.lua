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
                    -- Rewrite it in rust!
                    ruff = { enabled = true },
                    -- type checker
                    pylsp_mypy = {
                        enabled = true,
                        overrides = { '--ignore-missing-imports', '--check-untyped-defs', true },
                        live_mode = true
                    },
                    -- import sorting
                    pyls_isort = { enabled = true },
                    -- This is *really* slow, disable it for now
                    -- rope_autoimport = { enabled = true },
                }
            }
        }
    }
end
