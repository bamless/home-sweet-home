require('tokyonight').setup {}
require('catppuccin').setup {}

function ColorTheme(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
end

ColorTheme()
