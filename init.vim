" ~/config/nvim/init.vim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'rakr/vim-one'
Plug 'danilo-augusto/vim-afterglow'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

set termguicolors

if exists("g:neovide")
  " Only happens in Neovide
  let g:neovide_transparency = 0.8
  let g:neovide_cursor_vfx_mode = "railgun"
endif

let g:airline_theme='afterglow'

colorscheme afterglow

set tabstop=2 shiftwidth=2 expandtab
