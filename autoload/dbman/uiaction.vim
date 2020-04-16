if exists('g:loaded_dbman_uiaction_autoload')
  finish
endif
let g:loaded_dbman_uiaction_autoload = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DBMan menu actions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dbman#uiaction#open( ... ) abort
  let item_index = dbman#util#item_index(line('.'))
  let item = g:dbman_ui_items[item_index]

  if item.type == 'db' || item.type == 'saved_group' || item.type == 'tables'
    silent! normal! za
  elseif item.type == 'saved_query'
    if !dbman#util#goto_window(item.filename)
      let db = item.target
      let direction = (a:0 ? a:1 : 'v')

      call s:create_new_window(direction, item.filename)

      call dbman#util#set_buffer_db(db, bufnr())
      call dbman#util#set_current_db(db)

      call dbman#ui_render()
      exec "wincmd p"
    endif
  elseif item.type == 'new'
    let db = item.target
    let direction = (a:0 ? a:1 : 'v')
    let new_query_name = dbman#uiutil#new_saved_query_name(db)

    call s:create_new_window(direction, new_query_name)
    silent! exe ":w"

    call dbman#util#set_buffer_db(db, bufnr())
    call dbman#util#set_current_db(db)

    call dbman#ui_render()
    exec "wincmd p"
  elseif item.type == 'param'
    let bindparams = dbman#util#get_current_bindparams()
    let var = input('Value for '.item.var.' (empty to skip substitution)> ', '')
    if var != ''
      let bindparams[item.var] = var
      call dbman#util#set_current_bindparams(bindparams)
      call dbman#ui_render()
    endif
  elseif item.type == 'table'
    call dbman#uiaction#fields()
  endif
endfunction

function! dbman#uiaction#delete() abort
  let item_index = dbman#util#item_index(line('.'))
  let item = g:dbman_ui_items[item_index]

  if item.type == 'saved_query'
    let continue = input('Delete '.item.filename.'? [y|n]> ', '')
    if continue == 'y'
      if delete(item.filename) == 0
        call dbman#ui_render()
      endif
    endif
  endif
endfunction

function! dbman#uiaction#fields( ... ) abort
  if a:0
    let item = { 'type' : 'not_found' }
    for ui in g:dbman_ui_items
      if ui.type == 'table' && ui.table == a:1
        let item = ui
        break
      endif
    endfor
  else
    let item_index = dbman#util#item_index(line('.'))
    let item = g:dbman_ui_items[item_index]
  endif

  if item.type == 'table'
    let url = item.target.url
    let table = item.table
    let fields = db#adapter#call(url, 'fields', [url, table], [])
    let lines = []

    for field in fields
      let line = (field.pk ? '(PK) ' : '') . field.name
      call add(lines, line)

      let line =  repeat(' ', g:dbman_shiftwidth) . field.type

      if field.notnull
        let line = line . ' NN'
      endif
      if field.default != ''
        let line = line . ' = ' . field.default
      endif

      call add(lines, line)
    endfor

    if lines != []
      let line = nr2char(0xf0ce) . ' ' . table
      call insert(lines, line)

      call s:info(lines)
    endif
  endif
endfunction

function! dbman#uiaction#copy_select_query( ... ) abort
  if a:0
    let item = { 'type' : 'not_found' }
    for ui in g:dbman_ui_items
      if ui.type == 'table' && ui.table == a:1
        let item = ui
        break
      endif
    endfor
  else
    let item_index = dbman#util#item_index(line('.'))
    let item = g:dbman_ui_items[item_index]
  endif

  if item.type == 'table'
    let url = item.target.url
    let table = item.table
    let fields = db#adapter#call(url, 'fields', [url, table], [])
    let line = 'select ' . join(map(fields, {_, v -> v.name}), ', ')
    let line = line . "\n" . 'from ' . table . ';'

    let @@ = line
    let @* = line
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:create_new_window(direction, file) abort
  if a:direction == 'v' || winnr('$') == 1
    silent! exe "vertical rightbelow new "
  else
    silent! exe "wincmd l"
    silent! exe "belowright new"
  endif
  silent! exe "edit " . a:file
  setlocal filetype=sql nolist noswapfile nowrap cursorline nospell modifiable
endfunction

function! s:info(lines) abort
  let previousWindow = winnr()

  if !dbman#util#goto_window(g:dbmaninfo_bufname)
    let curWindow = winnr()
    exe "wincmd l"
    while curWindow != winnr()
      let curWindow = winnr()
      exe "wincmd l"
    endwhile
    silent! exec "rightbelow vertical new " . g:dbmaninfo_bufname
    setlocal filetype=dbmaninfo
    silent! exe 'vertical topleft resize '.g:dbmaninfo_winwidth
  endif

  setlocal modifiable
  silent 1,$delete _

  call append(0, a:lines)

  setlocal nomodifiable nomodified
  exe "normal gg"
  exec previousWindow . "wincmd w"
endfunction

function! s:postpad(s, amt, ...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return a:s . repeat(char, a:amt - len(a:s))
endfunction

function! s:prepad(s, amt, ...)
    if a:0 > 0
        let char = a:1
    else
        let char = ' '
    endif
    return repeat(char,a:amt - len(a:s)) . a:s
endfunction
