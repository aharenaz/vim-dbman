if exists('g:loaded_dbman_adapter_mysql_autoload')
  finish
endif
let g:loaded_dbman_adapter_mysql_autoload = 1

function! dbman#adapter#mysql#canonicalize(url) abort
  return db#adapter#mysql#canonicalize(a:url)
endfunction

function! dbman#adapter#mysql#interactive(url) abort
  return db#adapter#mysql#interactive(a:url)
endfunction

function! dbman#adapter#mysql#filter(url) abort
  return db#adapter#mysql#filter(a:url)
endfunction

function! dbman#adapter#mysql#auth_pattern() abort
  return db#adapter#mysql#auth_pattern()
endfunction

function! dbman#adapter#mysql#complete_opaque(url) abort
  return db#adapter#mysql#complete_opaque(a:url)
endfunction

function! dbman#adapter#mysql#complete_database(url) abort
  return db#adapter#mysql#complete_database(a:url)
endfunction

function! s:command_for_url(url) abort
  let params = db#url#parse(a:url).params
  return 'mysql' .
        \ (has_key(params, 'login-path') ? ' --login-path=' . shellescape(params['login-path'])  : '') .
        \ db#url#as_args(a:url, '-h ', '-P ', '-S ', '-u ', '-p', '')
endfunction

function! s:mysql_cmd(url, cmd)
  let output = map(split(system(s:command_for_url(a:url) . ' -t -N -e "' . a:cmd . '"'), "\n")
        \ , { _, v -> map(split(v, '|'), { _, vs -> trim(vs) }) })
  let clean_output = []

  for line in output
    if line[0][0] != '+'
      call add(clean_output, line)
    endif
  endfor

  return clean_output
endfunction

function! dbman#adapter#mysql#tables(url) abort
  let tables = []
  
  for row in s:mysql_cmd(a:url, "show tables")
    call add(tables, row[0])
  endfor

  return tables
endfunction

function! dbman#adapter#mysql#fields(url, table) abort
  let column_info = s:mysql_cmd(a:url, 'describe ' . a:table)
  let columns = []

  for c in column_info
    let column = { 'name' : c[0]
          \ , 'type' : c[1]
          \ , 'notnull' : (c[2] == 'NO' ? 1 : 0)
          \ , 'default' : (c[4] != 'NULL' ? c[4] : '')
          \ , 'pk' : (c[3] == 'PRI' ? 1 : 0) }
    call add(columns, column)
  endfor
  return columns
endfunction
