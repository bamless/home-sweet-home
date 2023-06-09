local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"]=function() vim.cmd("NvimTreeToggle"); dapui.open() end

require("nvim-dap-virtual-text").setup()

vim.fn.sign_define('DapBreakpoint',{ text ='🔴', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})

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
vim.keymap.set('n', '<leader>brc', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>]], {})
-- Logpoint
vim.keymap.set('n', '<leader>lgp', [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log Point Msg: '))<CR>]], {})
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
vim.keymap.set('n', '<C-x>', [[:NvimTreeToggle<CR> :lua require'dapui'.toggle()<CR>]], {})

