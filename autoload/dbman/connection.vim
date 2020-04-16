if exists('g:loaded_dbman_connection_autoload')
    finish
endif
let g:loaded_dbman_connection_autoload = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DB Selection function
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! dbman#connection#edit() abort
  call s:create_connections_file()
  exec "split " g:dbman_connections_file
endfunction

function! dbman#connection#list() abort
  call s:load_connections()

  let dbs = map(copy(g:dbman_db_list), {k,v -> { 'word': v.name, 'user_data':
        \ { 'bufnr' : bufnr(), 'winnr' : winnr() }
        \ }})

  if empty(dbs)
    echomsg "There is no connection configured. Please add a connection."
    return
  endif

  call actionmenu#open(dbs, 'dbman#connection#on_db_selected')
endfunction

function! dbman#connection#on_db_selected(idx, item) abort
  if a:idx != -1
    let db = { 'url': g:dbman_db_list[a:idx].url, 'name': g:dbman_db_list[a:idx].name }
    let bufnr = a:item.user_data.bufnr
    let winnr = a:item.user_data.winnr

    if db.url =~ ".*\$pass\$.*"
      let pass = pass#get(db.name)
      if pass == ""
        let pass = pass#get(db.name)
      endif
      if pass == ""
        echomsg "Couldn't get the password for " . db.name
        let db = {}
      else
        let db.url = substitute(db.url, "\\$pass\\$", pass, "")
      endif
    endif

    if db != {}
      call dbman#util#set_buffer_db(db, bufnr)
      call dbman#util#set_current_db(db)

      echomsg 'DB ' . db.name . ' is selected.'

      call dbman#ui()
    endif
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DB Connection Loading functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:create_connections_file() abort
  let connections_file = expand(g:dbman_connections_file)
  let connections_file_path = fnamemodify(connections_file, ":p:h")

  if ! isdirectory(connections_file_path)
    call mkdir(connections_file_path, "p")
  endif

  if !filereadable(connections_file)
    let header = [
          \ "#############################################################################################################################",
          \ "# The $pass$ variable gets substituted using 'pass' (https://www.passwordstore.org) with the full database entry name as key",
          \ "# The format is as follows:",
          \ "#",
          \ "# Database entry name",
          \ "# Dadbod URL",
          \ "# <empty line>",
          \ "#",
          \ "# For example:",
          \ "#",
          \ "# sql/pro/db",
          \ "# postgresql://user:$pass$@host/postgresdb",
          \ "#",
          \ "# My sqlite test DB",
          \ "# sqlite:/home/user/test.sqlite",
          \ "#"
          \ ]
    call writefile(header, connections_file, "a")
  endif
endfunction

function! s:load_connections()
  let f = expand(g:dbman_connections_file)
  let g:dbman_db_list = []

  call s:create_connections_file()

  let db = { "name" : "", "url" : "" }
  for l in filter(readfile(f), { _, l -> l !~ "^\s*#" && l !~ "^\s*$" })
    if db.name == ""
      let db.name = l
    elseif db.url == ""
      let db.url = l
    else
      call add(g:dbman_db_list, db)
      let db = { "name" : l, "url" : "" }
    endif
  endfor

  if db.name != "" && db.url != ""
    call add(g:dbman_db_list, db)
  endif
endfunction
