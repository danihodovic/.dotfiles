"-----------------------------------------
" Vim Plug
"-----------------------------------------
set nocompatible
call plug#begin('$NVIM_DIR/plugged')
"-----------------------------------------
" General plugins
"-----------------------------------------
Plug 'Valloric/YouCompleteMe'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Sets root directory to project (git) directory by default
Plug 'airblade/vim-rooter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mhinz/vim-startify'
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons'
" Run linters or makefiles
Plug 'benekastah/neomake'
" Show git diffs
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
" Generates tmuxline configs. This doesn't have to be used unless you want to switch
" tmuxline skins on the line or integrate them with vim.
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'SirVer/ultisnips'
Plug 'dani-h/vim-dsnippets'
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
" Switch tabs between vim and tmux
Plug 'christoomey/vim-tmux-navigator'
" Sets active window focus
Plug 'blueyed/vim-diminactive'
" Enable focus events inside nvim so that FocusGained and FocusLost autocmds work in terminal vim
" vim-fugitive plugin uses FocusGained for refreshing git branch in status line
" vim-gitgutter uses FocusGained for refreshing ... (wait for it) git gutter
Plug 'tmux-plugins/vim-tmux-focus-events'
" Required by vim-oblique
Plug 'junegunn/vim-pseudocl'
" Improved / search for vim which allows z/ to be fuzzy
Plug 'junegunn/vim-oblique'
" Aligns text
Plug 'junegunn/vim-easy-align'
" Focuses text
Plug 'junegunn/limelight.vim'
"-----------------------------------------
" Lang specific
"-----------------------------------------
" JS/TS/CS
" JS syntax
Plug 'othree/yajs.vim'
Plug 'ruanyl/vim-fixmyjs'
" Tern require npm install in the vim repo
Plug 'marijnh/tern_for_vim'
Plug 'dani-h/typescript-vim' " Typescript Syntax
Plug 'clausreinke/typescript-tools.vim' "Typescript Autocomplete
Plug 'kchmck/vim-coffee-script'
Plug 'davidhalter/jedi-vim' "Python
Plug 'derekwyatt/vim-scala'
Plug 'vim-erlang/vim-erlang-omnicomplete'
" Show matching html/xml tags
Plug 'Valloric/MatchTagAlways'
Plug 'fatih/vim-go'
Plug 'zah/nim.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'rust-lang/rust.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
" Show hex codes in css files
Plug 'ap/vim-css-color'
"-----------------------------------------
call plug#end()

"-----------------------------------------
" General settings
"-----------------------------------------
" Silences C-Q, C-S and allows vim to catch them
silent !stty -ixon > /dev/null 2>/dev/null
" All y/p operations use clipboard by default
set clipboard=unnamedplus
" Enable spelling
" set spell spelllang=en_us
" Sets the title of the terminal window
set title
" Line number
set number
" Relative line numbers for faster movement
set norelativenumber
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
" Triggers the CursorHold autocmd event and writes the swap file to disk. CursorHold is only
" triggered in normal mode once every time the user presses a key and it times out. Default 4000.
" Causes ternJS to show the signature at bottom after x ms, same goes for Tagbar
set updatetime=1000
" Check for file changes every time CursorHold is triggered.
au CursorHold * checktime
" If files have not been changed when :checktime is ran, reload the files automatically without
" asking for permission
set autoread
" Specify location of tags file
" 'The last semicolon is the key here. When Vim tries to locate the 'tags' file, it first looks at the current
" directory, then the parent directory, then the parent of the parent, and so on'
set tags=./tags;
" This needs to be set for devicons to work
set encoding=utf8
"-----------------------------------------
" User defined commands
"-----------------------------------------
" Resize vertically easier. `res` is built in, `vr` is not
command! -nargs=? Vr vertical resize <args>
command! -nargs=? Hr resize <args>
"-----------------------------------------
" General remappings
"-----------------------------------------
"TODO: Add remappings for vim command mode and insert mode for moving around and
"deleting previous/next.
let mapleader = ","
noremap <leader>q q
" Copy til end of line (default is entire line - use `Y` for entire line instead)
nnoremap Y yg_
" Movement
noremap q b
" Movement begin/end of line
noremap Q ^
noremap W g_
noremap $ <nop>
noremap ^ <nop>
" Move to next screen (vim) line instead of file line. Useful for long lines that span over two vim lines
noremap j gj
noremap j gj
noremap k gk
noremap k gk
" Easier semicolon insertion
autocmd FileType javascript,typescript,css noremap ;; :call InsertSemicolons()<CR>
" Don't map this to tab since it blocks the jumplist. There is no way to remap <C-i> or <tab>
" programatically it seems
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
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap + :vertical resize +15<cr>
nnoremap - :vertical resize -15<cr>
" Buffer operations similar to browsers
noremap <C-t> :enew<CR>
nnoremap <C-w> :call DeleteBufferVisitPrevious()<CR>
" Text width formatting for small blocks
nnoremap <leader>fo :call ReformatTextWidth()<cr>
vnoremap <leader>fo :call ReformatTextWidth()<cr>

