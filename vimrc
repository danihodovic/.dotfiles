" TODO: Add ag search within git files. Not node_modules
"-----------------------------------------
" Vim Plug
"-----------------------------------------
set nocompatible

" Only load plugins if we have vim-plug installed
let s:has_plug = 0
try
  call plug#begin('$NVIM_DIR/plugged')
  let s:has_plug = 1
catch /Unknown function/
endtry

if s:has_plug == 1
  "-----------------------------------------
  " General plugins
  "-----------------------------------------
  Plug 'Valloric/YouCompleteMe'
  Plug 'junegunn/fzf', { 'do': '~/.fzf/install --key-bindings --completion --no-update-rc' }
  Plug 'junegunn/fzf.vim'
  Plug 'airblade/vim-rooter'                    " Sets root directory to project (git) directory by default
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'            " Shows dirty files in NERDTree
  Plug 'flazz/vim-colorschemes'
  Plug 'ryanoasis/vim-devicons'
  Plug 'benekastah/neomake'
  Plug 'tpope/vim-surround'                     " Surround text with (){}<>
  Plug 'jiangmiao/auto-pairs'                   " Automatically add (){}<>
  Plug 'airblade/vim-gitgutter'                 " Show changed git lines
  Plug 'scrooloose/nerdcommenter'               " Comment/uncomment source code files
  Plug 'terryma/vim-multiple-cursors'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-fugitive'                     " Various git commands inside vim
  Plug 'Lokaltog/vim-easymotion'                " Better movement with f/t
  Plug 'SirVer/ultisnips'
  Plug 'danihodovic/vim-snippets'               " My own snippets
  Plug 'nathanaelkane/vim-indent-guides'        " Visually display indent lines with different color
  Plug 'tmhedberg/matchit'                      " Extended % matching for various languages
  Plug 'junegunn/vim-pseudocl'                  " Required by vim-oblique
  Plug 'junegunn/vim-oblique'                   " Colors search result and sets nohlsearch on cursor move
  Plug 'junegunn/vim-easy-align'                " Align code around arbitrary characters =,:
  Plug 'itchyny/vim-cursorword'                 " Highlight the occurances of the word under the cursor
  Plug 'kana/vim-textobj-user'                  " Add additional text objects
  Plug 'kana/vim-textobj-function'              " Add function based text objects
  Plug 'thinca/vim-textobj-function-javascript' " Add JS function object
  Plug 'FooSoft/vim-argwrap'                    " Collapse or expand arguments for a function
  Plug 'sunaku/vim-dasht'                       " Show documentation for the word under the cursor
  Plug 'sunaku/vim-hicterm'                     " Displays cterm colors
  Plug 'tpope/vim-abolish'                      " Change snake case to camelcase and vice versa
  Plug 'kana/vim-operator-user'                 " Required for vim-operator-flashy
  Plug 'haya14busa/vim-operator-flashy'         " Highlights the yanked words
  Plug 'luochen1990/rainbow'
  Plug 'equalsraf/neovim-gui-shim'              " Shim for nvim-qt that adds commands such as Guifont
  " -----------------------------------------
  " Lang specific
  " -----------------------------------------
  Plug 'jelera/vim-javascript-syntax'
  Plug 'HerringtonDarkholme/yats.vim'           " Typescript syntax
  Plug 'davidhalter/jedi-vim'                   " Python semantic completion
  Plug 'derekwyatt/vim-scala'
  Plug 'vim-erlang/vim-erlang-omnicomplete'
  Plug 'Valloric/MatchTagAlways'                " Show matching html/xml tags
  Plug 'fatih/vim-go'                           " Basically a Golang IDE for vi
  Plug 'rust-lang/rust.vim'                     " Rust syntax highlighting, formatting
  Plug 'ekalinin/Dockerfile.vim'                " Syntax for Dockerfile and snippets 
  Plug 'tpope/vim-endwise'                      " Adds if/end in Lua/Ruby
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'evanmiller/nginx-vim-syntax'
  Plug 'sudar/vim-arduino-syntax'
  Plug 'cespare/vim-toml'                       " Toml is a configuration language similar to yaml
  Plug 'danihodovic/nodejs-require.vim'
  Plug 'hashivim/vim-terraform'
  "-----------------------------------------
  call plug#end()
