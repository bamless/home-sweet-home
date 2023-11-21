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

    require('lspconfig').pyright.setup {
        before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
        settings = {
            pyright = {
                autoImportCompletion = true,
            },
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                }
            }
        }
    }
end
