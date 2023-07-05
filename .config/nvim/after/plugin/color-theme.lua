require('tokyonight').setup {
    style = "moon",
    on_colors = function(colors)
       -- colors.terminal_black = "#717ba8"
       -- dim color is too dim, lighten it up
       colors.terminal_black = colors.dark5
       colors.dark3 = colors.dark5
    end
}
require('catppuccin').setup {}

function ColorTheme(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
end

ColorTheme()
