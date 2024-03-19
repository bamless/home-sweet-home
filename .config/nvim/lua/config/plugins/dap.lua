local function setup_dap()
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

    ---
    -- C/C++
    ---

    dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = 'OpenDebugAD7',
    }

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            args = function()
                local argsString = vim.fn.input('Program Arguments: ')
                local args = {}
                for arg in argsString:gmatch("%S+") do
                    table.insert(args, arg)
                end
                return args
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
            setupCommands = {
                {
                    text = '-enable-pretty-printing',
                    description = 'enable pretty printing',
                    ignoreFailures = false
                },
            },
        },
    }

    dap.configurations.c = dap.configurations.cpp

    ---
    -- Python
    ---

    local debugpy_venv = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/debugpy/venv')

    dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
                type = 'server',
                port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                host = host,
                options = {
                    source_filetype = 'python',
                },
            })
        else
            cb({
                type = 'executable',
                command = debugpy_venv .. '/bin/python',
                args = { '-m', 'debugpy.adapter' },
                options = {
                    source_filetype = 'python',
                },
            })
        end
    end

    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                    return cwd .. '/venv/bin/python'
                elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                    return cwd .. '/.venv/bin/python'
                else
                    return '/usr/bin/python'
                end
            end,
        },
    }

    ---
    -- Javascript node
    ---

    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "js-debug-adapter",
            args = { "${port}" }
        }
    }

    dap.configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
        },
    }
    dap.configurations.typescript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (pwa-node with ts-node)",
            cwd = "${workspaceFolder}",
            runtimeArgs = {
                "--loader",
                "ts-node/esm"
            },
            runtimeExecutable = "node",
            args = {
                "${file}"
            },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = {
                "<node_internals>/**",
                "node_modules/**"
            },
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        }
    }

    ---
    -- Javascript Chrome
    ---

    dap.adapters.chrome = {
        type = "executable",
        command = "chrome-debug-adapter",
    }

    dap.configurations.javascriptreact = { -- change this to javascript if needed
        {
            type = "chrome",
            request = "launch",
            url = "http://localhost:3000",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}"
        }
    }

    dap.configurations.typescriptreact = { -- change to typescript if needed
        {
            type = "chrome",
            request = "launch",
            url = "http://localhost:3000",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}"
        }
    }

    ---
    -- Keybindings
    ---

    -- nvim-dap keymappings
    -- Press f5 to debug
    vim.keymap.set('n', '<F5>', [[:lua require'dap'.continue()<CR>]], {})
    -- Regular breakpoint
    vim.keymap.set('n', '<leader>br', [[:lua require'dap'.toggle_breakpoint()<CR>]], {})
    -- Breakpoint with Condition
    vim.keymap.set('n', '<leader>brc', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>]],
        {})
    -- Logpoint
    vim.keymap.set('n', '<leader>lgp',
        [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Msg: '))<CR>]],
        {})
    -- Press dl to run last ran configuration (if you used f5 before it will re run it etc)
    vim.keymap.set('n', '<leader>dl', [[:lua require'dap'.run_last()<CR>]], {})
    -- Pressing F10 to step over
    vim.keymap.set('n', '<F7>', [[:lua require'dap'.step_over()<CR>]], {})
    -- Pressing F11 to step into
    vim.keymap.set('n', '<F8>', [[:lua require'dap'.step_into()<CR>]], {})
    -- Pressing F12 to step out
    vim.keymap.set('n', '<F12>', [[:lua require'dap'.step_out()<CR>]], {})
    -- Press F6 to open REPL
    vim.keymap.set('n', '<F6>', [[:lua require'dap'.repl.open()<CR>]], {})
    -- Toggle debug mode, will remove NvimTree also
    vim.keymap.set('n', '<C-x>', [[:lua require'dapui'.toggle()<CR>]], {})
end

return {
    {
        "mfussenegger/nvim-dap",
        config = setup_dap,
        dependencies = { "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui" }
    },
    'theHamsta/nvim-dap-virtual-text',
}
