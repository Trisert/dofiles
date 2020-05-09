if empty(glob('~/.vim/autoload/plug.vim'))
	  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif



    " Specify a directory for plugins
    " " - For Neovim: stdpath('data') . '/plugged'
    " " - Avoid using standard Vim directory names like 'plugin'
     call plug#begin('~/.vim/plugged')
    "
    " " Make sure you use single quotes
    "
    " " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
     Plug 'junegunn/vim-easy-align'
    "
    " " Any valid git URL is allowed
     Plug 'https://github.com/junegunn/vim-github-dashboard.git'
    "
    " " Multiple Plug commands can be written in a single line using |
    " separators
     Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    "
    " " On-demand loading
     Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
     Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
    "
    " " Using a non-master branch
     Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
    "
    " " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
     Plug 'fatih/vim-go', { 'tag': '*' }
    "
    " " Plugin options
     Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
    
    "  Fuzzy-Finder
     Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
     Plug 'junegunn/fzf.vim'
    
    " Lightline
     Plug 'itchyny/lightline.vim'
     
     Plug 'lilydjwg/colorizer'

     Plug 'kovetskiy/sxhkd-vim'



    " " Unmanaged plugin (manually installed and updated)
    " Plug '~/my-prototype-plugin'
    
    " " Initialize plugin system
     call plug#end()

 set nocompatible
 set number

 set laststatus=2

 let g:lightline = {
	\'colorscheme': 'seoul256',
	\ }



