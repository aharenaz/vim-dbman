setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nomodifiable winfixwidth signcolumn=no  foldmethod=expr foldexpr=DBManFoldMethod(v:lnum) foldtext=DBManFoldText() foldlevel=2 nonumber
execute "setlocal sw=" . g:dbman_shiftwidth

nnoremap <buffer> o :call dbman#uiaction#open()<CR>
nnoremap <buffer> <CR> :call dbman#uiaction#open()<CR>
nnoremap <buffer> <C-v> :call dbman#uiaction#open('v')<CR>
nnoremap <buffer> <C-x> :call dbman#uiaction#open('x')<CR>
nnoremap <buffer> dd  :call dbman#uiaction#delete()<CR>
nnoremap <buffer> f :call dbman#uiaction#fields()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DBManFoldText() abort
  let index = dbman#util#item_index(v:foldstart)
  let item = g:dbman_ui_items[index]

  return repeat(' ', g:dbman_shiftwidth * item.indent - g:dbman_start_column) . item.text
endfunction

function! DBManFoldMethod(lnum) abort
  let current_index = a:lnum - 1
  let next_index = a:lnum

  let item = g:dbman_ui_items[current_index]
  if next_index < len(g:dbman_ui_items)
    let next_item = g:dbman_ui_items[next_index]
  else
    let next_item = { 'indent' : item.indent }
  endif 

  if item.indent == next_item.indent
    return item.indent
  elseif item.indent > next_item.indent
    return item.indent
  else
    return '>' . next_item.indent
  endif
endfunction
