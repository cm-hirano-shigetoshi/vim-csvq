scriptencoding utf-8
if exists('g:load_CSVQ')
    finish
endif
let g:load_CSVQ = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent> <Plug>(CSVQ) :<C-u>call CSVQ#CSVQ()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

