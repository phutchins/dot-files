set nocompatible
filetype off

" Encryption
set cm=blowfish2
set viminfo=
set nobackup
set nowritebackup

let os = substitute(system("uname"), "\n", "", "")
if os == "Linux"
  let powerlineInstalled=1
  let powerline_bin=expand('~/.local/bin/powerline')
  if !filereadable(powerline_bin)
    echo "Installing Powerline"
    echo ""
    "silent !sudo apt-get install python-setuptools
    "silent !pip install --user git+git://github.com/Lokaltog/powerline
    "silent !mkdir -p ~/.git_repos
    "silent !git clone git@github.com:Lokaltog/powerline.git ~/.git_repos/powerline
    let powerlineInstalled=0
  endif
  if powerlineInstalled == 0
    "echo "Building Powerline..."
    "echo ""
    "silent !cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py build
    "silent !cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install --root="~/.git_repos/powerline"
    "silent !cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install --user
  endif
  let g:Powerline_symbols = 'fancy'
  set rtp+=~/.git_repos/powerline/powerline/bindings/vim
  "set rtp+=/powerline/bindings/vim
  "set rtp+=~/.git_repos/powerline/build/lib.linux-x86_64-2.7/powerline/bindings/vim
  "python from powerline.vim import setup as powerline_setup
  "python powerline_setup()
  "python del powerline_setup
  "redraw!
elseif os == "Darwin"
  let g:Powerline_symbols = 'fancy'
  set rtp+=~/.git_repos/powerline/powerline/bindings/vim
  " Loads powerline from pip install
  python3 from powerline.vim import setup as powerline_setup
  python3 powerline_setup()
  python3 del powerline_setup
  " python from powerline.vim import setup as powerline_setup
  " python powerline_setup()
  " python del powerline_setup
endif

" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    Bundle 'gmarik/vundle'
    Bundle 'flazz/vim-colorschemes'
    Bundle 'tpope/vim-fugitive'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'tpope/vim-rails'
    Bundle 'tpope/vim-cucumber'
    Bundle 'tpope/vim-endwise'
    Bundle 'scrooloose/nerdtree'
    Bundle 'godlygeek/tabular'
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'scrooloose/syntastic'
    Bundle 'kien/ctrlp.vim'
    Bundle 'briancollins/vim-jst'
    Bundle 'nelstrom/vim-visual-star-search'
    Bundle 'tomasr/molokai'
    Bundle 'tpope/vim-commentary'
    Bundle 'tpope/vim-haml'
    Bundle 'tpope/vim-surround'
    Bundle 'vim-javascript'
    Bundle 'vim-ruby/vim-ruby'
    Bundle 'vim-scripts/HTML-AutoCloseTag'
    Bundle 'jgdavey/vim-blockle'
    Bundle 'ngmy/vim-rubocop'
    Bundle 'rking/ag.vim'
    Bundle 'nathanaelkane/vim-indent-guides'
    Bundle 'thoughtbot/vim-rspec'
    Bundle 'Valloric/YouCompleteMe'
    Bundle 'fatih/vim-go'
    "Bundle 'Syntastic' "uber awesome syntax and errors highlighter
    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif

let vimrubocop_config='config/rubocop/rubocop.yml'

filetype plugin indent on

runtime macros/matchit.vim

" Set options for ctrlp.vim
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

let g:rails_projections = {
      \ "app/assets/javascripts/*.js.coffee": { "alternate": "spec/javascripts/%s_spec.coffee" },
      \ "spec/javascripts/*_spec.coffee": { "alternate": [
      \   "app/assets/javascripts/%s.js.coffee",
      \   "app/assets/javascripts/%s.jst.ejs"
      \ ] },
      \ "app/assets/javascripts/*.jst.ejs": { "alternate": "spec/javascripts/%s_spec.coffee" }
      \}

