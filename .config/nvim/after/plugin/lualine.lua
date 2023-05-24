require('lualine').setup {
    options = {
        icons_enabled = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            {
                'filename',
                path = 1,
            }
        }
    }
}
