"     _   _ ____                                                              
"    | \ | |  _ \     Nicola Destro                                           
"    |  \| | | | |    https://github.com/Trisert/dotfiles                     
"    | |\  | |_| |                                                            
"    |_| \_|____/                                                             
"                                                                             
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
	  silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs
	      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
    endif

    " Specify a directory for plugins
    " " - For Neovim: stdpath('data') . '/plugged'
    " " - Avoid using standard Vim directory names like 'plugin'
     call plug#begin('~/.vim/plugged')
    " " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
     Plug 'junegunn/vim-easy-align'
    "
    " " Any valid git URL is allowed
     Plug 'https://github.com/junegunn/vim-github-dashboard.git'
    "
    " " Multiple Plug commands can be written in a single line using |
    " separators
     Plug 'honza/vim-snippets'

     Plug 'preservim/nerdtree'

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

     Plug 'ghifarit53/sonokai'

     Plug 'leafgarland/typescript-vim'

     Plug 'mbbill/undotree'

     Plug 'dpretet/vim-leader-mapper'

     Plug 'johannesthyssen/vim-signit'

     Plug 'jacoborus/tender.vim'

     call plug#end()

 syntax on

 set number
 set noerrorbells
 set tabstop=4 softtabstop=4
 set shiftwidth=4
 set expandtab
 set smartindent
 set nu
 set nowrap
 set smartcase
 set noswapfile
 set nobackup
 set undodir=~/.vim/undodir
 set undofile
 set incsearch

 let g:lightline = {
	\'colorscheme': 'tender',
	\ }

 " important!!
set termguicolors

 syntax enable 
if(has("termguicolors"))
 colorscheme tender
endif

 " Define the menu content with a Vim dictionary
let g:leaderMenu = {'name':  "",
             \'f': [":Files",       "FZF file search"],
             \'b': [":Buffers",     "FZF buffer search"],
             \'s': [":BLines",      "FZF text search into current buffer"],
             \'S': [":Lines",       "FZF text search across loaded buffers"],
             \'g': [":BCommits",    "FZF git commits of the current buffer"],
             \'G': [":Commits",     "FZF git commits of the repository"],
             \'v': [':vsplit',      'Split buffer vertically'],
             \'h': [':split',       'Split buffer horizontally'],
             \'d': [':bd',          'Close buffer'],
             \'r': [':so $MYVIMRC', 'Reload vimrc without restarting Vim'],
             \'l': [':ls',          'List opened buffers'],
             \'t': [':Tags',        'FZF tag search'],
             \'o': [':normal gf',   'Open file under cursor'],
             \}

 " Define leader key to space and call vim-leader-mapper
nnoremap <Space> <Nop>
let mapleader = "\<Space>"
nnoremap <silent> <leader> :LeaderMapper "<Space>"<CR>
vnoremap <silent> <leader> :LeaderMapper "<Space>"<CR>



 nnoremap <leader>h :wincmd h<CR>
 nnoremap <leader>j :wincmd j<CR>
 nnoremap <leader>k :wincmd k<CR>
 nnoremap <leader>l :wincmd l<CR>
