return function(on_attach)
    local function get_python_path(workspace)
        local path = require('lspconfig/util').path
        local exepath = require('lspconfig/util').exepath

        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
            print("HERE")
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
        on_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
        on_attach = on_attach,
    }
end
