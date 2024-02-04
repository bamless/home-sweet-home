return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        { 'nvim-tree/nvim-web-devicons',   lazy = true },
        { 'linrongbin16/lsp-progress.nvim' }
    },
    config = function()
        vim.o.laststatus = 3

        local config = {
            options = {
                component_separators = '|',
                section_separators = { left = '', right = '' },
                icons_enabled = true,
            },
            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' }, right_padding = 2 },
                },
                lualine_b = {
                    {
                        'filename',
                        path = 1
                    },
                    'branch'
                },
                lualine_c = {
                    'fileformat',
                    {
                        function() return require("copilot_status").status_string() end,
                        cnd = function() return require("copilot_status").enabled() end,
                    }
                },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress', 'diagnostics' },
                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 },
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        }

        -- lsp_status configuration
        local colors = {
            yellow = '#ECBE7B',
            cyan = '#008080',
            darkblue = '#081633',
            green = '#98be65',
            orange = '#FF8800',
            violet = '#a9a1e1',
            magenta = '#c678dd',
            blue = '#51afef',
            red = '#ec5f67'
        }

        table.insert(config.sections.lualine_c, {
            require('lsp-progress').progress,
        })

        -- listen lsp-progress event and refresh lualine
        vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            group = "lualine_augroup",
            pattern = "LspProgressStatusUpdated",
            callback = require("lualine").refresh,
        })

        require('lualine').setup(config)
    end
}
