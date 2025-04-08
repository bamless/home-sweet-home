-- Prompts for chat
local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
}

-- chat keybinds
local chat_keys = {
    { "<leader>cce", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
    { "<leader>ccf", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix diagnostics" },
    { "<leader>cct", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
    { "<leader>ccr", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
    { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
    { "<leader>ccs", "<cmd>CopilotChatSummarize<cr>",     desc = "CopilotChat - Summarize text" },
    { "<leader>ccS", "<cmd>CopilotChatSpelling<cr>",      desc = "CopilotChat - Correct spelling" },
    { "<leader>ccw", "<cmd>CopilotChatWording<cr>",       desc = "CopilotChat - Improve wording" },
    { "<leader>ccc", "<cmd>CopilotChatConcise<cr>",       desc = "CopilotChat - Make text concise" },
}

vim.api.nvim_command('vnoremap <leader>cci :<C-u>\'<,\'>CopilotChatInPlace<CR>')

vim.keymap.set("n", "<leader>cc", function()
    local query = vim.fn.input("Ask copilot: ")
    vim.cmd("CopilotChat " .. query)
end)

vim.keymap.set("n", "<leader>ccb", function()
    local prompt = vim.fn.input("Prompt: ")
    vim.cmd("CopilotChatBuffer " .. prompt)
end)

-- Copilot options
local config = {
    suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
            accept = "<C-k>",
        },
    },
    filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
    },
}

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = config
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        opts = {
            show_help = "yes",         -- Show help text for CopilotChatInPlace, default: yes
            debug = false,             -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
            language = "English"                  -- Copilot answer language settings when using default prompts. Default language is English.
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
            -- temperature = 0.1,
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
        keys = chat_keys,
    },
}
