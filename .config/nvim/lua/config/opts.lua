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
vim.opt.makeprg = ""
vim.api.nvim_command [[:set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m]]

vim.cmd [[:set wildoptions-=pum]]      -- inline command completion
vim.cmd [[:tnoremap <Esc> <C-\><C-n>]] -- enter normal mode on ESC in terminal

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
                ---@diagnostic disable-next-line: assign-type-mismatch
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
end, {
    range = false,
    nargs = '?',
    complete = function(_, cmdline)
        local cmd = cmdline:gsub("Compile%s+", "")
        local results = vim.fn.getcompletion(("!%s"):format(cmd), "cmdline")
        return results
    end,
})

vim.cmd [[
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute ':confirm :bdelete '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
nnoremap <silent> <Leader>bd :Bclose<CR>
]]
