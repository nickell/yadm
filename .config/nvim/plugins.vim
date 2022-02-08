" Motions and keys
Plug 'Lokaltog/vim-easymotion'
Plug 'ervandew/supertab'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-scripts/BufOnly.vim'
" Plug 'jeetsukumaran/vim-indentwise'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Files
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" Search
Plug 'bronson/vim-visual-star-search'
Plug 'Arkham/vim-quickfixdo'

" Javascript
" Plug 'moll/vim-node'
" Plug 'dgraham/vim-eslint'
" Plug 'prettier/vim-prettier', {
"   \ 'do': 'yarn install',
"   \ 'for': ['javascript', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html']
"   \ }

" tpope {{{
" :S command, change case (crs, crc, etc.)
Plug 'tpope/vim-abolish'

" Repeat some tpope plugins with .
Plug 'tpope/vim-repeat'

" Use <c-a> <c-x> to increment dates/times
Plug 'tpope/vim-speeddating'

" change surrounding quotes, tags, etc.
Plug 'tpope/vim-surround'

" bracket commands ]<space> for line above, 
Plug 'tpope/vim-unimpaired'

" Vim sugar for unix shell commands :Delete, :Rename, :Move, etc.
Plug 'tpope/vim-eunuch'

" Automatically end vim/bash functions and if statements (and others)
Plug 'tpope/vim-endwise'

" Comment shortcut gcc
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring' " contexts for jsx regions
" }}}

" Status and tab line
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-buftabline'
" Plug 'shinchu/lightline-gruvbox.vim'

" Syntax
" Javascript/Typescript/React syntax
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'elzr/vim-json'
" Plug 'peitalin/vim-jsx-typescript' using MaxMEllon/vim-jsx-pretty instead
" Plug 'jason0x43/vim-js-indent'

Plug 'pantharshit00/vim-prisma'
Plug 'lifepillar/pgsql.vim'
Plug 'chr4/nginx.vim'
Plug 'othree/html5.vim'
Plug 'neovimhaskell/haskell-vim'
" Plug 'hashivim/vim-terraform'
Plug 'tpope/vim-liquid'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'alvan/vim-closetag'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'vim-scripts/changesqlcase.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'evanleck/vim-svelte'
" Plug 'sheerun/vim-polyglot'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}

" Colorschemes
Plug 'Yggdroot/indentLine'
Plug 'gerw/vim-HiLinkTrace'
Plug 'ryanoasis/vim-devicons'
Plug 'jparise/vim-graphql'
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'ajh17/Spacegray.vim'
" Plug 'bounceme/highwayman'
" Plug 'cocopon/iceberg.vim'
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'flazz/vim-colorschemes'
" Plug 'fneu/breezy'
" Plug 'gertjanreynaert/cobalt2-vim-theme'
" Plug 'joshdick/onedark.vim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'mhartington/oceanic-next'
" Plug 'mhartington/oceanic-next'
" Plug 'rafi/awesome-vim-colorschemes'
" Plug 'sickill/vim-monokai'

" Random tools
Plug 'diepm/vim-rest-console'

" IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/dbext.vim'
Plug 'honza/vim-snippets'
Plug 'alx741/vim-hindent'
" Plug 'bagrat/vim-buffet'
