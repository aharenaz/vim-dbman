if exists('g:loaded_dbman_adapter_mysql_autoload')
  finish
endif
let g:loaded_dbman_adapter_mysql_autoload = 1

function! db#adapter#mysql#canonicalize(url) abort
  return db#adapter#mysql#canonicalize(a:url)
endfunction

function! db#adapter#mysql#interactive(url) abort
  return db#adapter#mysql#interactive(a:url)
endfunction

function! db#adapter#mysql#filter(url) abort
  return db#adapter#mysql#filter(a:url)
endfunction

function! db#adapter#mysql#auth_pattern() abort
  return db#adapter#mysql#auth_pattern()
endfunction

function! db#adapter#mysql#complete_opaque(url) abort
  return db#adapter#mysql#complete_opaque(a:url)
endfunction

function! db#adapter#mysql#complete_database(url) abort
  return db#adapter#mysql#complete_database(a:url)
endfunction

function! db#adapter#mysql#tables(url) abort
  return db#adapter#mysql#tables(a:url)
endfunction
