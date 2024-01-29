return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        icons = false
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
    },
    config = function(_, opts)
        require("trouble").setup(opts)

        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            { silent = true, noremap = true }
        )

        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle<cr>",
            { silent = true, noremap = true }
        )
    end
}
