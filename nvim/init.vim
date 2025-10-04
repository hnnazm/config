" Basic settings
let mapleader = " "

set nocompatible
set hidden
set confirm

set clipboard+=unnamedplus

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set shiftround

set splitbelow
set splitright

set scrolloff=10
set sidescroll=10
set sidescrolloff=10

set number
set relativenumber

set signcolumn=yes

set completeopt+=menuone,noselect,popup
set winborder=rounded

" Netrw settings
let g:netrw_banner = 0
let g:netrw_winsize = 30
let g:netrw_wiw = 30
let g:netrw_usetab = 1
let g:netrw_browse_split = 0
let g:netrw_liststyle = 3
let g:netrw_altfile = 1
let g:netrw_keepdir = 1
let g:netrw_dirhistmax = 0
let g:netrw_browsex_viewer = "open"
let g:netrw_sort_by = "exten"
let g:netrw_sort_direction = "normal"
let g:netrw_sort_options = "i"
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

" Keymaps
nnoremap <Leader>f :Rex<CR>

function! VisualRuler()
  set cursorcolumn! cursorline!
endfunction

nnoremap <LocalLeader>r :call VisualRuler()<CR>
nnoremap <LocalLeader>w :set wrap!<CR>

nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-x><C-b> :bprevious<CR>:bdelete #<CR>

nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-x><C-t> :tabclose<CR>
nnoremap <Esc>h :-tabmove<CR>
nnoremap <Esc>l :+tabmove<CR>
nnoremap <C-w><C-e> :tab split<CR>

nnoremap <C-x>t :tabclose<CR>
nnoremap <C-x>b :bp<CR>:bd #<CR>

nnoremap <Leader>o :<C-u>find 
nnoremap <Leader>i :<C-u>buffer 

vnoremap p "_dP

nnoremap <BS> :nohlsearch<CR>

nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cq :cclose<CR>
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>

vnoremap <Leader>x :<C-U>execute ":'<,'>w !bash"<CR>

tnoremap <Esc><Esc> <C-\><C-n>

" Path settings for finding files
let s:default_path = escape(&path, '\ ') " store default value of 'path'

autocmd VimEnter *
      \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
      \ exec "set path-=".s:tempPath |
      \ exec "set path-=".s:default_path |
      \ exec "set path^=".s:tempPath |
      \ exec "set path^=".s:default_path

" Use ripgrep if available
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

if has('nvim')
  lua require('config')
endif
