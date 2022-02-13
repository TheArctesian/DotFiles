: set number
: set autoindent
: set smarttab
: set relativenumber
" Plugins
call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/preservim/nerdtree'
call plug#end()

" Nerd Tree
nnoremap <C-n> : NERDTree<CR>
nnoremap <C-t> : NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable="->"
let g:NERDTreeDirArrowCollapsible="<-"

" Airline
let g:airline_theme="violet"
