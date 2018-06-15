"-----------------------------------------
" Vim Plug
"-----------------------------------------
" Only load plugins if we have vim-plug installed
let s:has_plug = 0
try
  call plug#begin('$HOME/.config/nvim/plugged')
  let s:has_plug = 1
catch /Unknown function/
endtry

if s:has_plug == 1
  "-----------------------------------------
  " General plugins
  "-----------------------------------------
  set rtp+=~/.fzf
  Plug 'airblade/vim-gitgutter'                 " Show changed git lines
  Plug 'airblade/vim-rooter'                    " Sets root directory to project (git) directory by default
  Plug 'aquach/vim-http-client'
  Plug 'benekastah/neomake'
  Plug 'danihodovic/vim-snippets'               " My own snippets
  Plug 'equalsraf/neovim-gui-shim'              " Shim for nvim-qt that adds commands such as Guifont
  Plug 'flazz/vim-colorschemes'
  Plug 'FooSoft/vim-argwrap'                    " Collapse or expand arguments for a function
  Plug 'haya14busa/vim-operator-flashy'         " Highlights the yanked words
  Plug 'itchyny/vim-cursorword'                 " Highlight the occurances of the word under the cursor
  Plug 'jiangmiao/auto-pairs'                   " Automatically add (){}<>
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'                " Align code around arbitrary characters =,:
  Plug 'junegunn/vim-oblique'                   " Colors search result and sets nohlsearch on cursor move
  Plug 'junegunn/vim-pseudocl'                  " Required by vim-oblique
  Plug 'kana/vim-operator-user'                 " Required for vim-operator-flashy
  Plug 'kana/vim-textobj-function'              " Add function based text objects
  Plug 'kana/vim-textobj-user'                  " Add additional text objects
  Plug 'kopischke/vim-fetch'                    " Open files at file:line:column
  Plug 'Lokaltog/vim-easymotion'                " Better movement with f/t
  Plug 'luochen1990/rainbow'                    " Show diff level of parentheses in diff colors
  Plug 'nathanaelkane/vim-indent-guides'        " Visually display indent lines with different color
  Plug 'reedes/vim-wordy'                       " Linting for prose
  Plug 'scrooloose/nerdcommenter'               " Comment/uncomment source code files
  Plug 'scrooloose/nerdtree'
  Plug 'SirVer/ultisnips'
  Plug 'sunaku/vim-hicterm'                     " Displays cterm colors
  Plug 'thinca/vim-textobj-function-javascript' " Add JS function object
  Plug 'tmhedberg/matchit'                      " Extended % matching for various languages
  Plug 'tpope/vim-abolish'                      " Change snake case to camelcase and vice versa
  Plug 'tpope/vim-fugitive'                     " Various git commands inside vim
  Plug 'tpope/vim-rhubarb'                      " Github commands for Fugitive
  Plug 'tpope/vim-surround'                     " Surround text with (){}<>
  Plug 'Valloric/YouCompleteMe', { 'dir': '$HOME/.config/nvim/plugged/YouCompleteMe', 'do': './install.py --tern-completer' }
  Plug 'autozimu/LanguageClient-neovim', {
    \'tag': 'binary-*-x86_64-unknown-linux-musl',
    \'do': 'which npm && npm install -g javascript-typescript-langserver@latest',
  \}
  Plug 'vitalk/vim-shebang'
  " -----------------------------------------
  " Lang specific
  " -----------------------------------------
  Plug 'b4b4r07/vim-ansible-vault'
  Plug 'hashivim/vim-terraform'
  Plug 'juliosueiras/vim-terraform-completion'
  Plug 'cespare/vim-toml'                       " Toml is a configuration language similar to yaml
  Plug 'danihodovic/nodejs-require.vim'
  Plug 'derekwyatt/vim-scala'
  Plug 'ekalinin/Dockerfile.vim'                " Syntax for Dockerfile and snippets 
  Plug 'chr4/nginx.vim'
  Plug 'fatih/vim-go'                           " Basically a Golang IDE for vi
  Plug 'leafgarland/typescript-vim'             " Typescript syntax
  Plug 'jelera/vim-javascript-syntax'
  Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'rust-lang/rust.vim'                     " Rust syntax highlighting, formatting
  Plug 'sudar/vim-arduino-syntax'
  Plug 'tpope/vim-endwise'                      " Adds if/end in Lua/Ruby
  Plug 'Valloric/MatchTagAlways'                " Show matching html/xml tags
  Plug 'vim-erlang/vim-erlang-omnicomplete'
  Plug 'junegunn/vader.vim'
  Plug 'elixir-editors/vim-elixir'
  Plug 'pearofducks/ansible-vim'
  Plug 'tomlion/vim-solidity'
  call plug#end()
