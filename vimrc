"-----------------------------------------
" Vim Plug
"-----------------------------------------
set nocompatible
call plug#begin('~/.vim/plugged')
"-----------------------------------------
" General plugins
"-----------------------------------------
Plug 'Valloric/YouCompleteMe'
Plug 'kien/ctrlp.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'benekastah/neomake'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
Plug 'Lokaltog/vim-easymotion'
Plug 'SirVer/ultisnips'
Plug 'dani-h/vim-dsnippets'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/MatchTagAlways'
Plug 'ap/vim-css-color'
"-----------------------------------------
" Lang specific
"-----------------------------------------
Plug 'davidhalter/jedi-vim' "Python
Plug 'derekwyatt/vim-scala'
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'marijnh/tern_for_vim', {'do': 'npm install'} "Javascript
Plug 'dani-h/typescript-vim' " Typescript Syntax
Plug 'kchmck/vim-coffee-script'
Plug 'clausreinke/typescript-tools.vim' "Typescript Autocomplete
Plug 'fatih/vim-go'
Plug 'zah/nim.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
"-----------------------------------------
call plug#end()
"-----------------------------------------
" General settings
"-----------------------------------------
" Silences C-Q, C-S and allows vim to catch them
silent !stty -ixon > /dev/null 2>/dev/null
" Sets the title of the terminal window
set title
" Line number
set number
" Relative line numbers for faster movement
set relativenumber
" Disables the bottom bar which shows modes and allows plugins (tern - types) to display information
" See https://github.com/marijnh/tern_for_vim/blob/master/doc/tern.txt#L135
" This only displays in insert and visual mode and is useless anyway because Airline displays the
" same information
set noshowmode
" Set pwd to current file
set autochdir
" Can switch buffers without saving
set hidden
" Seems like backspace doesn't work for nvim and source compiled new vim versions
set backspace=indent,eol,start
" Paste mode to paste properly. Is this required?
set pastetoggle=<F9>
" timeout in ms for key mappings interval
set timeoutlen=500
" Not sure what this does but it will cause Tagbar to show the prototype (bottom) after 50ms when hovering a tag
set updatetime=50
" Specify location of tags file
" 'The last semicolon is the key here. When Vim tries to locate the 'tags' file, it first looks at the current
" directory, then the parent directory, then the parent of the parent, and so on'
set tags=./tags;
"-----------------------------------------
" User defined commands
"-----------------------------------------
" Resize vertically easier. `res` is built in, `vres` is not
command! -nargs=? Vres vertical resize <args>
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
" Copy til end of line (default is entire line - use `Y` for that)
nnoremap Y y$
" Movement
nnoremap q b
vnoremap q b
" Move to next screen (vim) line instead of file line. Useful for long lines that span over two vim lines
nnoremap j gj
nnoremap k gk
" Don't map this to tab since it blocks the jumplist. There is no way to remap <C-i> or <tab>
" programatically
" seems
nnoremap <space> %
vnoremap <space> %
" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv
" ctrl-backspace to delete the previous word
inoremap <C-BS> <C-W>
" map ctrl+del to delete next work
inoremap <C-Del> <C-O>dw
"Window movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Default mapping for switching
nnoremap <M-n> :call Switch_buffer("left")<cr>
nnoremap <M-m> :call Switch_buffer("right")<cr>
"Create a new buffer
noremap <C-t> :enew<CR>
if has("gui_running")
  " Firefox like tab switching
  noremap <C-S-tab> :call Switch_buffer("left")()<cr>
  noremap <C-tab> :call Switch_buffer("right")()<cr>
endif
" Close buffer without closing window
" See http://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window
"nnoremap <C-w> :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <C-w> :call DeleteBufferVisitPrevious()<CR>
nnoremap <leader>cp :call CopyBuffer()<CR>
" Unlike bd, this function will visit the previous buffer in the list (as seen in on the tab order).
" The drawback of bd is that it will simply visit the last edited buffer.
function! DeleteBufferVisitPrevious()
  if Switch_buffer("left") == 1
    let prevBufName = bufname("#")
    execute "bd!" prevBufName
  endif
