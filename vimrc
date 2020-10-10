set number

set tabstop=4
set expandtab
set ruler
set shiftwidth=4
set encoding=utf-8
set wrap

set nocompatible

syntax enable

" set background="light"
colorscheme desert

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunc

" Search related settings
set incsearch
set hlsearch

" Map Ctrl+l to clear highlighted searches
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>


set nofoldenable