end
"-----------------------------------------
" General settings
set fillchars=stl:─,stlnc:─,vert:│,fold:─,diff:─
set gdefault
"-----------------------------------------
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
" Don't display the mode in insert mode at the bottom
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
" Execute macro over a visual selection
xnoremap <leader>q :'<,'>:normal @q<CR>
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
nnoremap<C-w> :q<cr>
autocmd CmdwinEnter * nnoremap <buffer> <C-w> :q<cr>
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
nnoremap { [{
nnoremap } ]}
nnoremap ( [(
nnoremap ) ])

"Window movement
inoremap <silent> <C-h> <esc>:wincmd h<cr>
inoremap <silent> <C-l> <esc>:wincmd l<cr>
inoremap <silent> <C-j> <esc>:wincmd j<cr>
inoremap <silent> <C-k> <esc>:wincmd k<cr>

nnoremap <silent> <C-h> :wincmd h<cr>
nnoremap <silent> <C-l> :wincmd l<cr>
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-k> :wincmd k<cr>

nnoremap <leader>w :write<cr>

set statusline=%m\ %f
highlight statusline ctermfg=8 ctermbg=233
autocmd CursorMoved,CursorMovedI * call UpdateStatusLine()
autocmd BufWritePost * hi statusline ctermfg=8 ctermbg=233
fu! UpdateStatusLine()
  let bufinfos = getbufinfo()
  for bufinfo in bufinfos
    if bufinfo.changed
      hi statusline ctermfg=46 ctermbg=233
      return
    endif

    hi statusline ctermfg=8 ctermbg=233
  endfor
endfu

nnoremap + :vertical resize +10<cr>
nnoremap _ :vertical resize -10<cr>
" Buffer operations similar to browsers
nnoremap <C-q> :call MimicBrowserClose()<CR>
" Text width formatting for small blocks
nnoremap <leader>fo :call ReformatTextWidth()<cr>
vnoremap <leader>fo :call ReformatTextWidth()<cr>
" Blink the current word when switching search words
nnoremap <silent> n   n:call HLNext(0.1)<cr>
nnoremap <silent> N   N:call HLNext(0.1)<cr>
" Go to the next location list item
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprev<cr>
" Map S to ys for vim-surround
map S ys
nnoremap <leader>aw :ArgWrap<cr>
nnoremap <leader>en :lnext<cr>
nnoremap <leader>ep :lprevious<cr>
autocmd BufWritePre *.tf TerraformFmt
"-----------------------------------------
" Color scheme settings
"-----------------------------------------
"Make sure to place color schemes after the vundle runtime has been declared
syntax enable
set background=dark
" Set the colorscheme using silent so that we don't fail on servers without plugins
silent! colorscheme badwolf
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
hi CursorLine ctermbg=236 guibg=#242321
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
set textwidth=80
set colorcolumn=80
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
autocmd BufNewFile,BufRead nginx.*.j2 set ft=nginx
"-----------------------------------------
" Indentation settings
" See http://tedlogan.com/techblog3.html
" softtabstop - number of spaces in tab character
" tabstop - number of visual spaces in a tab
" expandtab - tabs become spaces
"-----------------------------------------
" `nocindent smartindent` will allow us to omit semicolons and jump to the next line without auto indentation
" for Javascript/Typescript
autocmd FileType typescript,javascript,terraform,jinja2  setlocal  shiftwidth=2 tabstop=2 expandtab nocindent smartindent
autocmd FileType coffee                 setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType css,scss,stylus        setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType vim                    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType tex                    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType yaml,docker-compose    setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType json                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType snippets               setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType jade                   setlocal  shiftwidth=2 tabstop=2 expandtab
autocmd FileType html,htmldjango        setlocal  shiftwidth=2 tabstop=2 expandtab
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
  \ 'ctrl-z': 'split' }
