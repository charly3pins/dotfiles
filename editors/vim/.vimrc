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
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" autocomplete called when . is typped
au filetype go inoremap <buffer> . .<C-x><C-o>

" completion popup menu config
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
	Plug 'dense-analysis/ale'
call plug#end()

" vim-go config
" highlight all uses of the identifier under the cursor
let g:go_auto_sameids = 1
" Syntax Highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1

" NERDTree plugin specific commands
:nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" NerdCommenter plugin specific commands
filetype plugin on
nnoremap ,c :call NERDComment(0,"toggle")<CR>
vnoremap ,c :call NERDComment(0,"toggle")<CR>

" ale plugin
let g:ale_go_golangci_lint_package = 1
let g:ale_go_staticcheck_lint_package = 1

