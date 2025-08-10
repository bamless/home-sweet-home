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
vim.opt.conceallevel = 1

-- :make
vim.opt.makeprg = ""
vim.api.nvim_command [[:set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m]]

vim.cmd [[:set wildoptions-=pum]]      -- inline command completion
vim.cmd [[:tnoremap <Esc> <C-\><C-n>]] -- enter normal mode on ESC in terminal

-- respect prefix when using ctrl-p ctrl-n in command mode
vim.cmd [[:cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"]]
vim.cmd [[:cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"]]

-- Autocmds --------------------

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
                hl.italic = false
                vim.api.nvim_set_hl(0, group, hl)
            end
        end
    end,
})

-- Custom commands -------------

-- Align on string
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

-- Custom term command; accepts input and opens split
vim.api.nvim_create_user_command("Term", function(opts)
    local input
    if opts.args and opts.args ~= "" then
        input = opts.args
    else
        vim.ui.input({
            prompt = "Term > ",
            -- Hijack `compile-mode` plugin completion :D
            completion = "customlist,CompileInputComplete"
        }, function(str) input = str end)
    end
    if input then
        vim.cmd("sp|term " .. input)
    end
end, { range = false, nargs = '?' })
