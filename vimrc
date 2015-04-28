"-----------------------------------------
"Vim Plug
"-----------------------------------------
set nocompatible
call plug#begin('~/.vim/plugged')
"-----------------------------------------
Plug 'gmarik/Vundle.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
"-----------------------------------------
" Lang specific
"-----------------------------------------
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'dani-h/typescript-vim'
Plug 'clausreinke/typescript-tools.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'marijnh/tern_for_vim', {'do': 'npm install'}
"-----------------------------------------
call plug#end()
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
" Seems like backspace doesn't work for nvim and source compiled
" new vim versions
set backspace=indent,eol,start
set pastetoggle=<F9>
" Smart search. If uppercase chars search case sensitive.
set ignorecase smartcase
" Resets search
autocmd InsertEnter * set cursorline
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
" map control-backspace to delete the previous word
imap <C-BS> <C-W>
"Window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Clear highlight with enter
nnoremap <esc> :noh<cr><esc>

if has("gui_running")
" Firefox like tab switching
  noremap <C-tab> :call Next_buffer()<cr>
  noremap <C-S-tab> :call Previous_buffer()<cr>
  noremap <C-t> :enew<CR>
else
  nnoremap <M-w> :call Next_buffer()<cr>
  nnoremap <M-q> :call Previous_buffer()<cr>
  nnoremap <M-t> :enew()<cr>
endif
"-----------------------------------------
" Nvim
"-----------------------------------------
" has("gui_running") doesn't work using nvim, but we'll have cli mappings
" <M-keys> anyway
if has("nvim")
  noremap <C-tab> :call Next_buffer()<cr>
  noremap <C-S-tab> :call Previous_buffer()<cr>
  noremap <C-t> :enew<CR>
endif
"-----------------------------------------
" Color scheme settings
"-----------------------------------------
"Make sure to place color schemes after the vundle runtime has been declared
syntax enable
colorscheme Monokai
set guifont=Monaco
filetype plugin indent on
"-----------------------------------------
" Indentation settings
"-----------------------------------------
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType typescript,javascript,css,scss,vim setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType html,erlang,sh,make,php,snippets setlocal expandtab shiftwidth=4 tabstop=4
autocmd FileType make setlocal noexpandtab shiftwidth=4 tabstop=4
"-----------------------------------------
" Plugin specific settings
"-----------------------------------------
" EasyMotion
"-----------------------------------------
" Disable default mappings
let g:EasyMotion_do_mapping = 0 
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
map f <Plug>(easymotion-fl)
map F <Plug>(easymotion-Fl)
map t <Plug>(easymotion-tl)
map T <Plug>(easymotion-Tl)
map <leader>f <Plug>(easymotion-f2)

"-----------------------------------------
" CtrlP/CtrlPFunky
"-----------------------------------------
" Cache dir
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" Use ag (faster ack) for searching files
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" CtrlP Sets the current working path to a .git path
let g:ctrlp_working_path_mode = 'ra'
" Methods in file
nnoremap <A-p> :execute 'CtrlPFunky'<CR>
" Previous files
nnoremap <leader>b :CtrlPMRU<cr>
" Ignore
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|pyc|patch)$',
    \ 'link': 'some_bad_symbolic_links',
    \ }
"-----------------------------------------
" YouCompleteMe
"-----------------------------------------
" YCM shows completions opts in the preview window
let g:ycm_add_preview_to_completeopt = 1
" YCM closes preview window on esc
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
" Collection of GoToDef for plugins
"-----------------------------------------
autocmd FileType typescript map <buffer><F2> :TSSdefpreview<CR>
autocmd FileType typescript map <buffer><F3> :TSSdef<CR>
autocmd FileType python map <buffer><F2> <CR>
autocmd FileType python map <buffer><F3> :YcmCompleter GoToDefinition<CR>
" Eclim scalasearch
autocmd FileType scala map <buffer> <F3> :ScalaSearch<cr>
" Ycm Erlang completion shouldn't close on typing
autocmd FileType erlang let g:ycm_cache_omnifunc = 0
autocmd FileType c,cpp,java,php,ruby,python,javascript,typescript let g:ycm_cache_omnifunc = 1
"-----------------------------------------
" UltiSnips
"-----------------------------------------
fu! Return_Or_Snippet()
  if pumvisible()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res
      return ""
    endif
  endif
  return "\<cr>"
endfunction

inoremap <return> <C-R>=Return_Or_Snippet()<cr>

let g:UltiSnipsJumpForwardTrigger  = "<leader>w"
let g:UltiSnipsJumpBackwardTrigger = "<leader>q"
"-----------------------------------------
"GitGutter
"-----------------------------------------
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

" Pylint syntastic
let g:syntastic_python_pylint_args='-E -d C0301,C0111,C0103,R0903,W0614,W0611,E1601'
"Typescript syntastic
let g:syntastic_typescript_tsc_args = '--module commonjs --target ES5'

"-----------------------------------------
" VimAirline
"-----------------------------------------
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show the filename or parent/filename if filename is same
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
"-----------------------------------------
" Autopairs
"-----------------------------------------
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}
let g:AutoPairsFlyMode = 1
"-----------------------------------------
" NERDCommenter
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
" NERDTree
"-----------------------------------------
let NERDTreeIgnore = ['\.pyc$', '\.db$']
noremap <F5> :NERDTreeToggle<CR>
" Strip trailing whitespace
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

