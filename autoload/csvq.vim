scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! CSVQ#CSVQ()
    let pos = getpos('.')
    let semi_colons = []
    let i = 1
    while i <= line('$')
        if match(getline(i), ';') >= 0
            call add(semi_colons, i)
        endif
        let i += 1
    endwhile

    if len(semi_colons) < 1
        return
    elseif len(semi_colons) == 1
        let i = 1
        let query = ""
        while i <= semi_colons[0]
            let query .= getline(i) . " "
            let i += 1
        endwhile
        let query = query[0:match(query, ';')]

        let data = getline(semi_colons[0]+1, '$')
    endif

    let tmpfile = tempname()
    call writefile(data, tmpfile)
    let cmd = "nkf --oc=utf8 " . tmpfile . " | csvq -f csv \"" . query . "\""
    let result = split(system(cmd), '\n')
    execute("normal " . semi_colons[-1] . "ggjVG\"_d")
    call append('.', result)
    execute("normal gg")
    call setpos('.', pos)
    redraw!
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