end
"-----------------------------------------
" General settings
set fillchars=stl:─,stlnc:─,vert:│,fold:─,diff:─
"-----------------------------------------
" Cursor shape betwen block and ibeam. Does not work for lxterminal, xfce4-terminal
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Silences C-Q, C-S and allows vim to catch them
silent !stty -ixon > /dev/null 2>/dev/null
" All y/p operations use clipboard by default
set clipboard=unnamedplus
set nobackup
set nowritebackup
set noswapfile
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
set scrolloff=10
set nofoldenable
autocmd BufEnter *.js,*.ts setlocal foldenable | setlocal foldmethod=indent
autocmd BufEnter *.go setlocal foldenable | setlocal foldmethod=syntax
let g:go_fmt_experimental = 1
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
noremap k gk
nnoremap : <nop>
execute "nnoremap <space> :" . &cedit . "a"
execute "xnoremap <space> :" . &cedit . "a"
execute "nnoremap / /" . &cedit . "a"
execute "xnoremap / /" . &cedit . "a"
execute "nnoremap ? ?" . &cedit . "a"
execute "xnoremap ? ?" . &cedit . "a"
" Exit cmdwindow on esc
autocmd CmdwinEnter * nnoremap <buffer> <esc> :q<cr>
set cmdwinheight=1
" Easier semicolon insertion
autocmd FileType javascript,typescript,css,perl,nginx noremap ;; :call InsertSemicolons()<CR>
nmap m %
vmap m %
" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv
nnoremap < <<
nnoremap > >>

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
nnoremap <C-w> :call MimicBrowserClose()<CR>
" Text width formatting for small blocks
nnoremap <leader>fo :call ReformatTextWidth()<cr>
vnoremap <leader>fo :call ReformatTextWidth()<cr>
" Blink the current word when switching search words
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>
" Map S to ys for vim-surround
map s ys
vmap s S
nnoremap <leader>aw :ArgWrap<cr>
"-----------------------------------------
" Color scheme settings
"-----------------------------------------
"Make sure to place color schemes after the vundle runtime has been declared
syntax enable
" Set the colorscheme using silent so that we don't fail on servers without plugins
silent! colorscheme badwolf
set background=dark
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
autocmd FileType typescript,javascript,terraform  setlocal  shiftwidth=2 tabstop=2 expandtab nocindent smartindent
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
autocmd FileType sh,bash,zsh,readline,nginx,conf setlocal  shiftwidth=2 tabstop=2 expandtab nocindent smartindent
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
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'vsplit',
  \ 'ctrl-c': 'split' }
let g:fzf_layout = {'up': '~40%'}
nnoremap = :Files<cr>
nnoremap - :call FzfGitChangedFilesFromMaster()<cr>
nnoremap b :Buffers<cr>
nnoremap <C-r> :History:<cr>
cnoremap <C-r> :History:<cr>
nnoremap r :History<cr>
nnoremap U :redo<cr>

function! FzfGitChangedFilesFromMaster()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    echom 'Not in git repo'
    return
  endif
  " If we pre determine the files and pass in a list instead of a command the fzf window will be
  " intelligently wrapped in height. If we pass a command it will have a default height and grow
  " from there.
  let files = split(system('git --no-pager diff origin/master --name-only'), '\n')
  call fzf#run({
  \ 'source':  files,
  \ 'sink':    'edit',
  \ 'dir':     root,
  \ 'options': '--ansi --multi --nth 2..,.. --prompt "GitFiles?> "',
  \ 'up':      '~40%'
  \})
endfunction

command! -nargs=* Calls :call FindFunctionCalls(<q-args>)
fu! FindFunctionCalls(query)
  let fn_name = ''
  if len(a:query) == ''
    let fn_name = expand('<cword>')
  else
    let fn_name = a:query
  endif

  let str = printf('%s\s*\(.*', fn_name)
  call fzf#vim#ag(str)
endfu

