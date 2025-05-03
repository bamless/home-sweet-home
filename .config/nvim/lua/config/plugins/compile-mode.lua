return {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    -- you can just use the latest version:
    -- branch = "latest",
    -- or the most up-to-date updates:
    -- branch = "nightly",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    config = function()
        vim.g.compile_mode = {
            baleia_setup = true,

            -- to make `:Compile` replace special characters (e.g. `%`) in
            -- the command (and behave more like `:!`), add:
            -- bang_expansion = true,
        }
    end
}
