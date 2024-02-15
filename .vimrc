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
set softtabstop=4
set tabstop=4
set shiftwidth=4
set ruler
set showcmd

filetype plugin on

map <C-b> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)
