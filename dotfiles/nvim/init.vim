" Set providers
let g:python3_host_prog = '$HOME/venv/py3nvim/bin/python'
let g:node_host_prog = '$HOME/.yarn/bin/neovim-node-host'

" Vim-plug
call plug#begin('$HOME/.local/share/nvim/plugged')

" thub.com/jstemmer/gotagsLightline
Plug 'itchyny/lightline.vim'

" Vim-go
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" NerdTree (on-demand)
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" TagBar (on-demand)
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle', 'do': 'go get -u github.com/jstemmer/gotags' }

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Nord theme
Plug 'arcticicestudio/nord-vim'

" Solarized theme
Plug 'altercation/vim-colors-solarized'

" PaperColor theme
Plug 'NLKNguyen/papercolor-theme'

" Initialize plugin system
call plug#end()

" Change leader
let mapleader=","

" Close if the only window left is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Ignore pyc files
let NERDTreeIgnore = ['\.pyc$']
" Toggle NERDTree with Ctrl+N
map <C-n> :NERDTreeToggle<CR>

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" FZF
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" FZF Tags
function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()
map <Leader>p :Tags<cr>

function RefreshTags()
  call system('ctags -R ' . getcwd() . " &")
endfunction

noremap <silent> <Leader>r :call RefreshTags()<cr>

" Better display for messages
set cmdheight=2

" Tags hotkey
nmap <F8> :TagbarToggle<cr>

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ }

filetype plugin indent on
set background=light
colorscheme PaperColor
syntax on

" Spaces and Tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=2

" Ruler
set colorcolumn="81, 101"

" Set temp directory so that tmp files aren't everywhere
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.
set undodir=~/.vimtmp,.

" UI
set number
set relativenumber
set showcmd
set showmatch
set hlsearch

" Folding
set foldenable
set foldlevelstart=10
set foldmethod=indent

"Key Mappings
nnoremap j gj
nnoremap k gk

" Search config
set ignorecase
set smartcase
set incsearch
nnoremap <C-h> :noh<CR>

" Autoread
set autoread
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
\ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Disable mouse
set mouse=

" Set F3 as paste toggle
set pastetoggle=<F3>

" No number in terminal
au TermOpen * setlocal nonumber norelativenumber

" Golang
augroup golang
      au FileType go set noexpandtab
      au FileType go set shiftwidth=4
      au FileType go set softtabstop=4
      au FileType go set tabstop=4

      " run :GoBuild or :GoTestCompile based on the go file
      function! s:build_go_files()
            let l:file = expand('%')
            if l:file =~# '^\f\+_test\.go$'
                  call go#test#Test(0, 1)
            elseif l:file =~# '^\f\+\.go$'
                  call go#cmd#Build(0)
            endif
      endfunction

      autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
      autocmd FileType go nmap <leader>r  <Plug>(go-run)
      autocmd FileType go nmap <leader>t  <Plug>(go-test)
      autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
      autocmd FileType go nmap <Leader>i <Plug>(go-info)
      let g:go_auto_type_info = 1
      " let g:go_auto_sameids = 1

      " Easy auto import
      let g:go_fmt_command = "goimports"
      let g:go_addtags_transform = "camelcase"
      let g:go_highlight_types = 1
      let g:go_highlight_fields = 1
      let g:go_highlight_functions = 1
      let g:go_highlight_function_calls = 1
      let g:go_highlight_operators = 1
      let g:go_highlight_extra_types = 1
      let g:go_metalinter_autosave = 1
augroup END

" Easy pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Natural splits
set splitbelow
set splitright

" Trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Autowrite
set autowrite

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