let g:fzf_layout = {'up': '~40%'}
nnoremap b :e #<cr>
nnoremap - :Buffers<cr>
nnoremap = :call FzfGitChangedFilesFromMaster()<cr>
nnoremap <M-=> :Files<cr>
nnoremap <M--> :GitFiles<cr>
nnoremap H :History:<cr>
cnoremap H :History:<cr>
nnoremap r :History<cr>

function! FzfGitChangedFilesFromMaster()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    echom 'Not in git repo'
    return
  endif

  let default_remote_branch = split(system("git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'"), '\n')[0]
  let cmd_diff_files = printf('git --no-pager diff origin/%s --name-only', default_remote_branch)
  let diff_files = split(system(cmd_diff_files), '\n')

  let untracked_files = split(system('git ls-files --others --exclude-standard'), '\n')
  let files = diff_files + untracked_files

  let wrapped = fzf#wrap({
  \ 'source':  files,
  \ 'dir':     root,
  \ 'options': '--ansi --multi --nth 2..,.. --tiebreak=index --prompt "GitFiles?> " --preview ''sh -c "(git diff origin/master --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500"''',
  \ 'up':      '50%',
  \})
  call fzf#run(wrapped)
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

  let regex = printf('console.log\(''%s', query)
  call fzf#vim#ag(regex)
endfu

command! FocusTest :call FocusTest()
fu! FocusTest()
  let regex = '(it\.only)|(describe\.only)|(it\(''=>)|(describe\(''=>)'
  call fzf#vim#ag(regex)
endfu

nnoremap <leader>af :AllFiles<cr>
command! AllFiles call FzfLocateRoot()
fu! FzfLocateRoot()
  let opts = {}
  let opts.source = 'locate /'
  let opts.options = '--multi --prompt ">" --ansi'
  call fzf#run(fzf#vim#wrap(opts))
endfu

command! -nargs=* -complete=file AG call AGraw(<q-args>)
function! AGraw(args)
  let query = a:args
  if query == ''
    let query = expand('<cword>')
  endif
  call fzf#vim#ag_raw(query)
endfunction
"-----------------------------------------
" FooSoft/vim-argwrap
"-----------------------------------------
autocmd filetype go let b:argwrap_tail_comma = 1
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
let g:EasyMotion_do_shade = 1
let g:EasyMotion_use_upper = 1
map f <Plug>(easymotion-bd-fl)
map t <Plug>(easymotion-bd-tl)
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
let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
let g:ycm_filetype_blacklist = {
  \'notes': 1,
  \'unitte': 1,
  \'tagtbar': 1,
  \'pantdoc': 1,
  \'qf': 1,
  \'vimtwiki': 1,
  \'inftolog': 1,
  \'maitl': 1}
" Opts: menu, menuone, longest, preview
" Avoid preview to use completion  engine lookups, otherwise it tends to lag.
" Avoid longest as it disables you from typing
set completeopt=menuone
"-----------------------------------------
" LanguageClient
"-----------------------------------------
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_serverCommands = {
  \ 'javascript': ['javascript-typescript-stdio'],
\ }
autocmd filetype javascript nnoremap <silent> gd :call TernOrDucktape()<CR>
autocmd filetype javascript nnoremap <silent> <leader>t :call LanguageClient_textDocument_hover()<CR>
autocmd filetype javascript nnoremap <silent> <leader>gr :call LanguageClient_textDocument_references()<CR>
autocmd filetype go nnoremap <silent>gd <Plug>(go-def)
autocmd filetype go nmap <leader>t <Plug>(go-info)
autocmd filetype go nnoremap <buffer> <leader>fs :GoFillStruct<cr>
"-----------------------------------------
" YCM
"-----------------------------------------
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
    call LanguageClient_textDocument_definition()
  endif
