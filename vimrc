"-----------------------------------------
"Vundle
"-----------------------------------------
"Requred by vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"Plugins need to be between vundle begin/end
"-----------------------------------------
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'flazz/vim-colorschemes'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'dani-h/typescript-vim'
Plugin 'clausreinke/typescript-tools'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Chiel92/vim-autoformat'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
"-----------------------------------------
"Temporary plugins that can be disabled
"-----------------------------------------
Plugin 'jimenezrick/vimerl'
"-----------------------------------------
call vundle#end()
"End required by vundle
"-----------------------------------------
"General settings
"-----------------------------------------
" Silences C-Q, C-S and allows vim to catch them
silent !stty -ixon > /dev/null 2>/dev/null
set number
" Highlight search
set hlsearch
" Show search while typing
set incsearch
" Ignore case
set wildignorecase
" Set pwd to current file
set autochdir
" Can switch buffers without saving
set hidden
" Paste mode
set pastetoggle=<F9>
" Smart search. If uppercase chars search case sensitive.
set smartcase
" Resets search
autocmd InsertEnter * set cursorline
autocmd InsertLeave * set nocursorline

" Close buffer without closing window
nnoremap <C-w> :bp<bar>sp<bar>bn<bar>bd<CR>
"-----------------------------------------
" General remappings
"-----------------------------------------
let mapleader = ","
" System clipboard c/p
vnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>p "+p
nnoremap <leader>P "+P
" Movement
map q b
map g gg
" map control-backspace to delete the previous word
imap <C-BS> <C-W>
" Firefox like tab switching
if has("gui_running")
  noremap <C-tab> :call Next_buffer()<cr>
  noremap <C-S-tab> :call Previous_buffer()<cr>
  noremap <C-t> :enew<CR>
else
  nnoremap <leader>w :call Next_buffer()<cr>
  nnoremap <leader>q :call Previous_buffer()<cr>
  nnoremap <leader>t :enew()<cr>
endif
"Window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Clear highlight with enter
nnoremap <CR> :noh<CR><CR>


"-----------------------------------------
"Color scheme settings
"-----------------------------------------
"Make sure to place color schemes after the vundle runtime has been declared
syntax enable
colorscheme Monokai
set guifont=Monaco
filetype plugin indent on
"-----------------------------------------
"Indentation settings
"-----------------------------------------
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType typescript,javascript,css,scss,vim setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType html setlocal expandtab shiftwidth=4 tabstop=4
"-----------------------------------------
"Plugin specific settings
"-----------------------------------------
"EasyMotion
"-----------------------------------------
" Disable default mappings
"let g:EasyMotion_do_mapping = 0 
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
" Find one char one line
map f <Plug>(easymotion-sl)
map t <Plug>(easymotion-bd-tl)
" Find two chars multiple lines
map F <Plug>(easymotion-s2)
" j,k: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"-----------------------------------------
"CtrlP/CtrlPFunky
"-----------------------------------------
"CtrlP Sets the current working path to a .git path
let g:ctrlp_working_path_mode = 'ra'
"CtrlP remap
let g:ctrlp_map = '<C-p>'
nnoremap <C-A-p> :execute 'CtrlPFunky'<CR>
nnoremap <leader>b :CtrlPMRU<cr>
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|pyc|patch)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }
"-----------------------------------------
"YouCompleteMe
"-----------------------------------------
"YCM shows completions opts in the preview window
let g:ycm_add_preview_to_completeopt = 1
"YCM closes preview window on esc
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:EclimCompletionMethod = 'omnifunc'

let g:ycm_semantic_triggers =  {
      \   'c' : ['->', '.'],
      \   'objc' : ['->', '.'],
      \   'ocaml' : ['.', '#'],
      \   'cpp,objcpp' : ['->', '.', '::'],
      \   'perl' : ['->'],
      \   'php' : ['->', '::'],
      \   'cs,java,javascript,d,python,perl6,scala,vb,elixir,go,typescript' : ['.'],
      \   'vim' : ['re![_a-zA-Z]+[_\w]*\.'],
      \   'ruby' : ['.', '::'],
      \   'lua' : ['.', ':'],
      \   'erlang' : [':'],
      \ }

"-----------------------------------------
"Collection of GoToDef for plugins
"-----------------------------------------
autocmd FileType typescript map <buffer><F2> :TSSdefpreview<CR>
autocmd FileType typescript map <buffer><F3> :TSSdef<CR>
autocmd FileType python map <buffer><F2> <CR>
autocmd FileType python map <buffer><F3> :YcmCompleter GoToDefinition<CR>
"Eclim scalasearch
autocmd FileType scala map <F3> :ScalaSearch<cr>
"Ycm Erlang completion shouldn't close on typing
autocmd FileType erlang let g:ycm_cache_omnifunc = 0
autocmd FileType c,cpp,java,php,ruby,python,javascript,typescript let g:ycm_cache_omnifunc = 1
"GitGutter
hi SignColumn guibg=black ctermbg=black

"-----------------------------------------
"Syntastic
"-----------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint']

"Pylint syntastic
let g:syntastic_python_pylint_args='-E -d C0301,C0111,C0103,R0903,W0614,W0611,E1601'
"Typescript syntastic
let g:syntastic_typescript_tsc_args = '--module commonjs --target ES5'

"-----------------------------------------
"VimAirline
"-----------------------------------------
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show the filename or parent/filename if filename is same
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
"-----------------------------------------
"NERDCommenter
"-----------------------------------------
nnoremap <leader>c :call NERDComment(0, "toggle")<CR>
vnoremap <leader>c :call NERDComment(0, "toggle")<CR>
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

"-----------------------------------------
"NERDTree
"-----------------------------------------
let NERDTreeIgnore = ['\.pyc$', '\.db$']
noremap <F5> :NERDTreeToggle<CR>
"Strip trailing whitespace
autocmd FileType c,cpp,java,php,ruby,python,typescript,erlang autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Only cycle between files, not location lists. Does not work recursively, but
" it seems like there is only one quickfix/location window at a time
fu! Next_buffer()
  bnext
  if &filetype == 'qf'
    bnext 
  endif
endfunction

fu! Previous_buffer()
  bprevious
  if &filetype == 'qf'
    bprevious
  endif
endfunction

"-----------------------------------------
"Nvim
"-----------------------------------------
if has("nvim")
  set backspace=indent,eol,start
endif
