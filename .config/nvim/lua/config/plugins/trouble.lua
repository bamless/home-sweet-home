return {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
        {
            "<leader>xd",
            "<cmd>Trouble diagnostics toggle win.position=right<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xq",
            "<cmd>Trouble qflist toggle win.position=right<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