endfunction
"-----------------------------------------
" Color scheme settings
"-----------------------------------------
"Make sure to place color schemes after the vundle runtime has been declared
syntax enable
colorscheme badwolf "Monokai
set guifont=Monaco
filetype plugin indent on
"-----------------------------------------
" Search
"-----------------------------------------
" Highlight search
set hlsearch
" Blink the current word when switching search words
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>
" Clear highlight with enter
nnoremap <esc><esc> :noh<cr><esc>
" Search selected text, not only words as with `*`
vnoremap // y/<C-R>"<CR>
" Show search while typing
set incsearch
" Ignore case
set wildignorecase
" Smart search. If uppercase chars search case sensitive.
set ignorecase smartcase
" Highlight the current line under the cursor
set cursorline
" Resets search
autocmd InsertEnter * set cursorline
" Color of search highlight
" Note, this has to go AFTER the skin settings
highlight Search ctermfg=30 ctermbg=black
highlight Search guifg=red guibg=black
highlight SearchFlash guibg=red ctermfg=yellow ctermbg=black
"-----------------------------------------
" Text width settings
"-----------------------------------------
set textwidth=100
set colorcolumn=100
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType gitcommit setlocal colorcolumn=72
" Wrapping can start 5 chars from right margin
set wrapmargin=5
"-----------------------------------------
" Indentation settings
" See http://tedlogan.com/techblog3.html
"-----------------------------------------
" `nocindent smartindent` will allow us to omit semicolons and jump to the next line without auto indentation
" for Javascript/Typescript
autocmd FileType typescript,javascript  setlocal  shiftwidth=2 tabstop=2 expandtab nocindent smartindent
autocmd FileType coffee                 setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType css,scss,stylus        setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType vim                    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType tex                    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType json                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType snippets               setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType jade                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType html,htmldjango        setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType python                 setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType go                     setlocal  shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType erlang                 setlocal  shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType make                   setlocal  shiftwidth=4 tabstop=4 noexpandtab
autocmd FileType sh                     setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType php                    setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType markdown               setlocal  shiftwidth=4 tabstop=4 expandtab
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
map s <Plug>(easymotion-sn)
"-----------------------------------------
" CtrlP/CtrlPFunky
"-----------------------------------------
" Cache dir
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
" Use ag (faster ack) for searching files
"if executable('ag')
"let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
"endif
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:25'
" CtrlP Sets the current working path to a .git path
let g:ctrlp_working_path_mode = 'ra'
" `line`        search line
" `tag`         search for tag in file
" `buffertag`   search for tags in buffers, requires ctags
" `dir`         search for directory and jump to it
" `changes`     search recent changes
let g:ctrlp_extensions = ['tag', 'line', 'dir']
" CtrlPFunky key
nnoremap <leader>f :execute 'CtrlPFunky'<CR>
" Previous files
nnoremap <leader>b :CtrlPMRU<cr>
" Ignore, note does not work if a custom `ctrlp_user_command` is used, i.e `ag`
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.?(git|hg|svn|node_modules)$',
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

let g:ycm_complete_in_comments = 1

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
let g:tern_show_argument_hints = 'on_move'
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
" Golang
"-----------------------------------------
autocmd FileType go map <buffer><F3> <Plug>(go-def)
autocmd FileType go map <buffer><leader><F3> <Plug>(go-def-split)
autocmd FileType go map <buffer><F4> <Plug>(go-doc)
" Show the type info at the bottom bar when hovering over word
let g:go_auto_type_info = 1
"-----------------------------------------
" Tagbar
"-----------------------------------------
if exists("*GitBranchInfoString")
  " On startup start tagbar for supported files
  autocmd VimEnter * nested :call tagbar#autoopen(1)
  " When opening a buffer with a supported filetype, open tagbar
  autocmd FileType * nested :call tagbar#autoopen(0)
endif
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
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/plugged/vim-dsnippets']
"-----------------------------------------
" GitGutter
"-----------------------------------------
hi SignColumn guibg=black ctermbg=black
"-----------------------------------------
" Neomake
"-----------------------------------------
" Normal neomake for these. Doesn't work for some others (go)
autocmd BufWritePost *.py,*.js,*.ts Neomake
" Seems like neomake only builds one file using `:Neomake` so imports are ignored, `Neomake!` works
" but builds an executable which can be annoying. Use `:GoLint` from the `vim-go` package instead.
autocmd BufWritePost *.go Neomake!
" The value 2 means that we'll open the bottom tab, but keep the cursor position
let g:neomake_open_list = 2

" Avoid specifying all maker options here due to conflicts. Instead use conf files
let g:neomake_typescript_tsc_maker = {
      \ 'args': [
      \ '--module', 'commonjs', '--noEmit', '--target', 'ES5'
      \ ],
      \ 'errorformat':
      \ '%E%f %#(%l\,%c): error %m,' .
      \ '%E%f %#(%l\,%c): %m,' .
      \ '%Eerror %m,' .
      \ '%C%\s%\+%m'
      \ }

let g:neomake_go_enabled_makers = []

"-----------------------------------------
" VimAirline
"-----------------------------------------
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
" Airline extension Tabline
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '▶'

let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#show_tab_type = 1

" Show the filename or parent/filename if filename is same
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'

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


"-----------------------------------------
" Auto-pairs
"-----------------------------------------
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}
" Don't jump to the next bracket when closing
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0
" Shortcut to quickly wrap a world, i.e ''hello + key => 'hello'
let g:AutoPairsShortcutFastWrap = "<leader>r"
" Jump to next closed pair
let g:AutoPairsShortcutJump = "<leader>n"
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
" Open nerdtree
" Open nerdtree on start
autocmd vimenter * NERDTree
" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction
"-----------------------------------------
" vim-markdown-preview
"-----------------------------------------
" Use github flavored markdown, requires a connection
let vim_markdown_preview_github=1
" Dont display images and preview on key
let vim_markdown_preview_toggle=0
let vim_markdown_preview_hotkey='<leader>pr'
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
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

fun! CopyBuffer()
  let l = line(".")
  let c = col(".")
  execute "normal ggVG\"+y"
  call cursor(l, c)
endfun

" This function does two things:
" 1) Do not switch window if you're on a NERDTree window
" 2) If you switch to a quickfix/location list window, just skip that one. Can't be called
" recursively
" If switch is successful return 1 else 0
fu! Switch_buffer(direction)
  if a:direction == "left"
    let cmdDirection = "bprev"
  elseif a:direction == "right"
    let cmdDirection = "bnext"
  endif

  if bufname("%") =~#"^NERD_tree_[0-9]"
    echo "I won't switch buffers in a NERDTree window"
    return 0
  else
    execute cmdDirection
    if &filetype == 'qf'
      execute cmdDirection
    endif
    return 1
  endif
endfu

" Highlights the current search word as soon as you switch words
"https://www.youtube.com/watch?v=aHm36-na4-4
fu! HLNext (blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#'.@/
  let ring = matchadd('SearchFlash', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" See http://stackoverflow.com/a/6271254
function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction
