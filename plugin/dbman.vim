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
" Global variables
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:dbman_bufname = ':dbman:'
let g:dbmaninfo_bufname = ':dbmaninfo:'
let g:db_list = []

let g:buffer_db = {}
let g:current_db = {}

let g:buffer_bindparams = {}
let g:current_bindparams = {}

let g:ui_items = []

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Adapters override
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:db_adapter_sqlite = 'dbman#adapter#sqlite#'
let g:db_adapter_mysql = 'dbman#adapter#mysql#'
let g:db_adapter_oracle = 'dbman#adapter#oracle#'
