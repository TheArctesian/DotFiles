: set number
: set autoindent
: set smarttab
: set relativenumber
: syntax on
" Plugins
call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/preservim/nerdtree'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'keitokuch/vterm'
call plug#end()

" Nerd Tree
nnoremap <C-w> : NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable="->"
let g:NERDTreeDirArrowCollapsible="<-"

" Airline
let g:airline_theme="violet"

" Vterm
let g:vterm_map_toggleterm = '<C-t>'
let g:vterm_map_togglefocus = '<C-q>'
let g:vterm_map_zoomnormal = 'a'
let g:vterm_map_zoomterm = ';a'
let g:vterm_map_escape = ';;'
