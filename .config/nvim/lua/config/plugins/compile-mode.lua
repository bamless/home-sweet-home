return {
    "ej-shafran/compile-mode.nvim",
    branch = "latest",
    -- you can just use the latest version:
    -- branch = "latest",
    -- or the most up-to-date updates:
    -- branch = "nightly",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    cmd = { 'Compile', 'Recompile' },
    keys = {
        { '<C-x>', ':bot Recompile<CR>', mode = 'n', desc = 'Recompile' },
    },
    config = function()
        local compile_mode = require "compile-mode"
        vim.g.compile_mode = {
            environment = {
                FORCE_COLOR = "1",
            },
            baleia_setup = true,
            recompile_no_fail = true,
            -- input_word_completion = true,
            -- to make `:Compile` replace special characters (e.g. `%`) in
            -- the command (and behave more like `:!`), add:
            bang_expansion = true,
            default_command = {
                rust = "cargo",
                jstar = "jstar",
                ["*"] = "make -k",
            },
            -- Custom regexes
            error_regexp_table = {
                rustc = {
                    regex = [[^.*\%( -->\|panicked at\) \([^:]\+\.rs\):\([0-9]\+\):\([0-9]\+\)]],
                    filename = 1,
                    row = 2,
                    col = 3,
                    priority = 2,
                },
                rust_backtrace = {
                    regex = [[\s* at \([^:]\+\.rs\):\([1-9][0-9]*\):\([1-9][0-9]*\)]],
                    filename = 1,
                    row = 2,
                    priority = 2,
                },
                nodejs = {
                    regex = [[^\s\+at .\+ (\(/[^:]\+\.\%(js\|mjs\|cjs\|jsx\)\):\([1-9][0-9]*\):\([1-9][0-9]*\))$]],
                    filename = 1,
                    row = 2,
                    col = 3,
                    priority = 2,
                },
                jstar = {
                    regex = "^    \\(.*\\):\\([1-9][0-9]*\\): error in .*()$",
                    filename = 1,
                    row = 2,
                    col = 4,
                    priority = 2,
                },
                typescript = {
                    regex = "^\\(.\\+\\)(\\([1-9][0-9]*\\),\\([1-9][0-9]*\\)): error TS[1-9][0-9]*:",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                typescript_new = {
                    regex = "^\\(.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\) - error TS[1-9][0-9]*:",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                pyright = {
                    regex = "^\\s*\\(.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\) - \\(error\\|warning\\|information\\):",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                gradlew = {
                    regex = "^e:\\s\\+file://\\(.\\+\\):\\(\\d\\+\\):\\(\\d\\+\\) ",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
                ls_lint = {
                    regex = "\\v^\\d{4}/\\d{2}/\\d{2} \\d{2}:\\d{2}:\\d{2} (.+) failed for rules: .+$",
                    filename = 1,
                },
                sass = {
                    regex = "\\s\\+\\(.\\+\\) \\(\\d\\+\\):\\(\\d\\+\\)  .*$",
                    filename = 1,
                    row = 2,
                    col = 3,
                    type = compile_mode.level.WARNING,
                },
            },
        }

        vim.keymap.set("n", "[e", function() vim.cmd [[NextError]] end)
        vim.keymap.set("n", "]e", function() vim.cmd [[PrevError]] end)
        vim.keymap.set('n', '<C-x>', [[:bot Recompile<CR>]], {})
    end
}
