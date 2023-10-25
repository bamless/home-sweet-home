return function()
    require('lspconfig').pylsp.setup {
        settings = {
            pylsp = {
                plugins = {
                    -- linter options
                    -- Rewrite it in rust!
                    ruff = {
                        enabled = true,
                        extendSelect = { "I" },
                        lineLength = 100,
                    },
                    -- type checker
                    pylsp_mypy = {
                        enabled = true,
                        overrides = { '--ignore-missing-imports', '--check-untyped-defs', true },
                        live_mode = true
                    },
                    -- Formatting
                    yapf = { enabled = true },
                    autopep8 = { enabled = false },
                    -- import sorting
                    pyls_isort = { enabled = true },
                    -- This is *really* slow, disable it for now
                    -- rope_autoimport = { enabled = true },
                }
            }
        }
    }
end
