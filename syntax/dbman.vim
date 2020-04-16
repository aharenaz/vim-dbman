if exists("b:current_syntax")
    finish
endif

syntax keyword tableList Tables
highlight link tableList Keyword

syntax match queriesList "\<Saved queries\>"
highlight link queriesList Keyword

let b:current_syntax = "dbman"
