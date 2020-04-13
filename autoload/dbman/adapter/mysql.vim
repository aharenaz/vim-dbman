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

function! dbman#adapter#mysql#tables(url) abort
  return split(system(s:command_for_url(a:url). ' -N -e "show tables"'), "\n")
endfunction
