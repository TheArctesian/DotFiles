set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 

set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tab stops so <BS> 
                            " does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for auto indents
set autoindent              " indent a new line 
                            " the same amount as the line just typed

set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursor line
set ttyfast                 " Speed up scrolling in Vim
set spell                 " enable spell check 
set noswapfile            " disable creating swap file


call plug#begin()
 Plug 'dracula/vim'
 Plug 'ryanoasis/vim-devicons'
 Plug 'honza/vim-snippets'
 Plug 'scrooloose/nerdtree'
 Plug 'preservim/nerdcommenter'
 Plug 'liuchengxu/space-vim-dark'
 Plug 'https://github.com/vim-airline/vim-airline'
 Plug 'kyazdani42/nvim-web-devicons'
 Plug 'romgrk/barbar.nvim'
 Plug 'keitokuch/vterm'
 Plug 'https://github.com/vim-airline/vim-airline-themes'
 Plug 'https://github.com/preservim/nerdtree'
 Plug 'mhinz/vim-startify'
 Plug 'evanleck/vim-svelte', {'branch': 'main'}
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
"k color schemes
set termguicolors
syntax enable
"colorscheme evening
colorscheme dracula" open new split panes to right and below
set splitright
set splitbelow

" move split panes to left/bottom/top/right
 nnoremap <A-h> <C-W>H
 nnoremap <A-j> <C-W>J
 nnoremap <A-k> <C-W>K
 nnoremap <A-l> <C-W>L" move between panes to left/bottom/top/right
 nnoremap <C-h> <C-w>h
 nnoremap <C-j> <C-w>j
 nnoremap <C-k> <C-w>k
 nnoremap <C-l> <C-w>l

 let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-clangd', 'coc-solidity', 'coc-rls', 'coc-pyright', 'coc-markdownlint', 'coc-html', 'coc-java', 'coc-tsserver', 'coc-go', ]

" Neovide

let g:neovide_floating_blur_amount_x = 2.0
let g:neovide_floating_blur_amount_y = 2.0
let g:neovide_transparency=0.8
let g:neovide_cursor_vfx_mode = "torpedo"
let g:neovide_cursor_vfx_particle_lifetime=1.2
