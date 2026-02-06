let g:qcompile_last_cmd = ''

function! QCompileInputComplete(ArgLead, CmdLine, CursorPos)
    let HasNoSpaces = a:CmdLine =~ '^\S\+$'
    let Results = getcompletion('!' . a:CmdLine, 'cmdline')
    let TransformedResults = map(Results, 'HasNoSpaces ? v:val : a:CmdLine[:strridx(a:CmdLine, " ") - 1] . " " . v:val')
    return TransformedResults
endfunction

function! QCompile(...) abort
    let l:default = empty(g:qcompile_last_cmd) ? 'make -k' : g:qcompile_last_cmd

    if a:0 > 0
        let l:cmd = join(a:000, ' ')
    else
        let l:cmd = input('Compile: ', l:default, 'customlist,QCompileInputComplete')
    endif


    if empty(l:cmd)
        return
    endif

    let g:qcompile_last_cmd = l:cmd

    let &l:makeprg = l:cmd
    execute 'make! | bot copen 25'
endfunction

function! QRecompile() abort
    if empty(g:qcompile_last_cmd)
        echoerr "Cannot recompile: no previous command"
        return
    endif
    let &l:makeprg = g:qcompile_last_cmd
    execute 'make! | bot copen 25'
endfunction

command! -nargs=* -complete=file QCompile call QCompile(<f-args>)
command! QRecompile call QRecompile()
