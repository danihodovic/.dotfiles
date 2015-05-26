"-----------------------------------------
" Vim Plug
"-----------------------------------------
set nocompatible
call plug#begin('~/.vim/plugged')
"-----------------------------------------
" General plugins
"-----------------------------------------
" Don't automatically compile the YCM engine...
Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
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
Plug 'davidhalter/jedi-vim'
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'dani-h/typescript-vim'
Plug 'clausreinke/typescript-tools.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'marijnh/tern_for_vim', {'do': 'npm install'}
"-----------------------------------------
call plug#end()
"-----------------------------------------
" General settings
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
" 200ms for key mappings interval
set timeoutlen=500
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
nnoremap <C-a>h <C-w>h
nnoremap <C-a>j <C-w>j
nnoremap <C-a>k <C-w>k
nnoremap <C-a>l <C-w>l
" Clear highlight with enter
nnoremap <esc><esc> :noh<cr><esc>

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
set relativenumber
"-----------------------------------------
" Indentation settings
"-----------------------------------------
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
autocmd FileType typescript,javascript,css,scss,vim,tex setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType html,htmldjango,erlang,sh,make,php,snippets setlocal expandtab shiftwidth=4 tabstop=4
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
map <leader>s <Plug>(easymotion-sn)

"-----------------------------------------
" CtrlP/CtrlPFunky
"-----------------------------------------
" Cache dir
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" Use ag (faster ack) for searching files
"if executable('ag')
  "let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"endif
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:15,results:15'
" CtrlP Sets the current working path to a .git path
let g:ctrlp_working_path_mode = 'ra'
" CtrlPFunky key
nnoremap <leader>f :execute 'CtrlPFunky'<CR>
" Previous files
nnoremap <leader>b :CtrlPMRU<cr>
" Ignore, not does not work with `ag`
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|pyc|patch)$',
    \ 'link': 'some_bad_symbolic_links',
    \ }
"-----------------------------------------
" YouCompleteMe
"-----------------------------------------
let g:ycm_filetype_blacklist = {'notes': 1, 'markdown': 0, 'unite': 1, 'tagbar': 1, 
      \'pandoc': 1, 'qf': 1, 'vimwiki': 1, 'text': 0, 'infolog': 1, 'mail': 1}
" Opts: menu, menuone, longest, preview
" Avoid preview to use completion  engine lookups, otherwise it tends to lag.
" Avoid longest as it disables you from typing
set completeopt=menuone
" YCM shows completions opts in the preview window
let g:ycm_add_preview_to_completeopt = 0
" YCM closes preview window on esc
let g:ycm_autoclose_preview_window_after_insertion = 1

" Ycm Erlang hack: completion shouldn't close on typing
autocmd FileType erlang let g:ycm_cache_omnifunc = 0
autocmd FileType c,cpp,java,php,ruby,python,javascript,typescript let g:ycm_cache_omnifunc = 1

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
" Collection of GoToDef, Completion, Lang support for plugins
"-----------------------------------------
" Typescript
"-----------------------------------------
autocmd FileType typescript map <buffer><F2> :TSSdefpreview<CR>
autocmd FileType typescript map <buffer><F3> :TSSdef<CR>
"-----------------------------------------
" Python
"-----------------------------------------
autocmd FileType python map <buffer><F2> <CR>
autocmd FileType python map <buffer><F3> :YcmCompleter GoToDefinition<CR>
" Eclim Java, Scala
autocmd FileType scala map <buffer> <F3> :ScalaSearch<cr>
let g:EclimCompletionMethod = 'omnifunc'
"-----------------------------------------
" TernJS
"-----------------------------------------
autocmd FileType javascript map <buffer><F3> :TernDef<cr>
autocmd FileType javascript map <buffer><leader><F3> :TernRefs<cr>
" 'no', 'on_move', 'on_hold'
let g:tern_show_argument_hints = 'no'
" Shows args in completion menu
let g:tern_show_signature_in_pum = 1
"-----------------------------------------
" Jedi Python
"-----------------------------------------
let g:jedi#use_tabs_not_buffers = 0
" Do not select the first popup option and complete it
let g:jedi#popup_select_first = 0
" Autocomplete the function params
let g:jedi#show_call_signatures = "1"
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
let g:UltiSnipsJumpForwardTrigger  = "ww"
let g:UltiSnipsJumpBackwardTrigger = "qq"
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

" Pylint
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args='-E -d C0301,C0111,C0103,R0903,W0614,W0611,E1601'
"Typescript 
let g:syntastic_typescript_tsc_args = '--module commonjs --target ES5'
" Javascript
let g:syntastic_javascript_checkers = ['jshint']

"-----------------------------------------
" VimAirline
"-----------------------------------------
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 1

let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" Show the filename or parent/filename if filename is same
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
"-----------------------------------------
" Autopairs
"-----------------------------------------
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}
" Don't jump to the next bracket when closing
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0

let g:AutoPairsShortcutFastWrap = "<leader>k"
"-----------------------------------------
" NERDCommenter
"-----------------------------------------
nnoremap <leader>c :call NERDComment(0, "toggle")<CR>
vnoremap <leader>c :call NERDComment(0, "toggle")<CR>
"-----------------------------------------
" NERDTree
"-----------------------------------------
let NERDTreeIgnore = ['\.pyc$', '\.db$']
noremap <F5> :NERDTreeToggle<CR>
"-----------------------------------------
" Random funcs
"-----------------------------------------
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
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

