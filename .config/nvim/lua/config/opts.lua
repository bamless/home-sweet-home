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
            -- Hijack `compile-mode` plugin completion :D
            completion = "customlist,CompileInputComplete"
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

-- Bbye allows you to do delete buffers (close files) without closing your windows or messing up
-- your layout.
-- Use :Bdelete to delete a buffer, or :Bwipeout to delete them all.
vim.cmd [[
if exists("g:loaded_bbye") || &cp | finish | endif
let g:loaded_bbye = 1

function! s:bdelete(action, bang, buffer_name)
	let buffer = s:str2bufnr(a:buffer_name)
	let w:bbye_back = 1

	if buffer < 0
		return s:error("E516: No buffers were deleted. No match for ".a:buffer_name)
	endif

	if getbufvar(buffer, "&modified") && empty(a:bang)
		let error = "E89: No write since last change for buffer "
		return s:error(error . buffer . " (add ! to override)")
	endif

	" If the buffer is set to delete and it contains changes, we can't switch
	" away from it. Hide it before eventual deleting:
	if getbufvar(buffer, "&modified") && !empty(a:bang)
		call setbufvar(buffer, "&bufhidden", "hide")
	endif

	" For cases where adding buffers causes new windows to appear or hiding some
	" causes windows to disappear and thereby decrement, loop backwards.
	for window in reverse(range(1, winnr("$")))
		" For invalid window numbers, winbufnr returns -1.
		if winbufnr(window) != buffer | continue | endif
		execute window . "wincmd w"

		" Bprevious also wraps around the buffer list, if necessary:
		try | exe bufnr("#") > 0 && buflisted(bufnr("#")) ? "buffer #" : "bprevious"
		catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
		endtry

		" If found a new buffer for this window, mission accomplished:
		if bufnr("%") != buffer | continue | endif

		call s:new(a:bang)
	endfor

	" Because tabbars and other appearing/disappearing windows change
	" the window numbers, find where we were manually:
	let back = filter(range(1, winnr("$")), "getwinvar(v:val, 'bbye_back')")[0]
	if back | exe back . "wincmd w" | unlet w:bbye_back | endif

	" If it hasn't been already deleted by &bufhidden, end its pains now.
	" Unless it previously was an unnamed buffer and :enew returned it again.
	"
	" Using buflisted() over bufexists() because bufhidden=delete causes the
	" buffer to still _exist_ even though it won't be :bdelete-able.
	if buflisted(buffer) && buffer != bufnr("%")
		exe a:action . a:bang . " " . buffer
	endif
endfunction

function! s:str2bufnr(buffer)
	if empty(a:buffer)
		return bufnr("%")
	elseif a:buffer =~# '^\d\+$'
		return bufnr(str2nr(a:buffer))
	else
		return bufnr(a:buffer)
	endif
endfunction

function! s:new(bang)
	exe "enew" . a:bang

	setl noswapfile
	" If empty and out of sight, delete it right away:
	setl bufhidden=wipe
	" Regular buftype warns people if they have unsaved text there.  Wouldn't
	" want to lose someone's data:
	setl buftype=
	" Hide the buffer from buffer explorers and tabbars:
	setl nobuflisted
endfunction

" Using the built-in :echoerr prints a stacktrace, which isn't that nice.
function! s:error(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
	let v:errmsg = a:msg
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:bdelete("bdelete", <q-bang>, <q-args>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:bdelete("bwipeout", <q-bang>, <q-args>)

nnoremap <silent> <Leader>bd :Bdelete<CR>
]]
