return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true
                    }
                }
            }
            require('telescope').load_extension('fzf')
            local builtin = require('telescope.builtin')

            -- Find files: first try only git files, then all files if git_files fails
            vim.keymap.set('n', '<C-p>', function()
                if not pcall(builtin.git_files) then
                    builtin.find_files()
                end
            end)

            -- Open buffers
            vim.keymap.set('n', '<C-space>', function()
                builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
            end)

            -- Project wide grep
            vim.keymap.set('n', '<leader>ps', function()
                vim.cmd('vimgrep /\\v\\c' .. vim.fn.input("Grep > ") .. '/gj **/*')
                vim.cmd('copen')
            end)
            vim.keymap.set('n', '<leader>pg', builtin.live_grep)

            -- Git branches
            vim.keymap.set('n', '<C-g>', builtin.git_branches, {})
            -- Find files in project
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            -- View help tags
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
            -- List all marks
            vim.keymap.set('n', '<leader>m', builtin.marks, {})
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },

}
