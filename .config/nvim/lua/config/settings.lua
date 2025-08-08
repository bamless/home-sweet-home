vim.opt.mouse = 'a'

-- :make
vim.opt.makeprg = ""
vim.api.nvim_command[[:set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m]]

-- terminal
vim.cmd[[:tnoremap <Esc> <C-\><C-n>]]

-- inline command completion
vim.cmd[[:set wildoptions-=pum]]

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

-- case-insensitive search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true

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