endfu
"-----------------------------------------
" FixMyJS
"-----------------------------------------
function! LintConfigExists()
  if &filetype == 'typescript'
    if filereadable('tslint.json')
      return 1
    endif
  elseif &filetype == 'javascript'
    let eslintFiles = ['.eslintrc.json', '.eslintrc.js', '.eslintrc.yml', '.eslintrc']
    let eslintFileExists = 0

    for eslintFile in eslintFiles
      if filereadable(eslintFile)
        return 1
      endif
    endfor
  endif

  return 0
endfunction

fu! LintAndFix()
  if LintConfigExists() == 0
    return
  endif

  if &filetype == 'typescript'
    let executable = 'tslint'
  else
    let executable = 'eslint'
  endif

  let currentFile = expand('%')
  let cmd = printf('%s --fix %s', executable, currentFile)

  function! LintAndFixCallback(job_id, data, event)
    Neomake
  endfunction

  call jobstart(cmd, {'on_exit': 'LintAndFixCallback'})
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
nmap <Leader>s <Plug>GitGutterStageHunk
nmap <Leader>u <Plug>GitGutterUndoHunk
"-----------------------------------------
" Fugitive
"-----------------------------------------
command! Gdom Gdiff origin/master
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

let g:neomake_typescript_tslint_maker = {
    \ 'args': ['--project', 'tsconfig.json'],
    \ 'append_file': 0,
    \ 'errorformat': '%EERROR: %f[%l\, %c]: %m,%E%f[%l\, %c]: %m'
    \ }
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe = getcwd() . '/node_modules/.bin/eslint'
let g:neomake_typescript_enabled_makers = ['tslint', 'tsc']
let g:neomake_ansible_ansiblelint_maker = {
    \ 'exe': 'ansible-lint',
    \ 'args': ['-p', '--nocolor', '-x', 'ANSIBLE0011'],
    \ 'errorformat': '%f:%l: [%tANSIBLE%n] %m',
    \ }

autocmd BufWritePost * call BufWritePostNeomake()
func BufWritePostNeomake()
  let neomake_bufwritepost_filetypes = [
  \ 'python', 'bash', 'lua', 'go', 'ruby', 'ansible', 'sh'
  \]
  let neomake_lint_and_fix_filetypes = ['javascript', 'typescript']

  if count(neomake_lint_and_fix_filetypes, &filetype)
    call LintAndFix()
  elseif count(neomake_bufwritepost_filetypes, &filetype)
    Neomake
  endif

endfunc

autocmd BufWritePre * if &ft == 'go' | exec 'GoImports' | endif
"-----------------------------------------
" Auto-pairs
"-----------------------------------------
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" Disable inappropriate defaults
let g:AutoPairsFlyMode = 0
let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
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
" vim-lua-ftplugin
"-----------------------------------------
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
"-----------------------------------------
" juliosueiras/vim-terraform-completion
"-----------------------------------------
autocmd filetype terraform noremap <buffer><silent> gd :call terraformcomplete#JumpRef()<CR>
autocmd filetype terraform noremap <buffer><silent><Leader>o :call terraformcomplete#LookupAttr()<CR>
autocmd filetype terraform noremap <buffer><silent> K :call terraformcomplete#OpenDoc()<CR>
let g:neomake_terraform_enabled_makers = ['terraform_validate', 'tflint']
"-----------------------------------------
" pgilad/vim-skeletons
"-----------------------------------------
let skeletons#autoRegister = 1
let skeletons#skeletonsDir = '$HOME/.config/nvim/plugged/vim-skeleton-snippets'
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
