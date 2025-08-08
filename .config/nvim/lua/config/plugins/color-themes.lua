return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        name = 'tokyonight',
        opts = {
            style = "night",
        },
        config = function()
            require("tokyonight").setup({
                style = "night", -- or "storm" or "day"
                -- dim_inactive = true,
                on_highlights = function(hl, colors)
                    local sep_fg_color = "#262a3c"
                    local sep_bg_color = "#16161e"

                    hl.WinSeparator.fg = sep_fg_color
                    hl.WinSeparator.bg = sep_bg_color
                    hl.WinSeparator.bold = true

                    if hl.NvimTreeWinSeparator ~= nil then
                        hl.NvimTreeWinSeparator.fg = sep_fg_color
                        hl.NvimTreeWinSeparator.bold = true
                    end
                end,
            })
            vim.cmd.highlight('NvimTreeWinSeparator guifg=#fffff')
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavour = "mocha"
        }
    },
    { "EdenEast/nightfox.nvim" },
    { "rebelot/kanagawa.nvim" },
}
