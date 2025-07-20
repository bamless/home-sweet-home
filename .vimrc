set relativenumber
set colorcolumn=101
colorscheme habamax
autocmd BufRead,BufNewFile *.jsr set filetype=jstar
set errorformat+=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m,%f:%l:%c:\ %m
