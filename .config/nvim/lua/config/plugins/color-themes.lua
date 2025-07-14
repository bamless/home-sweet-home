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
                    hl.WinSeparator = {
                        fg = "#262a3c",
                    }
                end,
            })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            flavour = "mocha"
        }
    },
}
