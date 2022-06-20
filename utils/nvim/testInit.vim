"  _   _                           _            _
" | |_| |__   ___    __ _ _ __ ___| |_ ___  ___(_) __ _ _ __
" | __| '_ \ / _ \  / _` | '__/ __| __/ _ \/ __| |/ _` | '_ \
" | |_| | | |  __/ | (_| | | | (__| ||  __/\__ \ | (_| | | | |
"  \__|_| |_|\___|  \__,_|_|  \___|\__\___||___/_|\__,_|_| |_|
"
"  Github: https://github.com/TheArctesian


" Vim plug 
" Install with 
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/preservim/nerdtree'
" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

" Airline
let g:airline_theme="deus"
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#tabline_format = '%tabline_tabs%'
let g:airline_powerline_fonts=1

" Wilder 
call wilder#setup({'modes': [':', '/', '?']})
set guifont=CaskaydiaCove\Nerd\Font\Mono:h15
" Neovide 
let g:neovide_cursor_vfx_mode = "railgun"
" Std stuff
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

