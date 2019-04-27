scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! CSVQ#CSVQ()
    let target_file = getline(1)
    let query = join(getline(2, "$"), ' ')
    let query = query[0:match(query, ';')]
    let cmd = "nkf --oc=utf8 " . target_file . " | csvq \"" . query . "\""
    let result = split(system(cmd), '\n')
    execute("normal Go")
    call append('.', result)
    execute("normal gg")
    redraw!
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