nnoremap <leader>bc :call CopyBuffer()<CR>
" Blink the current word when switching search words
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>
" Clear highlight with enter
nnoremap <esc><esc> :noh<cr><esc>
" TODO: oblique disables search for some reason. Figure out why
" nnoremap / <Plug>(Oblique-F/)
" Search selected text, not only words as with `*`
vnoremap // y/<C-R>"<CR>
" Close buffer without closing window
" See http://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window
if has("nvim")
  " Mapping for nvim-qt to paste into command line
  cmap <S-Insert>  <C-R>+
  nmap <S-Insert>  <C-R>+
  " Fix this until the nvim-qt guy fixes proper guifont options
  command! -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
  let g:Guifont="Monaco:h10"
endif
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
highlight Search ctermfg=45 ctermbg=black
highlight Search guifg=red guibg=black
highlight SearchFlash guibg=red ctermfg=132 ctermbg=16
"-----------------------------------------
" Text width settings
"-----------------------------------------
set textwidth=100
set colorcolumn=100
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType gitcommit setlocal colorcolumn=72
" Sets the colorcolumn only in active windows
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END
" Wrapping can start 5 chars from right margin
set wrapmargin=5
"-----------------------------------------
" Indentation settings
" See http://tedlogan.com/techblog3.html
" softtabstop - number of spaces in tab character
" tabstop - number of visual spaces in a tab
" expandtab - tabs become spaces
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
autocmd FileType sh,bash,zsh            setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType php                    setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType markdown               setlocal  shiftwidth=4 tabstop=4 expandtab
"-----------------------------------------
" Plugin specific settings
"-----------------------------------------
" fzf.vim
"-----------------------------------------
let g:fzf_layout = {'up': '~40%'}
nnoremap = :Files<cr>
nnoremap b :Buffers<cr>
nnoremap <C-h> :History:<cr>
nnoremap <leader>mr :History<cr>
" Remap below isn't really fzf related, it simply switches to the last buffer with vanilla vim
nnoremap <M-`> :buffer #<cr>

nnoremap <leader>t :call FzfTagsCustom('n')<cr>
vnoremap <leader>t :call FzfTagsCustom(visualmode())<cr>
fu! FzfTagsCustom(mode)
  if a:mode ==# 'n'
    execute "Tags"
  elseif a:mode ==# 'v'
    let selectedText = shellescape(Get_visual_selection())
    let opts = '-q ' . selectedText
    call fzf#vim#tags({'options': opts, 'up': '~40%'})
  endif
endfu


command! -bang -nargs=* AG call FzfAgCustom(<q-args>)
noremap <leader>a :call FzfAgCustom('', 'n')<cr>
" Use visualmode() to differentiate "v", "V" and "<CTRL-V>"
vnoremap <leader>a :call FzfAgCustom('', visualmode())<cr>

fu! FzfAgCustom(queryparam, ...)
  if len(a:queryparam) > 0
    let query = a:queryparam
  elseif a:0 > 0
    let mode = a:1
    if mode ==# 'n'
      let query = escape('^(?=.)', '"\-')
    elseif mode ==# 'v'
      let query = escape(Get_visual_selection(), '"\-')
    endif
  else
    let query = ''
  endif

  let ag_opts = 'ag --nogroup --column --color -t "%s"'
  let source = printf(ag_opts, query)
  call fzf#vim#ag(query, {'options': '-e', 'source': source, 'up': '~40%'})
endfu

nnoremap <leader>gs :call FzfGitStatus()<cr>
vnoremap <leader>gs :call FzfGitStatus()<cr>
" Using the custom fzf#run see https://github.com/junegunn/fzf#fzfrunoptions
fu! FzfGitStatus()
  let source = 'git diff --name-only'
  let opts = {
        \ 'source': source,
        \ 'options': '--prompt "Git changed files>" --ansi',
        \ 'sink': 'e',
        \ 'dir': '.',
        \ 'up': '40%' }
  call fzf#run(opts)
endfu
"-----------------------------------------
" vim-oblique
"-----------------------------------------
let g:oblique#incsearch_highlight_all=1
"-----------------------------------------
" vim-indent-guides
"-----------------------------------------
" define our own colors instead of the plugin defining it for us
let g:indent_guides_auto_colors = 0
"ctermbg 234 = darkgrey, ctermbg 235 = lightgrey
autocmd VimEnter * IndentGuidesEnable
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
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
" EasyAlign
"-----------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
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
autocmd FileType javascript map <buffer><F2> :TernType<cr>
autocmd FileType javascript map <buffer><F3> :TernDef<cr>
autocmd FileType javascript map <buffer><F4> :TernDefPreview<cr>
autocmd FileType javascript map <buffer><leader><F3> :TernRefs<cr>
" 'no', 'on_move', 'on_hold' - Note: on_move will cause major lag when moving!
let g:tern_show_argument_hints = 'no'
" Shows args in completion menu
let g:tern_show_signature_in_pum = 1
"-----------------------------------------
" FixMyJS
"-----------------------------------------
" Eslint or fixmyjs (JSHint). It uses your defined JSHint settings to fix what it can
let g:fixmyjs_engine = 'fixmyjs'
" Legacy needed for es6 for some reason
let g:fixmyjs_legacy_jshint = 1
"autocmd BufWritePre *.js,*.ts Fixmyjs
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
" Fix so that snippets show up in the completion menu, see
" https://github.com/Valloric/YouCompleteMe/issues/1214
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsJumpForwardTrigger  = "<leader>w"
let g:UltiSnipsJumpBackwardTrigger = "<leader>q"
" Load my own snippets
let g:UltiSnipsSnippetDirectories=[$NVIM_DIR.'/plugged/vim-dsnippets']
"-----------------------------------------
" GitGutter
"-----------------------------------------
let g:gitgutter_max_signs=9999
hi SignColumn guibg=black ctermbg=black
nnoremap ggn :GitGutterNextHunk<cr>
nnoremap ggp :GitGutterPrevHunk<cr>
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
" AutoFormat
"-----------------------------------------
let g:autoformat_javascript_typescript = 1
" autocmd BufwritePre *.js,*.ts Autoformat
"-----------------------------------------
" VimAirline
"-----------------------------------------
" This needs to be enabled for airline to use powerline fonts
let g:airline_powerline_fonts = 1
" - Airline options
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
" - Airline built in extensions
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#quickfix#location_text = 'Location'
"
" - Airline external extensions
" Most extensions are enabled by default and lazily loaded when the
" corresponding plugin (if any) is detected.
" an empty list disables all extensions
" let g:airline_extensions = []
" " or only load what you want
" let g:airline_extensions = ['branch', 'tabline']
"
" These are all enabled by default if the respective plugins are loaded.
" Let's be declarative here and show what plugins we want to use instead
" of looking at the docs.

 " - Airline tabline
" We want to enable the tabline because vim's built in tabline behaves strangely
" and needs to be configured. Using tabline solves this out of the box.
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '▶'
let g:airline#extensions#tabline#show_buffers = 1
" Show the filename or parent/filename if filename is same
let g:airline#extensions#tabline#formatter = 'unique_tail'

" - Git branch (fugitive)
let g:airline#extensions#branch#enabled = 1
" - Git hunks.
let g:airline#extensions#hunks#enabled = 1
" - Tmuxline
let g:airline#extensions#tmuxline#enabled = 0

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
" Disable this
let g:AutoPairsShortcutToggle = ''
"-----------------------------------------
" NERDCommenter
"-----------------------------------------
nnoremap <leader>c :call NERDComment(0, "toggle")<CR>
vnoremap <leader>c :call NERDComment(0, "toggle")<CR>
" Add a space before any comment
let g:NERDSpaceDelims = 1
"-----------------------------------------
" NERDTree
"-----------------------------------------
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '\.db$']
noremap <F5> :NERDTreeToggle<CR>
" Open nerdtree on start
"autocmd vimenter * NERDTree
" Open NERDTree on enter and use the non-nerdtree window
" Go to previous (last accessed) window.
"autocmd VimEnter * wincmd p
" When exiting: Close nerdtree if its the only window left
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
  let ring = matchadd('SearchFlash', target_pat, 104)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 800) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" Unlike bd, this function will visit the previous buffer in the list (as seen in on the tab order).
" The drawback of bd is that it will simply visit the last edited buffer.
function! DeleteBufferVisitPrevious()
  if Switch_buffer("left") == 1
    let prevBufName = bufname("#")
    execute "bd!" prevBufName
  endif
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

fu! InsertSemicolons()
  let currentmode = mode()
  let l = line(".")
  let c = col(".")
  let currLine = getline('.')
  " If we are in normal mode and the last character is not ;
  " This for some reason works for visual line mode too. Select multiple and it inserts on all
  " despite the normal mode check
  " Note: vim has weird regexes. you need to escape '\|' and not '('. See `:h \v`
  " Currline is not ( or { or ; or not empty
  if currentmode == 'n' && currLine !~ '\v(\(|\{|;)\s*$' && currLine !~ '^$'
    execute "normal! A;\<esc>"
    call cursor(l, c)
  endif
endfu!

" Prompt the user for width and reformat the text to specific width before
" restoring textwidth.  Works for visual mode.  Useful for reformatting comments
fu! ReformatTextWidth() range
  " For some reason inputsave() and inputrestore() have to be called between getting input
  call inputsave()
  let currWidth = &textwidth
  let width = input('Enter textwidth>')
  let &textwidth = width
  " Calling gvgq won't work because in normal mode it would
  " get the last visual selection which we don't want
  normal v
  execute "normal " . a:firstline . "gg"
  execute "normal " . a:lastline . "gg"
  normal gq
  let &textwidth = currWidth
  call inputrestore()
endfu!
