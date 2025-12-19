let mapleader = " "
if !empty(glob('~/.vim/**/colors/kanagawa.vim'))
    colorscheme kanagawa
else
    colorscheme habamax
endif
set relativenumber
set colorcolumn=101
autocmd BufRead,BufNewFile *.jsr set filetype=jstar
set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m
tnoremap <Esc> <C-\><C-n>  " enter normal mode on ESC in terminal

let &t_SI = "\e[6 q"  " Set cursor to thin vertical bar in insert mode
let &t_SR = "\e[4 q"  " Set cursor to underline in replace mode
let &t_EI = "\e[2 q"  " Set cursor to block in normal mode

" respect prefix when using ctrl-p ctrl-n in command mode
cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"
cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set listchars=space:·,tab:>·,trail:█,extends:>,precedes:<,nbsp:␣
highlight ExtraWhitespace ctermfg=Red guifg=Red
match ExtraWhitespace /\s\+$/

nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-@> :Buffers<CR>
