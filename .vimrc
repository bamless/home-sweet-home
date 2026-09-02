if !empty(glob('~/.vim/**/colors/kanagawa.vim'))
    colorscheme kanagawa
else
    colorscheme habamax
endif

let mapleader = " "

set number
set relativenumber
set colorcolumn=101

let &t_SI = "\e[6 q"  " Set cursor to thin vertical bar in insert mode
let &t_SR = "\e[4 q"  " Set cursor to underline in replace mode
let &t_EI = "\e[2 q"  " Set cursor to block in normal mode

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set listchars=space:·,tab:>·,trail:█,extends:>,precedes:<,nbsp:␣

highlight ExtraWhitespace ctermfg=Red guifg=Red
match ExtraWhitespace /\s\+$/

nnoremap <silent> <C-p>       :Files<CR>
nnoremap <silent> <C-@>       :Buffers<CR>
nnoremap <silent> <C-b>       :Explore<CR>
nnoremap <silent> <leader>pg  :RG<CR>
inoremap <C-c>                <Esc>

" respect prefix when using ctrl-p ctrl-n in command mode
cnoremap <expr> <C-P> wildmenumode() ? "\<C-P>" : "\<Up>"
cnoremap <expr> <C-N> wildmenumode() ? "\<C-N>" : "\<Down>"

autocmd BufRead,BufNewFile *.jsr set filetype=jstar
set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m
tnoremap <Esc><Esc> <C-\><C-n>  " enter normal mode on double ESC in terminal

"Plugins
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()
