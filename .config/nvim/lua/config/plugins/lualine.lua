return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
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
            'lsp_progress',
            colors = {
                percentage      = colors.cyan,
                title           = colors.cyan,
                message         = colors.cyan,
                spinner         = colors.cyan,
                lsp_client_name = colors.blue,
                use             = true,
            },
            separators = {
                component = ' ',
                progress = ' | ',
                message = { pre = '(', post = ')', commenced = 'In Progress', completed = 'Completed' },
                percentage = { pre = '', post = '%% ' },
                title = { pre = '', post = ': ' },
                lsp_client_name = { pre = '[', post = ']' },
                spinner = { pre = '', post = '' },
            },
            display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
            timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            spinner_symbols = { '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘' },
        })

        require('lualine').setup(config)
    end
}
