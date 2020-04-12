if exists('g:loaded_dbman_query_autoload')
    finish
endif
let g:loaded_dbman_query_autoload = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main Function
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dbman#query#execute_sql(...)
  if dbman#util#get_buffer_db() == {}
    echomsg 'Select a database first ...'
    return
  endif

  call dbman#util#set_current_db(dbman#util#get_buffer_db())

  if !a:0
    return
  endif

  let bindparams = dbman#util#get_buffer_bindparams()
  let sql = s:parse_query(a:1, bindparams)
  call dbman#util#set_buffer_bindparams(bindparams)
  call dbman#util#set_current_bindparams(bindparams)

  execute "DB " . sql

  if sql =~ "create\\|alter\\|drop\\|rename" || !empty(bindparams)
    call dbman#ui_render()
    exec "wincmd p"
  endif
endfunction

function! dbman#query#execute(...)
  if !a:0
    let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
    return 'g@'
  endif
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:1 == 'char'  " Invoked from Visual mode, use gv command.
    silent exe 'normal! gvy'
  elseif a:1 == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe 'normal! `[v`]y'
  endif

  let sql = @@
  call dbman#query#execute_sql(sql)

  let &selection = sel_save
  let @@ = reg_save
endfunction

function! s:parse_query(q, bindparams) abort
  let content = a:q
  let vars = []

  if match(content, ':\w\+') < 0
    return content
  endif

  call substitute(content, '\(:\w\+\)', '\=add(vars, submatch(0))', 'g')

  for var in vars
    if !has_key(a:bindparams, var)
      let value = input('Value for '.var.' (empty to skip substitution)> ', '')
      if value != ''
        let a:bindparams[var] = value
      endif
    endif
  endfor

  for [var, val] in items(a:bindparams)
    if trim(val) ==? ''
      continue
    endif

    if val !=? "^'.*'$" && (val =~? '^[0-9]*$' || val =~? '^\(true\|false\)$' || val =~? "''")
      let content = substitute(content, var, val, 'g')
    else
      let content = substitute(content, var, "'".val."'", 'g')
    endif
  endfor

  return content
endfunction
