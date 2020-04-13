if exists('g:loaded_dbman_adapter_oracle_autoload')
  finish
endif
let g:loaded_dbman_adapter_oracle_autoload = 1

function! dbman#adapter#oracle#canonicalize(url) abort
  return db#adapter#oracle#canonicalize(a:url)
endfunction

function! dbman#adapter#oracle#interactive(url) abort
  return db#adapter#oracle#interactive(a:url)
endfunction

function! dbman#adapter#oracle#filter(url) abort
  return db#adapter#oracle#filter(a:url)
endfunction

function! dbman#adapter#oracle#auth_pattern() abort
  return db#adapter#oracle#auth_pattern()
endfunction

function! dbman#adapter#oracle#dbext(url) abort
  return db#adapter#oracle#dbext(a:url)
endfunction

function! dbman#adapter#oracle#massage(input) abort
  return db#adapter#oracle#massage(a:input)
endfunction
