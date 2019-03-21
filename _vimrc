"set autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set laststatus=2
set cmdheight=2
set showcmd
set title
set wildmenu
set number

"set fileencodings
:set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
:set fileformats=unix,dos,mac

"Run
autocmd MyAutoCmd BufNewFile,BufRead *.rb nnoremap <C-e> :!ruby %<CR>
autocmd MyAutoCmd BufNewFile,BufRead *.py nnoremap <C-e> :!python3 %<CR>
"autocmd MyAutoCmd BufNewFile,BufRead *.cpp nnoremap <C-e> :!g++ -std=c++11 % && ./a.out < input.txt<CR>
autocmd MyAutoCmd BufNewFile,BufRead *.cpp nnoremap <C-e> :!make<CR>
autocmd MyAutoCmd BufNewFile,BufRead *.c nnoremap <C-e> :!g++ -std=c++11 % && ./a.out<CR>
autocmd MyAutoCmd BufNewFile,BufRead *.lisp nnoremap <C-e> :!clisp -i %<CR>

"Search
set ignorecase
set smartcase 
set incsearch 
set hlsearch  
noremap <ESC><ESC> :noh<CR>

" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

"編集関連"
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする
                                                                    
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    " set clipboard& clipboard+=unnamedplus " 2013-07-03 14:30 unnamed 追加
    set clipboard& clipboard+=unnamedplus,unnamed 
else
    " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
    set clipboard& clipboard+=unnamed
endif

" disable swap file
set nowritebackup
set nobackup
set noswapfile

" display setting
set number
set nowrap

" disable screen bell
set t_vb=
set novisualbell
set listchars=

"マクロ関連"
inoremap jj <Esc>
inoremap JJ <Esc>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
"nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction

"NeoBundle"
set nocompatible
if has('vim_starting')
  set runtimepath+=~/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/bundle/'))
"インストールするプラグイン
"unite.vimとvimprocがインストールされていると非同期でプラグインがアップデートできる。
NeoBundleFetch 'Shougo/neobundle.vim'
let g:neobundle_default_git_protocol='https'
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build' : {
            \     'windows' : 'tools\\update-dll-mingw',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'linux' : 'make',
            \     'unix' : 'gmake',
            \    },
            \ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tyru/caw.vim'
NeoBundle "t9md/vim-quickhl"
NeoBundle "ctrlpvim/ctrlp.vim"
"NeoBundle "tpope/vim-rails"
"NeoBundle "basyura/unite-rails"
"NeoBundle "mattn/emmet-vim"
"NeoBundle "cohama/lexima.vim"
NeoBundle "tpope/vim-fugitive"
NeoBundle 'easymotion/vim-easymotion'
NeoBundle "kmnk/vim-unite-giti"
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'hewes/unite-gtags'
NeoBundle 'kovisoft/slimv'

call neobundle#end()

"Unite.vim"
noremap <C-N> :Unite buffer<CR>
noremap <silent>um :Unite file_mru<CR> 
noremap <silent>uo :Unite outline<CR>
noremap <silent>ub :Unite bookmark<CR>
noremap <silent>ur :Unite gtags/ref<CR><c-r>=expand("<cword>")<CR><CR>
noremap <silent>ug :Unite gtags/grep<CR>
noremap <silent>ucg :Unite gtags/grep<CR><c-r>=expand("<cword>")<CR><CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

"caw
nmap \c <Plug>(caw:I:toggle)
vmap \c <Plug>(caw:I:toggle)
nmap \C <Plug>(caw:I:uncomment)
vmap \C <Plug>(caw:I:uncomment)

" quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

" Ctrl p
"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" easymotion
nmap s <Plug>(easymotion-s)

"Neo snippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"gtags
map <C-g> :Gtags -g
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

let g:neosnippet#snippets_directory='~/bundle/neosnippet-snippets/snippets/'

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:slimv_repl_split = 4
let g:slimv_repl_name = 'REPL'
let g:slimv_repl_simple_eval = 0
let g:slimv_lisp = '/usr/local/bin/ros run'
let g:slimv_impl = 'sbcl'
let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"ros run --load $HOME/.roswell/lisp/slime/2018.09.30/start-swank.lisp\""'
let g:paredit_electric_return = 0
let g:paredit_matchlines = 0

let g:lisp_rainbow=1

autocmd BufNewFile,BufRead *.asd set filetype=lisp

filetype plugin indent on
