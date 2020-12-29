" vim-bootstrap

"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')
let g:vim_bootstrap_editor = "vim"				" nvim or vim

let mapleader = "," 
if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

"Initialize the plugin system
call plug#begin(expand('~/.vim/plugged'))
Plug 'preservim/nerdtree'
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-repeat'
Plug 'lfilho/cosco.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'StanAngeloff/php.vim'
Plug 'tyrannicaltoucan/vim-quantum'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'natebosch/dartlang-snippets'
Plug 'dart-lang/dart-vim-plugin'
Plug 'alvan/vim-closetag'
Plug 'posva/vim-vue'
Plug 'APZelos/blamer.nvim'
"Plug 'zivyangll/git-blame.vim'

if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

"Visual settings
syntax on
set nowrap
set encoding=UTF-8
set nu rnu 
set tabstop=3
set shiftwidth=3
set expandtab

""Theme
let g:quantum_black=1
set background=dark
set termguicolors
let g:airline_theme='quantum'
colorscheme quantum
let g:quantum_italics=1
let g:lightline = {
      \ 'colorscheme': 'quantum',
      \ }
""Highlight the current line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#263238 ctermbg=239

""fzf
let g:ctrlp_clear_cache_on_exit = 0

"Git blame
let g:blamer_enabled = 1
let g:blamer_delay = 500
highlight Blamer guifg=lightgrey
let g:blamer_template = '<commit-short> • <committer>, <committer-time> • <summary>'
"nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

""fold and unfold
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

"Fix the identation
map <F7> gg=G<C-o><C-o>
filetype indent on
set smartindent
autocmd BufRead,BufWritePre *.sh normal gg=G


""Customize conceal color
let g:indentLine_setColors=1
let g:indentLine_color_term = 239
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" Background (Vim, GVim)
let g:indentLine_bgcolor_term = 202
let g:indentLine_bgcolor_gui = '#263238'

""FZF
nmap <C-P> :FZF<CR>

""Ag
nmap <C-F> :Ag<space>

""MatchParen color
hi MatchParen cterm=bold ctermbg=none ctermfg=blue

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"NerdTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>
"Tagbar
map <F8> :TagbarToggle<CR>
"Tagbar typescript
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

"*****************************************************************************
""Coc config
"*****************************************************************************
"
let g:coc_global_extensions = [
   \ 'coc-snippets',
   \ 'coc-pairs',
   \ 'coc-tsserver',
   \ 'coc-eslint',
   \ 'coc-prettier',
   \ 'coc-json',
   \ 'coc-phpls',
   \ ]
""Coc-snippets
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
 
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
 
let g:coc_snippet_next = '<tab>'
""Coc-flutter
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

""Goto definition
function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>

""Cosco.vim
augroup cosco-vim
  autocmd!
  autocmd FileType javascript,css,php nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
  autocmd FileType javascript,css,php imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)
augroup END

""Closing tags
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"Automatically close character
inoremap " ""<left>
inoremap ' ''<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
