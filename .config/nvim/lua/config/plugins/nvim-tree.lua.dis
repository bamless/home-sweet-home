return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true

        require("nvim-tree").setup {
            sort_by = "case_sensitive",
            auto_reload_on_write = true,
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
            },
            update_focused_file = {
                enable = true,
                update_root = true,
                ignore_list = { "help" },
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
        }

        vim.keymap.set('n', '<C-b>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })
    end
}
