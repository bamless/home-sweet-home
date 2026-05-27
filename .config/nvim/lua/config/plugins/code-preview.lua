return {
    "Cannon07/code-preview.nvim",
    config = function()
        require("code-preview").setup({
            keys = {
                next_change = "[x",         -- inline diff: next change
                prev_change = "]x",         -- inline diff: previous change
                close_all   = "<leader>dq", -- close diff and clear indicators
            },
        })
    end,
}