command! -nargs=* LogStatement :call LogStatementFind(<q-args>)
fu! LogStatementFind(query)
  let query = a:query
  if len(query) == ''
    let query = expand('<cword>')
  end

  let regex = printf("console.log\\('%s'", query)
  let ag_opts = 'ag --nogroup --column --color -U "%s"'
  call FzfAgCustom(regex, ag_opts)
endfu

command! -nargs=* FocusTest :call FocusTest(<q-args>)
fu! FocusTest(query)
  let query = a:query
  if len(query) == ''
    let query = expand('<cword>')
  end

  let regex = '(it\.only)|(describe\.only)'
  let ag_opts = 'ag --nogroup --column --color "%s"'
  call FzfAgCustom(regex, ag_opts)
endfu

nnoremap <leader>af :AllFiles<cr>
command! AllFiles call FzfLocateRoot()
fu! FzfLocateRoot()
  let opts = {}
  let opts.source = 'locate /'
  let opts.options = '--multi --prompt ">" --ansi'
  call fzf#run(fzf#vim#wrap(opts))
endfu

command! -nargs=* AG  call FzfAgCustom(<q-args>)
command! -nargs=* AGu call FzfAgCustom(<q-args>, 'ag --nogroup --column --color -U "%s"')

fu! FzfAgCustom(...)
  let query = a:1
  if a:0 >= 2
    let ag_opts = a:2
  else
    " By default:
    " - don't group multiple results in one file as one result
    " - print column numbers in the results
    " - don't search in VCS ignored files
    let ag_opts = 'ag --nogroup --column --color "%s"'
  endif

  if len(query) == 0
    let query = expand('<cword>')
  endif

  let source = printf(ag_opts, query)
  call fzf#vim#ag(query, {'source': source, 'up': '~40%'})
endfu

command! -nargs=* Definition :call FindFunctionDefinition(<q-args>)
" An ag matcher which find most usages of a <keyword> except for function calls.
" ctags is probably a better solution but ctags doesnt seem reliable at all times
fu! FindFunctionDefinition(query)
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
    " baz.foo =
    let regex4 = printf('\w+\.%s\s*=\s*', word) 
    " function foo (
    let regex5 = printf('(function\s+%s\s*\(.*\))', word)
    " class method
    let regex6 = printf('(%s\s*\(.*\)\s*\{)', word)

    let regex = printf('(%s|%s|%s|%s|%s|%s)', regex1, regex2, regex3, regex4, regex5, regex6)

    " See if there is only one match
    let ag_call = printf('ag --nogroup --column "%s"', regex)
    let result = system(ag_call)
    let as_array = split(result, '\n')

    " Only one match, go to that
    if len(as_array) == 1
      let split_by_colon = split(as_array[0], ':')
      let filename = split_by_colon[0]
      let line_number = split_by_colon[1]
      execute printf('edit +%s %s', line_number, filename)
      return
    endif

    " Multiple matches, call ag using fzf and decide from there
    call FzfAgCustom(regex)
  endif
endfu

command! -nargs=* -range FindRequireCalls call FindRequireCalls(<q-args>)
" Searches for a word in a `require(<word>)` call
fu! FindRequireCalls(query) range
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
autocmd VimEnter * if exists(":NERDTree") | IndentGuidesEnable
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
"-----------------------------------------
" EasyMotion
"-----------------------------------------
let g:EasyMotion_keys = 'hgjfkdls;a'
let g:EasyMotion_grouping = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_shade = 0
let g:EasyMotion_use_upper = 1
map f <Plug>(easymotion-bd-fl)
map t <Plug>(easymotion-bd-tl)
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
let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
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
      \   'erlang' : [':'],
      \ }

augroup GoToBinding
  autocmd FileType typescript nnoremap <buffer>gd :YcmCompleter GoToDefinition<cr>
  autocmd FileType javascript noremap <silent><buffer>gd :call TernOrDucktape()<cr>
  " Don't make these commands -buffer local. If you do that you can't autocomplete the commands in
  " the command line window.
  autocmd FileType typescript,javascript command! -nargs=1 Rename YcmCompleter RefactorRename <args>
  autocmd FileType typescript,javascript command! References YcmCompleter GoToReferences
  autocmd FileType typescript,javascript command! Doc YcmCompleter GetDoc
  autocmd FileType typescript,javascript nnoremap <buffer><leader>t :YcmCompleter GetType<cr>

  autocmd FileType scala nnoremap map <buffer>gd :ScalaSearch<cr>
