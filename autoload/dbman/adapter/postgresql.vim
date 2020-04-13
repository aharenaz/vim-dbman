if exists('g:loaded_dbman_adapter_postgresql_autoload')
  finish
endif
let g:loaded_dbman_adapter_postgresql_autoload = 1

function! dbman#adapter#postgresql#canonicalize(url) abort
	return db#adapter#postgresql#canonicalize(a:url)
endfunction

function! dbman#adapter#postgresql#interactive(url, ...) abort
	return call("db#adapter#postgresql#interactive", a:url, a:000)
endfunction

function! dbman#adapter#postgresql#filter(url) abort
	return db#adapter#postgresql#filter(a:url)
endfunction

function! dbman#adapter#postgresql#complete_database(url) abort
	return db#adapter#postgresql#complete_database(a:url)
endfunction

function! dbman#adapter#postgresql#complete_opaque(_) abort
	return db#adapter#postgresql#complete_opaque(_)
endfunction

function! dbman#adapter#postgresql#can_echo(in, out) abort
	return db#adapter#postgresql#can_echo(a:in, a:out)
endfunction

function! dbman#adapter#postgresql#tables(url) abort
	return db#adapter#postgresql#tables(a:url)
endfunction
