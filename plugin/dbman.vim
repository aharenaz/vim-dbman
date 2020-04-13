if exists('g:loaded_dbman')
    finish
endif
let g:loaded_dbman = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:dbman_query_save_path = "~/.config/nvim/dbman/query"
let g:dbman_connections_file = "~/.config/nvim/dbman/connections.data"
let g:dbman_winwidth  = 35
let g:dbmaninfo_winheight  = 15
let g:dbman_shiftwidth = 3
let g:dbman_start_line = 0
let g:dbman_start_column = 0

xnoremap <expr> <Plug>(DBManExecute)     dbman#query#execute()
nnoremap <expr> <Plug>(DBManExecute)     dbman#query#execute()
nnoremap <expr> <Plug>(DBManExecuteLine) dbman#query#execute() . '_'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status line function
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DBManBufferDBName(bufnr)
  if &ft != 'sql'
    return ''
  endif
  if !has_key(g:dbman_buffer_db, a:bufnr)
    return ''
  endif
  return g:dbman_buffer_db[a:bufnr].name
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global variables
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:dbman_bufname = ':dbman:'
let g:dbmaninfo_bufname = ':dbmaninfo:'
let g:dbman_db_list = []

let g:dbman_buffer_db = {}
let g:dbman_current_db = {}

let g:dbman_buffer_bindparams = {}
let g:dbman_current_bindparams = {}

let g:dbman_ui_items = []

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adapters override (used by dadbod)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:db_adapter_sqlite = 'dbman#adapter#sqlite#'
let g:db_adapter_mysql = 'dbman#adapter#mysql#'
let g:db_adapter_oracle = 'dbman#adapter#oracle#'
