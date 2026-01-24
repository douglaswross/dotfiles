" Douglas Ross's vimrc
" Minimal but useful configuration

" ===== General =====
set nocompatible          " Use Vim settings, not Vi
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable filetype detection

" ===== Display =====
set number                " Show line numbers
set relativenumber        " Relative line numbers
set ruler                 " Show cursor position
set showcmd               " Show command in bottom bar
set showmatch             " Highlight matching brackets
set cursorline            " Highlight current line
set laststatus=2          " Always show status line
set wildmenu              " Visual autocomplete for command menu

" ===== Indentation =====
set tabstop=2             " Tabs are 2 spaces
set shiftwidth=2          " Indent by 2 spaces
set softtabstop=2         " Backspace through 2-space tabs
set expandtab             " Use spaces, not tabs
set autoindent            " Auto-indent new lines
set smartindent           " Smart auto-indenting

" ===== Search =====
set incsearch             " Search as characters are entered
set hlsearch              " Highlight search matches
set ignorecase            " Case-insensitive search
set smartcase             " Unless capital letters used

" ===== Behavior =====
set backspace=indent,eol,start  " Backspace works normally
set mouse=a               " Enable mouse support
set clipboard=unnamedplus " Use system clipboard
set autoread              " Reload files changed outside vim
set hidden                " Allow hidden buffers
set scrolloff=5           " Keep 5 lines above/below cursor

" ===== Performance =====
set lazyredraw            " Don't redraw during macros
set ttyfast               " Faster terminal connection

" ===== Key Mappings =====
" Leader key
let mapleader = " "

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==

" ===== File-specific =====
autocmd FileType javascript setlocal ts=2 sw=2
autocmd FileType typescript setlocal ts=2 sw=2
autocmd FileType json setlocal ts=2 sw=2
autocmd FileType yaml setlocal ts=2 sw=2
autocmd FileType python setlocal ts=4 sw=4

" ===== Colors =====
" Use a dark background
set background=dark

" Try to use a nice colorscheme if available
try
    colorscheme desert
catch
endtry
