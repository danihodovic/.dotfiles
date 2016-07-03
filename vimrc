" TODO: Add ag search within git files. Not node_modules
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
Plug 'danihodovic/fzf.vim'
" Sets root directory to project (git) directory by default
Plug 'airblade/vim-rooter'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons'
" Run linters or makefiles
Plug 'benekastah/neomake'
Plug 'majutsushi/tagbar'
" Show git diffs
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'Chiel92/vim-autoformat'
Plug 'terryma/vim-multiple-cursors'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Generates tmuxline configs. This doesn't have to be used unless you want to switch
" tmuxline skins on the line or integrate them with vim.
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'SirVer/ultisnips'
Plug 'dani-h/vim-dsnippets'
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tmhedberg/matchit'
" Sets active window focus
" Plug 'blueyed/vim-diminactive'
" Required by vim-oblique
Plug 'junegunn/vim-pseudocl'
" Colors current search result differently and sets nohlsearch on cursor move
Plug 'junegunn/vim-oblique'
" Aligns text
Plug 'junegunn/vim-easy-align'
Plug 'itchyny/vim-cursorword'
Plug 'kana/vim-textobj-user'                          " Add additional text objects
Plug 'kana/vim-textobj-function'                      " Add function based text objects
Plug 'thinca/vim-textobj-function-javascript'         " Add JS function object
Plug 'FooSoft/vim-argwrap'
Plug 'sunaku/vim-dasht'
"-----------------------------------------
" Lang specific
"-----------------------------------------
Plug 'danihodovic/vim-node-require', {'branch': 'dev'}
Plug 'xolox/vim-misc'
Plug 'xolox/vim-lua-ftplugin'
" JS/TS/CS
" JS syntax
Plug 'othree/yajs.vim'
Plug 'ruanyl/vim-fixmyjs'
" Tern requires npm install in the repo to work. Don't install the default version in npm, it's
" slow. Instead install the latest master. Save that dependency so that the update doesn't revert
" backwards by using npm.
Plug 'marijnh/tern_for_vim'
Plug 'dani-h/typescript-vim' " Typescript Syntax
Plug 'clausreinke/typescript-tools.vim' "Typescript Autocomplete
Plug 'kchmck/vim-coffee-script'
Plug 'davidhalter/jedi-vim'
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
Plug 'tpope/vim-endwise'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'sudar/vim-arduino-syntax'
Plug 'cespare/vim-toml'
" Plug 'kana/vim-textobj-function'
" Plug 'thinca/vim-textobj-function-javascript'
"-----------------------------------------
call plug#end()

"-----------------------------------------
" General settings
"-----------------------------------------
" Cursor shape betwen block and ibeam. Does not work for lxterminal, xfce4-terminal
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" Silences C-Q, C-S and allows vim to catch them
silent !stty -ixon > /dev/null 2>/dev/null
" All y/p operations use clipboard by default
set clipboard=unnamedplus
set nobackup
set nowritebackup
set noswapfile
set nofoldenable
" Enable spelling
set spell
set title
set number
" Dont auto resize windows (good for i3)
set winfixwidth
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
" Dont treat _ like a keyword so_that_this_is_six_words
set iskeyword-=_
" Paste mode to paste properly. Is this required?
set pastetoggle=<F9>
" timeout in ms for key mappings interval
set timeoutlen=500
" Triggers the CursorHold autocmd event and writes the swap file to disk. CursorHold is only
" triggered in normal mode once every time the user presses a key and it times out. Default 4000.
" Causes ternJS to show the signature at bottom after x ms, same goes for Tagbar
set updatetime=1000
" Check for file changes every time CursorHold is triggered.
" Executing this in a command line window causes an error
au CursorHold * if expand("%") != "[Command Line]" | checktime
" If files have not been changed when :checktime is ran, reload the files automatically without
" asking for permission
set autoread
" Specify location of tags file
" 'The last semicolon is the key here. When Vim tries to locate the 'tags' file, it first looks at the current
" directory, then the parent directory, then the parent of the parent, and so on'
set tags=./tags;
set diffopt=filler,vertical
"-----------------------------------------
" User defined commands
"-----------------------------------------
" Resize vertically easier. `res` is built in, `vr` is not
command! -nargs=? Vr vertical resize <args>
command! -nargs=? Hr resize <args>
command! Fp echo expand('%:p')
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
nnoremap : <nop>
execute "nnoremap <space> :" . &cedit . "a"
execute "xnoremap <space> :" . &cedit . "a"
execute "nnoremap / /" . &cedit . "a"
execute "xnoremap / /" . &cedit . "a"
execute "nnoremap ? ?" . &cedit . "a"
execute "xnoremap ? ?" . &cedit . "a"
autocmd CmdwinEnter * nnoremap <buffer> <esc> :q<cr>
set cmdwinheight=1
" Move up and down in command-line mode
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
" Easier semicolon insertion
autocmd FileType javascript,typescript,css,perl,nginx noremap ;; :call InsertSemicolons()<CR>
nmap m %
vmap m %
" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv
" ctrl-backspace to delete the previous word
inoremap <C-BS> <C-W>
" map ctrl+del to delete next work
inoremap <C-Del> <C-O>dw
" Delete previous and next word in insert mode.  TODO: Figure out if you need
" this and enable it for zshrc too.
inoremap <M-q> <esc>lcb
" Delete next word. We need a conditional mapping becuase <esc> moves the
" character left if we are not on the beginning of a line. If we are on the
" beginning of a line it has nowhere to move.
inoremap <expr> <M-w> col('.') == 1 ? '<esc>cw' : '<esc>lcw'
" Switch to last buffer or other buffer if last was deleted
" TODO: Unused
fu! SwitchLast()
  if buflisted(bufnr('#'))
    buf #
  else
    bnext
  endif
