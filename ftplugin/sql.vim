xmap <silent><buffer> <localleader>db <Plug>(DBManExecute)
nmap <silent><buffer> <localleader>db <Plug>(DBManExecute)
omap <silent><buffer> <localleader>db <Plug>(DBManExecute)
nmap <silent><buffer> <localleader>dl <Plug>(DBManExecuteLine)

nnoremap <silent><buffer> <localleader>de :call dbman#connection#edit()<CR>
nnoremap <silent><buffer> <localleader>ds :call dbman#connection#list()<CR>
nnoremap <silent><buffer> <localleader>du :call dbman#ui()<CR>
nnoremap <silent><buffer> <C-m> vipy:call dbman#query#execute_sql(@@)<CR>

if (exists('g:localleader_map'))
    let g:localleader_map.d = { 'name' : '+db' }
endif
