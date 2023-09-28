require('tokyonight').setup {
    style = "night",
    on_colors = function(colors)
        -- colors.terminal_black = "#717ba8"
        -- dim color is too dim, lighten it up
        colors.terminal_black = colors.dark5
        colors.dark3 = colors.dark5
        colors.terminal_black = colors.bg_dark
    end
}
require('catppuccin').setup {}

function ColorTheme(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
end

ColorTheme()
