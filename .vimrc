set background=dark
:colorscheme dki
:syntax on
:filetype indent on
set mouse=a
set viminfo=""
set number
set linebreak
set visualbell
set autoindent
set softtabstop=2
set tabstop=2
set shiftwidth=4
set ruler
set showcmd
set ignorecase

filetype plugin on

map <C-b> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)
" Define a custom mapping to invoke fzf and insert the selected address
nnoremap <silent> <F2> :call InsertAddress()<CR>

" Function to insert the selected address at the cursor position
function! InsertAddress()
    " Run fzf to select an address
    let address = systemlist('fzf --preview "head -n 5 {}"')[-1]

    " Check if an address was selected
    if len(address) > 0
        " Insert the selected address at the cursor position
        execute "normal! i" . address
    endif
endfunction
