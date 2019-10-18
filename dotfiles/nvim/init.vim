" Set providers
let g:node_host_prog = '$HOME/.yarn/bin/neovim-node-host'

" Vim-plug
call plug#begin('$HOME/.local/share/nvim/plugged')

" thub.com/jstemmer/gotagsLightline
Plug 'itchyny/lightline.vim'

" Vim-go
" Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" NerdTree (on-demand)
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" TagBar (on-demand)
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle', 'do': 'go get -u github.com/jstemmer/gotags' }

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" WindowSwap
Plug 'wesQ3/vim-windowswap'

" Nord theme
Plug 'arcticicestudio/nord-vim'

" Solarized theme
Plug 'altercation/vim-colors-solarized'

" PaperColor theme
Plug 'NLKNguyen/papercolor-theme'

" Initialize plugin system
call plug#end()

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

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! CocGitStatus()
    return get(g:,'coc_git_status','')
endfunction

" Add diagnostic info for https://github.com/itchyny/lightline.vim
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitstatus', 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitstatus': 'CocGitStatus',
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \ },
      \ }

filetype plugin indent on
set background=light
colorscheme PaperColor
set cursorline
syntax on

" Spaces and Tabs
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=2

" Ruler
set colorcolumn=81,101

" Set temp directory so that tmp files aren't everywhere
set backupdir=~/.vimtmp,.
set directory=~/.vimtmp,.
set undodir=~/.vimtmp,.

set undofile
set backup

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
nnoremap <C-m> :noh<CR>

" Use system clipboard
set clipboard=unnamed

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

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent><Leader>d :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format)
nmap <leader>f  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Disable mouse
set mouse=

" Set F3 as paste toggle
set pastetoggle=<F3>

" No number in terminal
au TermOpen * setlocal nonumber norelativenumber

" Golang
" let g:go_info_mode='guru'

" Golang
augroup golang
      au FileType go set noexpandtab
      au FileType go set shiftwidth=4
      au FileType go set softtabstop=4
      au FileType go set tabstop=4

	  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
      " " run :GoBuild or :GoTestCompile based on the go file
      " function! s:build_go_files()
      "       let l:file = expand('%')
      "       if l:file =~# '^\f\+_test\.go$'
      "             call go#test#Test(0, 1)
      "       elseif l:file =~# '^\f\+\.go$'
      "             call go#cmd#Build(0)
      "       endif
      " endfunction

      " autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
      " autocmd FileType go nmap <leader>r  <Plug>(go-run)
      " autocmd FileType go nmap <leader>t  <Plug>(go-test)
      " autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
      " autocmd FileType go nmap <Leader>i <Plug>(go-info)
      " let g:go_auto_type_info = 1
      " " let g:go_auto_sameids = 1

      " " Easy auto import
      " let g:go_fmt_command = "goimports"
      " let g:go_addtags_transform = "camelcase"
      " let g:go_highlight_types = 1
      " let g:go_highlight_fields = 1
      " let g:go_highlight_functions = 1
      " let g:go_highlight_function_calls = 1
      " let g:go_highlight_operators = 1
      " let g:go_highlight_extra_types = 1
      " let g:go_metalinter_autosave = 1
augroup END

" Easy pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent> <Leader>h :vertical resize -5<CR>
nnoremap <silent> <Leader>l :vertical resize +5<CR>
nnoremap <silent> <Leader>k :resize -2<CR>
nnoremap <silent> <Leader>j :resize +2<CR>

" Natural splits
set splitbelow
set splitright

" Trim trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Autowrite
set autowrite

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
