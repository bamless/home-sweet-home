if vim.g.neovide then
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.10
end

vim.opt.mouse = 'a'

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true -- case-insensitive search/replace
vim.opt.smartcase = true  -- unless uppercase in search term

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "101"

-- :make
vim.api.nvim_command [[:set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m]]

-- inline command completion
vim.cmd [[:set wildoptions-=pum]]
-- enter normal mode on ESC in terminal
vim.cmd [[:tnoremap <Esc> <C-\><C-n>]]

-- respect prefix when using ctrl-p ctrl-n in command mode
vim.cmd [[:cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"]]
vim.cmd [[:cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"]]

-- Whitespace
-- vim.opt.list = true
vim.opt.listchars = {
    tab = "> ",
    space = "·",
    trail = "█",
    extends = ">",
    precedes = "<",
    nbsp = "␣"
}
vim.cmd [[
    highlight ExtraWhitespace ctermfg=Red guifg=Red
    match ExtraWhitespace /\s\+$/
]]
vim.cmd [[ autocmd FileType neo-tree setlocal nolist ]]

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {
            higroup = (vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'),
            timeout = 500
        }
    end
})

-- Get that italic outta here
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            if hl.italic then
                ---@diagnostic disable-next-line: assign-type-mismatch
                hl.italic = false
                vim.api.nvim_set_hl(0, group, hl)
            end
        end
    end,
})

-- Custom commands -------------

-- Align text on string
vim.api.nvim_create_user_command("Align", function()
    local sep = vim.fn.input("Enter align string: ")
    if sep == "" then return end

    local start_line = vim.fn.line("'<") - 1
    local end_line = vim.fn.line("'>")

    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
    local input = table.concat(lines, "\n")

    local unique_sep = "\x1f"
    input = input:gsub(sep, unique_sep)

    local cmd = string.format("column -t -s'%s' -o'%s'", unique_sep, unique_sep)
    local output = vim.fn.systemlist(cmd, input)

    for i, line in ipairs(output) do
        output[i] = line:gsub(unique_sep, sep)
    end

    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, output)
end, { range = true, nargs = 0 })

-- Custom :Term command that opens neovim terminal in a split
vim.api.nvim_create_user_command("Term", function(opts)
    local input
    if opts.args and opts.args ~= "" then
        input = opts.args
    else
        vim.ui.input({
            prompt = "Term > ",
            -- Hijack `qcompile` input completion :D
            completion = "customlist,QCompileInputComplete"
        }, function(str) input = str end)
    end
    if input then
        vim.cmd("sp|term " .. input)
    end
end, {
    range = false,
    nargs = '?',
    complete = function(_, cmdline)
        local cmd = cmdline:gsub("Compile%s+", "")
        local results = vim.fn.getcompletion(("!%s"):format(cmd), "cmdline")
        return results
    end,
})
