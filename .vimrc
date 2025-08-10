set relativenumber
set colorcolumn=101
colorscheme habamax
autocmd BufRead,BufNewFile *.jsr set filetype=jstar
set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m
tnoremap <Esc> <C-\><C-n>  " enter normal mode on ESC in terminal

let &t_SI = "\e[6 q"  " Set cursor to thin vertical bar in insert mode
let &t_SR = "\e[4 q"  " Set cursor to underline in replace mode
let &t_EI = "\e[2 q"  " Set cursor to block in normal mode

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
