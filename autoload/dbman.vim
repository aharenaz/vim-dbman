if exists('g:loaded_dbman_autoload')
    finish
endif
let g:loaded_dbman_autoload = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dbman#ui()
  if dbman#util#get_current_db() == {}
    echomsg 'Select a database first ...'
    return
  endif

  if !dbman#util#goto_window(g:dbman_bufname)
    silent! exe 'vertical topleft new ' . g:dbman_bufname
    setlocal filetype=dbman
  endif

  call dbman#ui_render()
  exec "wincmd p"
endfunction

function! dbman#ui_render()
  if !dbman#util#goto_window(g:dbman_bufname)
    return
  endif
  
  silent! exe 'vertical topleft resize '.g:dbman_winwidth

  let first_render = (line('$') == 1)

  let db = dbman#util#get_current_db()
  let params = dbman#util#get_current_bindparams()

  let view = winsaveview()

  let text = []
  let g:dbman_ui_items = dbman#uiutil#load_ui_items(db, params)

  for item in g:dbman_ui_items
    call add(text, repeat(' ', g:dbman_start_column + (g:dbman_shiftwidth * item.indent)) . item.text)
  endfor

  setlocal modifiable
  silent 1,$delete _

  call append(0, text)

  setlocal nomodifiable nomodified
  call winrestview(view)
endfunction
