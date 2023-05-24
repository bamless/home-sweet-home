require('lualine').setup {
    options = {
        icons_enabled = true,
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        }
    }
}
