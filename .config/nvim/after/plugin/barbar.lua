vim.g.barbar_auto_setup = false

require("barbar").setup {
    sidebar_filetypes = {
        NvimTree = true,
    },
    icons = {
        -- Configure the base icons on the bufferline.
        -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
        buffer_index = true,
        button = '',
        -- Enables / disables diagnostic symbols
        diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true },
            [vim.diagnostic.severity.WARN] = { enabled = true },
        },
        filetype = {
            -- Sets the icon's highlight group.
            -- If false, will use nvim-web-devicons colors
            custom_colors = false,

            -- Requires `nvim-web-devicons` if `true`
            enabled = true,
        },
        separator = { left = '▎', right = '' },

        -- If true, add an additional separator at the end of the buffer list
        separator_at_end = false,

        -- Configure the icons on the bufferline when modified or pinned.
        -- Supports all the base icon options.
        modified = { button = '●' },
        pinned = { button = '', filename = true },
    },
}