endfu

"Window movement
inoremap <silent> <F12>h <esc>:call I3VIM_WindowFocus('h')<cr>
inoremap <silent> <F12>l <esc>:call I3VIM_WindowFocus('l')<cr>
inoremap <silent> <F12>j <esc>:call I3VIM_WindowFocus('j')<cr>
inoremap <silent> <F12>k <esc>:call I3VIM_WindowFocus('k')<cr>

noremap <silent> <F12>h :call I3VIM_WindowFocus('h')<cr>
noremap <silent> <F12>l :call I3VIM_WindowFocus('l')<cr>
noremap <silent> <F12>j :call I3VIM_WindowFocus('j')<cr>
noremap <silent> <F12>k :call I3VIM_WindowFocus('k')<cr>

func! I3VIM_WindowFocus(direction)
  " wincmd is not available in cmd mode, so we have to work around it
  if bufname('') == '[Command Line]'
    " Note: Stupid viml vimscript interpret '' and "" in feedkeys() differently!
    call feedkeys("\<esc>")
    return
  endif

  let oldw = winnr()
  silent exe 'wincmd ' . a:direction
  let neww = winnr()
  if oldw == neww
    let directionMap = {'h': 'left', 'j': 'down', 'k': 'up', 'l': 'right'}
    silent exe '!i3-msg -q focus ' . directionMap[a:direction]
  endif
endfunction

nnoremap + :vertical resize +10<cr>
nnoremap _ :vertical resize -10<cr>
" Buffer operations similar to browsers
noremap <C-t> :enew<CR>
nnoremap <C-w> :call MimicBrowserClose()<CR>
" Text width formatting for small blocks
nnoremap <leader>fo :call ReformatTextWidth()<cr>
vnoremap <leader>fo :call ReformatTextWidth()<cr>

nnoremap <leader>bc :call CopyBuffer()<CR>
" Blink the current word when switching search words
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>
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
colorscheme badwolf
hi clear SpellBad
hi SpellBad ctermfg=DarkRed term=undercurl
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
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
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
autocmd FileType sh,bash,zsh,readline,nginx setlocal  shiftwidth=2 tabstop=2 expandtab nocindent smartindent
autocmd FileType php                    setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType markdown               setlocal  shiftwidth=4 tabstop=4 expandtab
autocmd FileType ruby                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType lua                    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType sshconfig              setlocal  shiftwidth=4 tabstop=4 expandtab
"-----------------------------------------
" Plugin specific settings
"-----------------------------------------
" fzf.vim
"-----------------------------------------
let g:fzf_layout = {'up': '~40%'}
nnoremap = :Files<cr>
nnoremap - :FzfLocateRoot<cr>
nnoremap b :Buffers<cr>
nnoremap <C-h> :History:<cr>
cnoremap <C-h> <Esc>:History:<cr>
nnoremap r :History<cr>
nnoremap <leader>gs :GitFiles?<cr>

