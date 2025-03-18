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
        if getline(1)[0:2] == "-- "
            let opts = getline(1)[3:]
            let query = join(getline(2, semi_colons[-1]), ' ')
        else
            let opts = ""
            let query = join(getline(1, semi_colons[-1]), ' ')
        endif
        let data = getline(semi_colons[0]+1, '$')
    elseif len(semi_colons) > 1
        if getline(1)[0:2] == "-- "
            let opts = getline(1)[3:]
            let start = 2
        else
            let opts = ""
            let start = 1
        endif
        let end = 0
        for i in semi_colons
            if i < line('.')
                let start = i + 1
            else
                let end = i
            endif
        endfor
        let query = join(getline(start, end), ' ')
        let query = query[0:match(query, ';')]
        let data = getline(semi_colons[-1]+1, '$')
    endif

    let tmpfile = tempname()
    call writefile(data, tmpfile)
    let cmd = "nkf --oc=utf8 " . tmpfile . " | duckfilter " . opts . " \"" . query . "\""
    let result = split(system(cmd), '\n')
    execute("normal " . semi_colons[-1] . "ggjVG\"_d")
    call append('.', result)
    execute("normal gg")
    call setpos('.', pos)
    redraw!
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

