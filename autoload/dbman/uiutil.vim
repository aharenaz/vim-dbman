if exists('g:loaded_dbman_uiutil_autoload')
    finish
endif
let g:loaded_dbman_uiutil_autoload = 1

function! dbman#uiutil#load_ui_items(db, params) abort
  let items = []

  for i in range(1, g:dbman_start_line)
    let item = { 'type' : 'separator', 'indent' : 0, 'text' : '' }
    call add(items, item)
  endfor

  let item = { 'type' : 'db', 'indent' : 0, 'text' : nr2char(0xf1c0) . ' ' . a:db.name }
  call add(items, item)

  let item = { 'type' : 'saved_group', 'indent' : 1, 'text' : nr2char(0xf719) . ' Saved queries' }
  call add(items, item)
  let item = { 'type' : 'new', 'target' : a:db,  'indent' : 2, 'text' : nr2char(0xf067) . ' New query' }
  call add(items, item)

  for saved_query in s:load_saved_queries(a:db)
    let query_name = s:saved_query_name_from_path(a:db, saved_query)
    let item = { 'type' : 'saved_query', 'target' : a:db, 'filename' : saved_query, 'indent' : 2, 'text' : query_name }
    call add(items, item)
  endfor

  if !empty(a:params)
    let item = { 'type' : 'params', 'indent' : 1, 'text' : nr2char(0xf0c1) . ' Params' }
    call add(items, item)
    for [var, val] in items(a:params)
      let item = { 'type' : 'param', 'var' : var, 'indent' : 2, 'text' : var . '->' . val }
      call add(items, item)
    endfor
  endif

  let item = { 'type' : 'tables', 'indent' : 1, 'text' : nr2char(0xf0ce) . ' Tables' }
  call add(items, item)

  for table in s:load_tables(a:db)
    let item = { 'type' : 'table', 'target' : a:db, 'table' : table, 'indent' : 2, 'text' : table }
    call add(items, item)
  endfor

  return items
endfunction

function! s:load_saved_queries(db) abort
  let query_save_path = expand(g:dbman_query_save_path)

  if isdirectory(query_save_path)
    let saved_files_glob_pattern = query_save_path . '/' . s:saved_query_filename_template(a:db) . '*'
    return split(glob(saved_files_glob_pattern), "\n")
  endif
  return []
endfunction

function! s:load_tables(db) abort
  let tables = []

  if empty(a:db.url)
    return tables
  endif

  let tables = db#adapter#call(a:db.url, 'tables', [a:db.url], [])
  if a:db.url =~? '^sqlite' && len(tables) ==? 1
    let tables = map(split(copy(tables[0])), 'trim(v:val)')
  endif

  return tables
endfunction

function! dbman#uiutil#new_saved_query_name(db) abort
  let query_save_path = expand(g:dbman_query_save_path)
  let last = 0

  if isdirectory(query_save_path)
    let saved_files_glob_pattern = query_save_path . '/' . s:saved_query_filename_template(a:db) . '*'
    let saved_files = split(glob(saved_files_glob_pattern), "\n")
  else
    call mkdir(query_save_path, "p")
    let saved_files = []
  endif

  for f in saved_files
    let num = substitute(f, ".*_\\(\\d\\+\\).*", {m -> m[1]}, "g")
    let num = substitute(num, "^0*", "", "g") + 0

    if num > last
      let last = num
    endif
  endfor
  let last = last + 1
  let strlast = "000".last
  let strlast = strlast[len(strlast) - 3:len(strlast)]
  let saved_files_pattern = expand(g:dbman_query_save_path) . '/' . s:saved_query_filename_template(a:db)

  return saved_files_pattern . strlast . ".sql"
endfunction

function! s:saved_query_filename_template(db) abort
  return substitute(a:db.name, '\\\s*\\\|\\\$*\\\|:\\\|_\\\|\\\*\\\|/', "", "g") . "_"
endfunction

function! s:saved_query_name_from_path(db, path)
  let saved_files_pattern = expand(g:dbman_query_save_path) . '/' . s:saved_query_filename_template(a:db)
  return substitute(a:path, saved_files_pattern, "", "g")
endfunction