command! FzfLocateRoot call FzfLocateRoot()
fu! FzfLocateRoot()
  let opts = {}
  let opts.source = 'locate /'
  let opts.options = '--prompt ">" --ansi' 
  call fzf#run(fzf#vim#wrap(opts))
endfu

command! -nargs=* AG call FzfAgCustom(<q-args>)
fu! FzfAgCustom(queryparam)
  let query = a:queryparam
  if len(query) == 0
    let query = expand('<cword>')
  endif

  let ag_opts = 'ag --nogroup --column --color -U "%s"'
  let source = printf(ag_opts, query)
  let options = '--tac -e'
  call fzf#vim#ag(query, {'options': options, 'source': source, 'up': '~40%'})
endfu

command! -nargs=* AgJSDefinition :call AgJSFnDefinition(<q-args>)
" An ag matcher which find most usages of a <keyword> except for function calls.
" ctags is probably a better solution but ctags doesnt seem reliable at all times
fu! AgJSFnDefinition(query) range
  let word = a:query
  if len(word) == 0
    let word = expand('<cword>')
  endif

  if len(word) > 0
    " = foo
    let regex1 = '(=\s*' . word . '\s+)'
    " prototype.foo
    let regex2 = '(prototype\.' . word . '\s+)'
    " foo: , {foo:
    let regex3 = '((\s+|\{)' . word . ':)'
    " foo = , baz.foo =
    let regex4 = '((\s+|\.)' . word . '\s*=\s+)'
    " function foo
    let regex5 = '(function\s+' . word . '\s*)'
    " Add es6 class - foo() {}
    let regex = printf('%s|%s|%s|%s|%s', regex1, regex2, regex3, regex4, regex5)
    call FzfAgCustom(regex)
  endif
endfu

command! -nargs=* -range AgJSFindRequire call AgJSFindRequire(<q-args>)
" Searches for a word in a `require(<word>)` call
fu! AgJSFindRequire(query) range
  " If we are passed a query param, use that
  if len(a:query) > 0
    let word = a:query
  else
    " If there is a visual selection, use that
    let word = Get_visual_selection()
    " Otherwise (most common use case), see where the current file is required
    if len(word) == 0
      let word = expand('%:t:r')
    endif
  endif
  " Single quoted strings don't need extra escaping aside from single quotes being
  " escaped by being repeated once. '''' => '''. Double quoted strings need escaping
  " in general. \\( becomes \( and \" becomes ". However, we need to escape " one
  " more time in the shell so " really becomes \\\".  Bear in mind that we need to
  " escape " here regardless because this command is passed to the shell.
  let regex = 'require\([\"|''].*' . word . '(\.js)?[\"|'']\)'
  call FzfAgCustom(regex)
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
" let g:EasyMotion_keys = 'ASDFGHJKL;QWERTYUIOPZXCVBNM'
let g:EasyMotion_keys = 'SDFAGHJKL;QWERTYUIOPZXCVBNM'
let g:EasyMotion_grouping = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_shade = 0
let g:EasyMotion_use_upper = 1
map f <Plug>(easymotion-bd-fl)
map t <Plug>(easymotion-bd-tl)
map s <Plug>(easymotion-sn)
map <C-j> <Plug>(easymotion-j)
map <C-k> <Plug>(easymotion-k)
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
let g:ycm_min_num_of_chars_for_completion = 1

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
autocmd FileType typescript nnoremap <buffer>gd :TSSdef<CR>
"-----------------------------------------
" Eclim Java, Scala
"-----------------------------------------
autocmd FileType scala map <buffer>gd :ScalaSearch<cr>
let g:EclimCompletionMethod = 'omnifunc'
"-----------------------------------------
" TernJS
"-----------------------------------------
autocmd FileType javascript nnoremap <buffer> <leader>t :TernType<cr>
" Replace the built in gd with Tern for JS files
autocmd FileType javascript noremap <silent><buffer>gd :call TernOrDucktape()<cr>
fu! TernOrDucktape()
  if getline('.') =~ 'require\(.*\)'
    let file = FindRequireJSFile()
    " If a string is returned
    if type(file) == 1
      let searchword = 'exports'
      " Enter the file at the module.exports line
      execute 'e +/' . searchword . ' ' . file
      " Save the search in the search register
      let @/ = searchword
      " Highlight searchword
      execute 'normal /' . searchword . "\<CR>"
    endif
  else
    execute 'TernDef'
  endif
