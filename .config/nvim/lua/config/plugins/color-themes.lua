return {
    {
        'folke/tokyonight.nvim',
        name = 'tokyonight',
        config = function()
            require('tokyonight').setup {
                style = "night",
                on_colors = function(colors)
                    -- colors.terminal_black = "#717ba8"
                    -- dim color is too dim, lighten it up
                    colors.terminal_black = colors.dark5
                    colors.dark3 = colors.dark5
                end
            }
        end
    },
    { "catppuccin/nvim", name = "catppuccin" },
}