set wildignore+=*/spec/reports/*,*/vendor/*

" Remove the gf mapping that vim.rails adds from coffee files
" :verbose nmap gf
autocmd User Rails.javascript.coffee* nunmap <buffer> gf
"set path+=app/assets/javascripts/cde/*,spec/javascripts
set suffixesadd=.jst.ejs,.js.coffee

syntax on
set laststatus=2
set encoding=utf-8
set mouse=a

map <leader>ff :CtrlP<CR>
map <leader>fb :CtrlPBuffer<CR>
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
map <leader>t  :A<CR>
map <leader>ts :AS<CR>
map <leader>tv :AV<CR>
map <leader>rm :Rmodel<CR>
map <leader>rc :Rcontroller<CR>
map <leader>rh :Rhelper<CR>
map <leader>ru :Runittest<CR>
map <leader>rf :Rfunctionaltest<CR>
map <leader>ro :Robserver<CR>
map <leader>rv :Rview<CR>
map <leader>rl :Rlocale<CR>
imap jj <Esc>

set autoread    "Auto reload files changed outside of vim automatically
set wildmenu
set wildmode=list:longest
set splitright
set splitbelow
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set hidden
set number
set ic
set hlsearch
set incsearch
"set noswapfile
"set nobackup
set backupdir=~/.vim/backup/,~/.tmp,~/tmp,/tmp
set directory=~/.vim/backup/,~/.tmp,~/tmp,/tmp
set autoread      "Autoreload files changed externally
set noeb vb t_vb=
set so=5
set foldmethod=indent
set foldminlines=1
set foldlevel=100
set backspace=indent,eol,start
au GUIEnter * set vb t_vb=
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59
" set list

" Backup files in alternative directory
set backupdir-=.
set backupdir^=~/tmp,/tmp

colorscheme molokai
set guifont=Monaco:h15

"set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=bash

let @c='ggjGf x:%s/ #.*$//gvapJ'

nnoremap <Leader>[ :tabprevious<CR>
nnoremap <Leader>] :tabnext<CR>
nnoremap <silent> <Enter> :nohlsearch<Bar>:echo<CR>

augroup vimrc
autocmd!
"autocmd GuiEnter * set columns=120 lines=70 number
augroup END

" remove whistespace at end of line before write
func! StripTrailingWhitespace()
  normal mZ
  %s/\s\+$//e
  normal `Z
endfunc
au BufWrite * if ! &bin | call StripTrailingWhitespace() | endif

" Add syntax highlighting for rabl
au BufRead,BufNewFile *.rabl setf ruby

if has("autocmd")
  au BufRead,BufNewFile *.ejs setfiletype html
endif

au BufRead,BufNewFile *.hamlc setf haml

"Reload .vimrc after updating it
"if has("autocmd")
"  autocmd BufWritePost .vimrc source $MYVIMRC
"endif

set modeline
set modelines=5

let g:EasyMotion_leader_key = ','
nmap <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>n :set invnumber<CR>
nmap <leader>p :set paste!<CR>
nmap <leader>] :set mouse-=a<CR>
nmap <leader>[ :set mouse=a<CR>

nnoremap <Leader>h :h <C-r><C-w><CR>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Reload .vimrc after update
if has("autocmd")
  " autocmd BufWritePost .vimrc source $MYVIMRC
endif

map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> :tablast<CR>

" Map in insert mode as well
map! <D-1> 1gt
map! <D-2> 2gt
map! <D-3> 3gt
map! <D-4> 4gt
map! <D-5> 5gt
map! <D-6> 6gt
map! <D-7> 7gt
map! <D-8> 8gt
map! <D-9> :tablast<CR>

map <F3> :source $MYVIMRC<CR>:echoerr ".vimrc reloaded"<CR>

set showtabline=2

"" Search for visual selection
"xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
"xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
"
"function! s:VSetSearch()
"  let temp = @s
"  norm! gv"sy
"  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
"  let @s = temp
"endfunction

if has("gui_running")
  set background=dark
  set showtabline=2 " Always show the tab bar
  set lines=999 columns=999 " Start vim maximized
  set guioptions+=a guioptions+=P " Enable autocopy on select to system clipboard
endif

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" Rspec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