endfu
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
" autocmd BufWritePre *.js,*.ts Fixmyjs

" TODO: replace this with job-control
autocmd filetype javascript command! -buffer FixJscs call RunJscs()
fu! RunJscs()
  call system("jscs --fix " . expand('%'))
  checktime
  w
endfu
"-----------------------------------------
" Jedi Python
"-----------------------------------------
" YCM also provides this functionality. But from initial tests (finding stdlib modules) jedi seems
" to be doing a better job.
let g:jedi#goto_command = 'gd'
let g:jedi#use_tabs_not_buffers = 0
" Do not select the first popup option and complete it
let g:jedi#popup_select_first = 0
" Autocomplete the function params
let g:jedi#show_call_signatures = "1"
"-----------------------------------------
" Golang
"-----------------------------------------
autocmd FileType go map <buffer>gd <Plug>(go-def)
autocmd FileType go nnoremap <buffer> <leader>t :GoInfo<cr>
" Show the type info at the bottom bar when hovering over word
let g:go_auto_type_info = 1
"-----------------------------------------
" Tagbar
"-----------------------------------------
let g:tagbar_sort        = 0
let g:tagbar_compact     = 1
let g:tagbar_indent      = 1
let g:tagbar_foldlevel   = 0
let g:tagbar_map_nexttag = '<C-j>'
let g:tagbar_map_prevtag = '<C-k>'
let g:tagbar_autofocus   = 1
let g:tagbar_autoclose   = 1
nnoremap <F6> :Tagbar<cr>
"-----------------------------------------
" UltiSnips
"-----------------------------------------
fu! Return_Or_Snippet()
  " Make sure we don't set this ourselves...
  if exists('g:UltiSnipsListSnippets') == 0
    return "\<cr>"
  endif

  if pumvisible()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res
      return ""
    endif
  else
    call UltiSnips#JumpForwards()
    if g:ulti_jump_forwards_res
      return ""
    else
      return "\<cr>"
    endif
  endif
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
let g:neomake_list_height = 8
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

" Do not enable this for zsh. shellcheck does not support zsh
autocmd BufWritePost *.js,*.py,*.sh,*.bash,bashrc,*.lua,*.go Neomake
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
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" Don't jump to the next bracket when closing
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0
" Shortcut to quickly wrap a world, i.e ''hello + key => 'hello'
let g:AutoPairsShortcutFastWrap = ''
" Jump to next closed pair
let g:AutoPairsShortcutJump = ''
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
" vim-dasht
"-----------------------------------------
let docsets_by_filetype = {
  \ 'elixir': ['erlang'],
  \ 'cpp': ['boost', '^c$', 'OpenGL', 'OpenCV_C'],
  \ 'html': ['css', 'js', 'bootstrap', 'jquery'],
  \ 'javascript': ['jasmine', 'nodejs', 'grunt', 'gulp', 'jade', 'react', 'underscore'],
  \ 'python': ['(num|sci)py', 'pandas', 'sqlalchemy', 'twisted', 'jinja'],
  \ }
nnoremap K :call call('Dasht', [expand('<cword>')]
      \ + get(docsets_by_filetype, &filetype, []))<Return>
vnoremap K y:call call('Dasht', [getreg(0)]
      \ + get(docsets_by_filetype, &filetype, []))<Return>
"-----------------------------------------
" vim-lua-ftplugin
"-----------------------------------------
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
"-----------------------------------------
" Random funcs
"-----------------------------------------
command! StripTrailingWhitespaces :call <SID>StripTrailingWhitespaces()
fun! <SID>StripTrailingWhitespaces()
  if &ft =~ 'vim'
    return
  endif
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

fu! MimicBrowserClose()
  " Mimic Chrome behavior with the exception that if we have an alt buffer, we switch to that first.
  "
  " You would expect this to work by default, but vim has a weird pattern of switching hidden
  " buffers. If a buffer is not set as hidden, it will not be the prioritized when jumping using bn
  " or bw. So if a file has been opened but never visited in a window it will never have the hidden
  " option so the window order will be weird.

  " We have a previous buffer. Wipe current and switch to that
  if buflisted(bufnr('#'))
    bw!
  " Current buffer is the only buffer to exist
  elseif bufnr('^') == bufnr('%')
    bw!
  " There are buffers to the right
  elseif bufnr('%') < bufnr('$')
    let nextRight = -1
    " Find the next buffer to right
    for i in range(bufnr('%') + 1, bufnr('$'))
      if buflisted(i)
        let nextRight = i
        break
      endif
    endfor
    execute 'buf' . nextRight
    bw! #
  " Current buffer is the last buffer on the right so we switch left
  elseif bufnr('%') == bufnr('$')
    let nextLeft = -1
    " Find the next buffer to the left
    for i in range(bufnr('%') - 1, bufnr('^'), -1)
      if buflisted(i)
        let nextLeft = i
        break
      endif
    endfor
    execute 'buf' . nextLeft
    bw! #
  endif
