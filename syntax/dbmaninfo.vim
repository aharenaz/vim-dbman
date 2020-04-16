if exists("b:current_syntax")
    finish
endif

syntax match tableField "^\S\+.*$"
highlight link tableField Identifier

syntax match fieldType "^\s\+\(.*\)\s\+\(NN\)\@=\|^\s\+\(.*\)\s\+\(=\)\@=\|^\s\+\(.*\)$"
highlight link fieldType Type

syntax match fieldNotNull "\<NN\>"
highlight link fieldNotNull Special

syntax match fieldDefault "=.*"
highlight link fieldDefault Constant

let b:current_syntax = "dbmaninfo"
