return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    layout_strategy = "flex",
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                    },
                    file_ignore_patterns = {
                        '^node_modules',
                        '^.git',
                        '^.venv',
                        '^dist',
                        '%.lock$',
                        '.cache',
                        '.git',
                        '.github',
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

            vim.keymap.set('n', '<C-space>', function()
                builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
            end)
            vim.keymap.set('n', '<C-p>', builtin.find_files)
            vim.keymap.set('n', '<leader>pg', builtin.live_grep)
            vim.keymap.set('n', '<C-g>', builtin.git_branches, {})
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
            vim.keymap.set('n', '<leader>m', builtin.marks, {})
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },
}
