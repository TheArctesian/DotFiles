: set number
: set encoding=UTF-8
: set spelllang=en
: set spellsuggest=best,9
: set smarttab
: set autoindent
: set tabstop=4
: set mouse=v
: set shiftwidth=4
: set expandtab
: set cursorline 
: syntax on
" Plugins
call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/preservim/nerdtree'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'keitokuch/vterm'
Plug 'ryanoasis/vim-devicons'
Plug 'honza/vim-snippets'
Plug 'liuchengxu/space-vim-dark'
Plug 'https://github.com/github/copilot.vim'
call plug#end()

" Nerd Tree
nnoremap <C-w> : NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable="->"
let g:NERDTreeDirArrowCollapsible="<-"

" Airline
let g:airline_theme="violet"
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#tabline_format = '%tabline_tabs%'
let g:airline_powerline_fonts=1
"Vterm
let g:vterm_map_toggleterm = '<C-t>'
let g:vterm_map_togglefocus = '<C-q>'
let g:vterm_map_zoomnormal = 'a'
let g:vterm_map_zoomterm = ';a'
let g:vterm_map_escape = ';;'
colorscheme space-vim-dark
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi Comment cterm=italic
