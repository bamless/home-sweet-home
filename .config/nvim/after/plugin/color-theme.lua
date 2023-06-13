require('tokyonight').setup { style = "moon" }
require('catppuccin').setup {}

function ColorTheme(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
end

ColorTheme()
