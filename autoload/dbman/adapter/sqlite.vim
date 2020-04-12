if exists('g:loaded_dbman_adapter_sqlite_autoload')
  finish
endif
let g:loaded_dbman_adapter_sqlite_autoload = 1

function! dbman#adapter#sqlite#canonicalize(url) abort
  return db#adapter#sqlite#canonicalize(a:url)
endfunction

function! dbman#adapter#sqlite#test_file(file) abort
  return db#adapter#sqlite#test_file(a:file)
endfunction

function! dbman#adapter#sqlite#dbext(url) abort
  return db#adapter#sqlite#dbext(a:url)
endfunction

function! dbman#adapter#sqlite#command(url) abort
  return db#adapter#sqlite#command(a:url)
endfunction

function! dbman#adapter#sqlite#interactive(url) abort
  return db#adapter#sqlite#interactive(a:url)
endfunction

function! dbman#adapter#sqlite#massage(input) abort
  return db#adapter#sqlite#massage(a:input)
endfunction

function! s:sqlite_cmd(url, cmd)
  return split(system(db#adapter#sqlite#command(a:url) . ' -noheader -cmd "' . a:cmd . '"'), "\n")
endfunction

function! dbman#adapter#sqlite#tables(url) abort
  return s:sqlite_cmd(a:url, "select name from sqlite_master where type = \'table\'")
endfunction

function! dbman#adapter#sqlite#fields(url, table) abort
  let column_info = map(s:sqlite_cmd(a:url, 'pragma table_info(' . a:table .')'), { k, v -> split(v, '|') })
  let columns = []

  for c in column_info
    let column = { 'name' : c[1], 'type' : c[2], 'notnull' : c[3], 'default' : c[4], 'pk' : c[5]}
    call add(columns, column)
  endfor
  return columns
endfunction
