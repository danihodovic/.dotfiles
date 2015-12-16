# Todo

## Priority:High
- Block certain notifications on Linux mint (battery) while others are unblocked (Slack)
- Check out node inspector and the chrome debugger
- Write a script for resizing of tmux and vim windows transparently, just like switching is done.
- Figure out how pgp signing works
- Improve your workflow using tpope/vim-fugitive. Specifically get used to
  :Gdiff, :Gstatus, :Glog, :Gblame, :Gbrowse (github), :Gread and integrate it with statusline
- Improve your workflow using vim-startify. Learn how sessions work
- Write a fzf-ag helper which find where files are required
  -> Cursor over word `:AG require(.*<word>)`

## Priority:Low
- Get used to gf, gd, gq in vim
- Look at fpm
- Remove the focus-event plugin and clear the tmux file? since neovim has already implemented this
  by default. See https://github.com/tmux-plugins/vim-tmux-focus-events/pull/4
..*Test before you commit
- Learn vim folds
- Write vim-github viewer
- Try iabbrev in vim
- Try https://github.com/suan/vim-instant-markdown
- Look into bash script testing so that your install scripts don't break constantly
- Write a vim fzf helper to show edited git files
- Add vimscript snippets
- Map fzf-git-status (C-g) to echo new prompt when done selecting
- Look into fixmyjs (or alternatives) for more than semicolon fixing
- Add jscs formatting if it exists to vim-autoformat
- Figure out how to store encrypted files in public repos
..*https://github.com/AGWA/git-crypt
..*https://github.com/StackExchange/blackbox
- Checkout chiphogg/vim-vtd
- iabbrev date -> strftime or mapping for date
- Checkout vim journals/calendars
- Checkout apt-fast
- Add helper to collapse or inline JSON for JS (or Python, Go)
- Allow fzf :History: to be called in visual mode
- Fix try/catch in othree/yajs.vim
- When calling <leader>a, it should be project or directory specific except when in root proj.
  Use case: I ag something and find a node_modules. In that node_modules I want to find directory
  specific stuff.
- Instead of mapping <F7> and <F3> separately. Write a wrapper so that if we're above a require
  statement it uses are custom finder and otherwise uses tern within the file. This gets rid of the
  fancy prompt though :(. On a side note: Tern isn't all that bad. It requires some time to start
  and cache results, but after that it's decent. It still cant find packages which don't have an
  index.js file. Work on improving tern\_for\_vim instead? Update: The latest ternjs from master is
  *noticably* snappier than the 0.16.0 version found in npm. Few timeouts.
- Write an ag helper which finds Javascript definitons by
  prototype - .prototype.<method>
  object - : <method>
  assignment - = <method>
  es6 class - <method>() {}
- Make ag not look in tags files
- Fix Get_Visual_Selection() so that it doesn't look for the previous selection if there is no visal

# Done
- ~~Enable vim-airline to show branch
- ~~Add a global gitignore and scripts to set it up~~
- ~~Write a fzf.vim helper that looks at git status files~~
- ~~Move fzf to top so that it doesn't enlarge the neomake window~~
- ~~Write a fzf helper which opens word under cursor in :Ag~~
- ~~Look into terminal based music players~~
- ~~Write a fzf helper which opens word under cursor in :Tags~~
- ~~Bind tmux resize commands~~
- ~~Update to tmux 2.1 so that its easy to distinguish the active pane.~~
- ~~Try fzf.vim and potentially replace ctrlp~~
- ~~Try fzf~~
- ~~Check out pasting to clipboard for vim+tmux https://gist.github.com/tarruda/5158535~~
- ~~Rewrite distro notes to markdown format~~
- ~~Fiddle with NERDCommenter to add one space before comment~~
- ~~Set fzf.vim :Ag to an exact match or start Ag with a specific query~~

# Wont
- Try the neovim terminal emulator
- Add tags to various repos cf
- Write a fzf helper for `git status` files
