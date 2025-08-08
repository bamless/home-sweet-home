return {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    -- you can just use the latest version:
    -- branch = "latest",
    -- or the most up-to-date updates:
    -- branch = "nightly",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    config = function()
        local compile_mode = require "compile-mode"
        vim.g.compile_mode = {
            environment = {
                FORCE_COLOR = "1",
            },
            baleia_setup = true,
            default_command = "",
            input_word_completion = true,
            -- to make `:Compile` replace special characters (e.g. `%`) in
            -- the command (and behave more like `:!`), add:
            bang_expansion = true,
            -- Custom regexes
            error_regexp_table = {
                rust = {
                    regex = "^.*\\( -->\\|panicked at\\) \\(.*\\):\\([0-9]\\+\\):\\([0-9]\\+\\)",
                    filename = 2,
                    row = 3,
                    col = 4,
                },
                nodejs = {
                    regex = "^\\s\\+at .\\+ (\\(.\\+\\):\\([1-9][0-9]*\\):\\([1-9][0-9]*\\))$",
                    filename = 1,
                    row = 2,
                    col = 3,
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
                kotlin = {
                    regex = "^\\%(e\\|w\\): file://\\(.*\\):\\(\\d\\+\\):\\(\\d\\+\\) ",
                    filename = 1,
                    row = 2,
                    col = 3,
                },
            },
        }

        vim.keymap.set("n", "[e", function() vim.cmd [[NextError]] end)
        vim.keymap.set("n", "]e", function() vim.cmd [[PrevError]] end)
    end
}
