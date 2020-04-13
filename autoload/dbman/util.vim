if exists('g:loaded_dbman_util_autoload')
    finish
endif
let g:loaded_dbman_util_autoload = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dbman#util#get_buffer_db(...)
  if a:0
    return get(g:dbman_buffer_db, a:1, {})
  else
    return get(g:dbman_buffer_db, bufnr(), {})
  endif
endfunction

function! dbman#util#set_buffer_db(value,...)
  if a:0
    let g:dbman_buffer_db[a:1] = a:value
  else
    let g:dbman_buffer_db[bufnr()] = a:value
  endif
endfunction

function! dbman#util#get_current_db()
  return g:dbman_current_db
endfunction

function! dbman#util#set_current_db(db)
  let g:dbman_current_db = a:db
  let b:db = a:db.url
endfunction

function! dbman#util#get_buffer_bindparams(...)
  if a:0
    return get(g:dbman_buffer_bindparams, a:1, {})
  else
    return get(g:dbman_buffer_bindparams, bufnr(), {})
  endif
endfunction

function! dbman#util#set_buffer_bindparams(params, ...)
  if a:0
    let g:dbman_buffer_bindparams[a:1] = a:params
  else
    let g:dbman_buffer_bindparams[bufnr()] = a:params
  endif
endfunction

function! dbman#util#set_current_bindparams(params)
  let g:dbman_current_bindparams = a:params
endfunction

function! dbman#util#get_current_bindparams()
  return g:dbman_current_bindparams
endfunction

function! dbman#util#goto_window(bufname) abort
  for winnr in range(1, winnr('$'))
    if bufname(winbufnr(winnr)) == a:bufname
      exe winnr.'wincmd w'
      return 1
    endif
  endfor
  return 0
endfunction

function! dbman#util#get_db_query_filename_template(db) abort
  return substitute(a:db.name, "\\s*\\|\\$*\\|:\\|_\\|\\*", "", "g") . "_"
endfunction

function! dbman#util#saved_query_name_from_path(db, path)
  let saved_files_pattern = expand(g:dbman_query_save_path) . '/' . s:get_db_query_filename_template(a:db)
  return substitute(a:path, saved_files_pattern, "", "g")
endfunction

function! dbman#util#item_index(linenr)
  return a:linenr - 1
endfunction
