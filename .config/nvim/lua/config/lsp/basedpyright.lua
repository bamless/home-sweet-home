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

    local function organize_imports()
        local params = {
            command = 'basedpyright.organizeimports',
            arguments = { vim.uri_from_bufnr(0) },
        }

        local clients = vim.lsp.get_clients {
            bufnr = vim.api.nvim_get_current_buf(),
            name = 'basedpyright',
        }
        for _, client in ipairs(clients) do
            client:request('workspace/executeCommand', params, nil, 0)
        end
    end

    local on_attach = vim.lsp.config.basedpyright.on_attach
    vim.lsp.config('basedpyright', {
        before_init = function(_, config)
            if not config.settings.python then
                config.settings.python = {}
            end
            config.settings.python.pythonPath = get_python_path(config.root_dir or "")
        end,
        on_attach = function(client, bufnr)
            if on_attach ~= nil then
                on_attach(client, bufnr)
            end
            vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
                organize_imports()
            end, { desc = "Organize imports" })
            vim.keymap.set("n", "<leader>co", function()
                vim.cmd("LspPyrightOrganizeImports")
            end, { buffer = bufnr, remap = true })
        end,
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'openFilesOnly',
                    autoImportCompletions = true,
                    stubPath = vim.fn.stdpath("data") .. "/lazy/typeshed",
                },
            },
        },
    })
end
