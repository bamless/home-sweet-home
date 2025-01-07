return function()
    local function get_python_path(workspace)
        local exepath = vim.fn.exepath
        local path = require('lspconfig/util').path

        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
            return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
        end

        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({ '*', '.*' }) do
            local match = vim.fn.glob(path.join(workspace, pattern, 'pyvenv.cfg'))
            if match ~= '' then
                return path.join(path.dirname(match), 'bin', 'python')
            end
        end

        -- Fallback to system Python.
        return exepath('python3') or exepath('python') or 'python'
    end

    require('lspconfig').basedpyright.setup {
        before_init = function(_, config)
            if not config.settings.python then
                config.settings.python = {}
            end
            config.settings.python.pythonPath = get_python_path(config.root_dir or "")
        end,
        on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>co", function()
                vim.cmd("PyrightOrganizeImports")
            end, { buffer = bufnr, remap = false })
        end,
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'openFilesOnly',
                },
            },
        }
    }
end