endfu

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

" See http://stackoverflow.com/a/6271254
function! Get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  " Dani patch. If lnum1=0 and lnum2=0 something went wrong
  if lnum1 == 0 && lnum2 == 0
    return ''
  endif
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
    " We don't want - `var foo = baz ;`
    call <SID>StripTrailingWhitespaces()
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
  if IsNumber(width)
    let &textwidth = width
  endif
  " Calling gvgq won't work because in normal mode it would
  " get the last visual selection which we don't want
  normal v
  execute "normal " . a:firstline . "gg"
  execute "normal " . a:lastline . "gg"
  normal gq
  let &textwidth = currWidth
  call inputrestore()
endfu!


function! FindRequireJSFile(...)
python << EOF
# This is a clusterfuck, but surprisingly works for JS
# TODO: Log when it can't find results
import vim
import os
import subprocess
import json

REQUIRE_REGEX = 'require\(["\'](.*)["\']\)'

def findRelativeRequire(requirePath):
  filename = requirePath
  if not filename.endswith('.js'):
    filename = filename + '.js'

  currDir = os.path.dirname(vim.current.buffer.name)
  realpath = os.path.realpath(os.path.join(currDir, filename))

  if os.path.isfile(realpath):
    return realpath
  else:
    filename = requirePath + '/index.js'

    relativePath = os.path.join(currDir, filename)
    realpath = os.path.realpath(relativePath)
    if os.path.isfile(realpath):
      return realpath

def findNodeModulesRequire(filename):
  if filename.endswith('.js'):
    filename = filename[:-3]

  currFile = vim.eval('expand("%:p")')
  currDir = os.path.dirname(currFile)

  # Walk until the package is found is found or we are at fs root. This accounts for nested
  # dependencies in the packages and shrinkwrapped projects.  If we are deep in a dependency
  # tree and look for a dependency that is common with the root projects dependency, npm may
  # have moved this dependency up in the tree.  So we need to check for this package in
  # every node_modules directory we encounter.
  # E.g we are looking for dependency c in b
  # $PROJ_ROOT/node_modules/a/node_modules/b
  # $PROJ_ROOT/node_modules/c

  packageDir = ''
  while currDir != '/':
    if 'node_modules' in os.listdir(currDir):
      packageDir = os.path.realpath(currDir + '/node_modules/' + filename)
      if os.path.isdir(packageDir):
        break
    currDir = os.path.dirname(currDir)

  packageJson = packageDir + '/package.json'
  if os.path.isfile(packageJson):
    with open(packageJson) as f:
      asJson = json.load(f)
      mainfile = packageDir + '/' + asJson['main']
      if mainfile.endswith('.js') == False:
        mainfile = mainfile + '.js'
      return mainfile

# Unused, but useful to keep for later maybe
def findRequireStmts():
  requireStmts = []
  for line in vim.current.buffer:
    m = re.search(REQUIRE_REGEX, line)
    if m:
      for word in m.groups():
        requireStmts.append(word)
  return requireStmts

# Unused, but useful to keep for later maybe
def promptChoice(title, arr):
  choices = []
  choices.append("'{}'".format(title))
  for idx, elem in enumerate(arr):
    choices.append("'{}. {}'".format(idx + 1, elem))
  asStr = ", ".join(choices)
  selected = vim.eval("inputlist([{}])".format(asStr))
  selectedIdx = int(selected)
  return arr[selectedIdx - 1]

currLine = vim.current.line
m = re.search(REQUIRE_REGEX, vim.current.line)
if m:
  stmt = m.groups()[0]
  root = None
  if stmt.startswith('.'):
    root = findRelativeRequire(stmt)
  else:
    root = findNodeModulesRequire(stmt)

  if root:
    vim.command('return "{}"'.format(root))
EOF
endfunction

fu! IsNumber(val)
  return type(a:val) == 0
endfu

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
