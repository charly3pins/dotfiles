filetype plugin indent on
set encoding=utf-8
set noswapfile

" hybrid line numbers
set number relativenumber

" indentation
set autoindent
set noexpandtab
set tabstop=4 
set shiftwidth=4

" remap arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" completion popup menu config
" remove the preview
set completeopt-=preview
set completeopt+=menuone,noinsert

" theme
syntax on
colorscheme molokai

" change split direction
set splitright
set splitbelow

" plugins
call plug#begin('~/.vim/plugged')
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'preservim/nerdtree'
    Plug 'preservim/nerdcommenter'
    Plug 'vim-airline/vim-airline'
call plug#end()

" autocomplete called when . is typped
au filetype go inoremap <buffer> . .<C-x><C-o>

" vim-go config
" Enable auto formatting on save
let g:go_fmt_autosave = 1
" Run goimports on every save
let g:go_fmt_command = "goimports"
" Status line for types and signatures
let g:go_auto_type_info = 1
" Syntax Highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

" NERDTree plugin specific commands
:nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" NerdCommenter plugin specific commands
filetype plugin on
nnoremap ,c :call NERDComment(0,"toggle")<CR>
vnoremap ,c :call NERDComment(0,"toggle")<CR>