augroup END
"-----------------------------------------
" Eclim Java, Scala
"-----------------------------------------
let g:EclimCompletionMethod = 'omnifunc'
"-----------------------------------------
" TernJS
"-----------------------------------------
fu! TernOrDucktape()
  if getline('.') =~ 'require\(.*\)'
    let file = require#find_in_current_line()
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
    execute 'YcmCompleter GoToDefinition'
  endif
endfu
"-----------------------------------------
" FixMyJS
"-----------------------------------------
" TODO: replace this with job-control
autocmd filetype javascript command! FixJscs call RunJscs()
fu! RunJscs()
  call system("jscs --fix " . expand('%'))
  checktime
  w
endfu

autocmd filetype javascript command! FixEslint call RunEslint()
fu! RunEslint()
  call system("eslint --fix " . expand('%'))
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
  " This function *has* to return a keystroke since it's mapped by <C-R>=. 
  " If nothing it returns it is implied to return 0 and 0 will be inserted.
  
  " Make sure we don't set this ourselves...
  if exists('g:UltiSnipsListSnippets') == 0
    return "\<cr>"
  endif

  " Insert snippet if we can
  if pumvisible()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res != 0
      return ""
    endif
  endif

  " Jump forward if we can
  call UltiSnips#JumpForwards()
  if g:ulti_jump_forwards_res != 0
    return ""
  endif

  " Default to pressing enter
  return "\<cr>"
endfunction


inoremap <return> <C-R>=Return_Or_Snippet()<cr>
" Fix so that snippets show up in the completion menu, see
" https://github.com/Valloric/YouCompleteMe/issues/1214
let g:UltiSnipsUsePythonVersion = 2
" Load my own snippets
let g:UltiSnipsSnippetDirectories=[$NVIM_DIR.'/plugged/vim-snippets']
"-----------------------------------------
" GitGutter
"-----------------------------------------
let g:gitgutter_max_signs=9999
hi SignColumn guibg=black ctermbg=black
nnoremap ggn :GitGutterNextHunk<cr>
nnoremap ggp :GitGutterPrevHunk<cr>
"-----------------------------------------
" vim-operator-flashy
"-----------------------------------------
highlight Flashy term=bold ctermbg=15 ctermfg=122
map y <Plug>(operator-flashy)
"-----------------------------------------
" Neomake
"-----------------------------------------
let g:neomake_list_height = 8
let g:neomake_open_list = 2

let g:neomake_typescript_tsc_maker = {
    \ 'args': ['--noEmit'],
    \ 'append_file': 0,
    \ 'errorformat':
        \ '%E%f %#(%l\,%c): error %m,' .
        \ '%E%f %#(%l\,%c): %m,' .
        \ '%Eerror %m,' .
        \ '%C%\s%\+%m',
    \ }

" let g:neomake_verbose = 3
let g:neomake_typescript_tslint_maker = {
    \ 'args': ['--project', 'tsconfig.json'],
    \ 'append_file': 0,
    \ 'errorformat': '%f[%l\, %c]: %m'
    \ }
let g:neomake_typescript_enabled_makers = ['tslint', 'tsc']
" Do not enable this for zsh. shellcheck does not support zsh
autocmd BufWritePost *.js,*.ts,*.py,*.sh,*.bash,bashrc,*.lua,*.go Neomake
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

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

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
    " Swap to the previous buffer first and delete old buffer. If we just do bw! the first buffer we
    " switch to will be a quickfix window if the quickfix widow is open.
    execute 'buf' . bufnr('#')
    execute 'bw! ' . bufname('#')
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

fu! IsNumber(val)
  return type(a:val) == 0
endfu

command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Create the parent directory if it doesn't exist before saving
function! s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), expand('<abuf>'))
augroup END
