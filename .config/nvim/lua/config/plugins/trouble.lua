return {
    "folke/trouble.nvim",
    opts = {
        modes = {
            diagnostics = {         -- Configure symbols mode
                win = {
                    type = "split", -- split window
                    relative = "win", -- relative to current window
                    position = "right", -- right side
                    size = 0.2,
                },
            },
        },
    },
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
