local function setup_dap()
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup {
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.25
            }, {
                id = "breakpoints",
                size = 0.25
            }, {
                id = "stacks",
                size = 0.25
            }, {
                id = "watches",
                size = 0.25
            } },
            position = "left",
            size = 60
        }, {
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
            position = "bottom",
            size = 20
        } },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '🔶', texthl = '', linehl = '', numhl = '' })

    ---
    -- C/C++/Rust
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
                local argsString = vim.fn.input('Program Arguments: ', '', 'file')
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
    dap.configurations.rust = dap.configurations.cpp

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
    vim.keymap.set('n', '<F10>', [[:lua require'dap'.step_over()<CR>]], {})
    -- Pressing F11 to step into
    vim.keymap.set('n', '<F11>', [[:lua require'dap'.step_into()<CR>]], {})
    -- Pressing F12 to step out
    vim.keymap.set('n', '<F12>', [[:lua require'dap'.step_out()<CR>]], {})
    -- Press F6 to open REPL
    vim.keymap.set('n', '<F6>', [[:lua require'dap'.repl.open()<CR>]], {})
    -- Toggle debug mode, will remove NvimTree also
    vim.keymap.set('n', '<leader>db', [[:lua require'dapui'.toggle()<CR>]], {})
end

return {
    {
        "mfussenegger/nvim-dap",
        config = setup_dap,
        keys = {
            '<F5>',
            '<leader>br',
            '<leader>brc',
            '<leader>lgp',
            '<leader>dl',
            '<F10>',
            '<F11>',
            '<F12>',
            '<F6>',
            '<leader>db',
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            {
                'theHamsta/nvim-dap-virtual-text',
                opts = {
                    enabled = true,                     -- enable this plugin (the default)
                    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                    show_stop_reason = true,            -- show stop reason when stopped for exceptions
                    commented = false,                  -- prefix virtual text with comment string
                    only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
                    all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
                    clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
                    --- A callback that determines how a variable is displayed or whether it should be omitted
                    display_callback = function(variable, buf, stackframe, node, options)
                        -- by default, strip out new line characters
                        if options.virt_text_pos == 'inline' then
                            return ' = ' .. variable.value:gsub("%s+", " ")
                        else
                            return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
                        end
                    end,
                    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

                    -- experimental features:
                    all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                    virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
                    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
                    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
                },
                dependencies = { "mfussenegger/nvim-dap" }
            },
        }
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { '<F5>', ft = "python" },
            { '<leader>br', ft = "python" },
            { '<leader>brc', ft = "python" },
            { '<leader>lgp', ft = "python" },
            { '<leader>dl', ft = "python" },
            { '<F10>', ft = "python" },
            { '<F11>', ft = "python" },
            { '<F12>', ft = "python" },
            { '<F6>', ft = "python" },
            { '<leader>db', ft = "python" },
        },
        config = function(_, _)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)

            -- This lets us debug library code
            -- Necessary as the vast majority of python libraries are heaps of garbage
            for _, pyconf in ipairs(require('dap').configurations.python) do
                pyconf.justMyCode = false
            end
        end,
    }
}
