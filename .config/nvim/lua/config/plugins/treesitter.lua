return {
    'nvim-treesitter/nvim-treesitter',
    branch = "main",
    config = function()
        require("nvim-treesitter").setup {
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site',
        }
    end,
    init = function()
        -- A list of parser names, or "all"
        local ensure_installed = {
            "bash",
            "cpp",
            "c",
            "css",
            "diff",
            "go",
            "html",
            "java",
            "javascript",
            "jsdoc",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "printf",
            "python",
            "query",
            "regex",
            "rust",
            "scss",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        }

        local already_installed = require('nvim-treesitter.config').get_installed()
        local parsersToInstall = vim.iter(ensure_installed)
            :filter(function(parser)
                return not vim.tbl_contains(already_installed, parser)
            end)
            :totable()
        require('nvim-treesitter').install(parsersToInstall)

        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                pcall(vim.treesitter.start)                                       -- Enable treesitter highlighting and disable regex syntax
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Enable treesitter-based indentation
            end,
        })
    end,
    build = ':TSUpdate',
    dependencies = {
        -- 'nvim-treesitter/nvim-treesitter-context',
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            config = function()
                require("nvim-treesitter-textobjects").setup {
                    select = {
                        lookahead = true,
                        selection_modes = {
                            ['@parameter.outer'] = 'v',     -- charwise
                            ['@function.outer']  = 'V',     -- linewise
                            ['@class.outer']     = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = false,
                    },
                    move = {
                        set_jumps = true,
                    },
                }

                -- Select keymaps
                local select = require("nvim-treesitter-textobjects.select")

                vim.keymap.set({ "x", "o" }, "af", function()
                    select.select_textobject("@function.outer", "textobjects")
                end)
                vim.keymap.set({ "x", "o" }, "if", function()
                    select.select_textobject("@function.inner", "textobjects")
                end)
                vim.keymap.set({ "x", "o" }, "ac", function()
                    select.select_textobject("@class.outer", "textobjects")
                end)
                vim.keymap.set({ "x", "o" }, "ic", function()
                    select.select_textobject("@class.inner", "textobjects")
                end, { desc = "Select inner part of a class region" })
                vim.keymap.set({ "x", "o" }, "as", function()
                    select.select_textobject("@local.scope", "locals")
                end, { desc = "Select language scope" })

                -- Move keymaps
                local move = require("nvim-treesitter-textobjects.move")

                -- goto_next_start  (your original used "[" prefix for next, "]" for prev â€” preserved as-is)
                vim.keymap.set({ "n", "x", "o" }, "[f",
                    function() move.goto_next_start("@function.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "[c",
                    function() move.goto_next_start("@class.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "[a",
                    function() move.goto_next_start("@parameter.inner", "textobjects") end)

                -- goto_next_end
                vim.keymap.set({ "n", "x", "o" }, "[F",
                    function() move.goto_next_end("@function.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "[C",
                    function() move.goto_next_end("@class.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "[A",
                    function() move.goto_next_end("@parameter.inner", "textobjects") end)

                -- goto_previous_start
                vim.keymap.set({ "n", "x", "o" }, "]f",
                    function() move.goto_previous_start("@function.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "]c",
                    function() move.goto_previous_start("@class.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "]a",
                    function() move.goto_previous_start("@parameter.inner", "textobjects") end)

                -- goto_previous_end
                vim.keymap.set({ "n", "x", "o" }, "]F",
                    function() move.goto_previous_end("@function.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "]C",
                    function() move.goto_previous_end("@class.outer", "textobjects") end)
                vim.keymap.set({ "n", "x", "o" }, "]A",
                    function() move.goto_previous_end("@parameter.inner", "textobjects") end)
            end,
            init = function()
                vim.g.no_plugin_maps = true
            end,
            branch = "main"
        },
    }
}
