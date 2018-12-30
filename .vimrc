""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1 支持c/c++
" 主要插件学习 文件工程学习
" 折叠功能的实验 快捷键为 ，zz
" undo && redo ---- shortcut: u cltr+R
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 修改leader键
let mapleader = ','
let g:mapleader = ','

if v:progname =~? "evim"
finish
endif

if has('mouse')
set mouse=a
endif

set nocompatible
set backspace=eol,start,indent
syntax enable
syntax on
set number
set history=800	
set ruler
set showcmd
set showmode
set scrolloff=5
set novisualbell
set laststatus=2
autocmd FileType text setlocal textwidth=80
set magic
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} " 我的状态行显示的内容（包括文件类型和解码）

" 现在使用主题为zenburn 
" molokai
colorscheme molokai
let g:molokai_original = 1
" solarized
" set background=dark
"colorscheme solarized
set cursorcolumn
set cursorline
"desert
set t_Co=256
" colorscheme zenburn

" 取消换行。
set nowrap
"set whichwrap+=<,>,[,]

" 文件编码
set ffs=unix,dos,mac
let &termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936
set encoding=utf-8 " 设置新文件的编码为 UTF-8

" 自动补全配置
"set completeopt=longest,menu
" " 增强模式中的命令行自动完成操作
" set wildmenu
" " Ignore compiled files
" set wildignore=*.o,*~,*.pyc,*.class,*.swp,*.bak,*.pyc,.svn

"搜索和匹配
set showmatch "高亮显示匹配的括号
set matchtime=5 "匹配括号高亮的时间（单位是十分之一秒）
set nohls "关闭‘查找’高亮显示
set hlsearch "高亮被搜索的句子（phrases）
set incsearch " 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set smartcase "ignore case if search pattern is all lowercase, case-sensitive otherwise " 有一个或以上大写字母时仍大小写敏感
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " 输入:set list命令是应该显示些啥？
"set ignorecase "在搜索的时候忽略大小写

"文件类型
filetype on "侦测文件类型
filetype plugin on "载入文件类型插件
filetype indent on "为特定文件类型载入相关缩进文件
filetype plugin indent on
set confirm "在处理为保存或只读文件时，弹出确认
set autoread "文件修改之后自动载入

"tab相关变更
set tabstop=4 " 设置Tab键的宽度 [等同的空格个数]
set shiftwidth=4 " 每一次缩进对应的空格数
set softtabstop=4 " 按退格键时可以一次删掉 4 个空格
set smarttab " insert tabs on the start of a line according to shiftwidth, not tabstop 按退格键时可以一次删掉 4 个空格/ 在行和段开始处使用制表符
set expandtab " 将Tab自动转化成空格 [需要输入真正的Tab键时，使用 Ctrl+V + Tab]
set shiftround " 缩进时，取整 use multiple of shiftwidth when indenting with '<' and '>'
"set noexpandtab " 不要用空格代替制表符

"代码折叠
set foldenable
set foldmethod=indent
set foldlevel=99
"manual--手工折叠 || indent--缩进表示折叠 || expr 表达式定义折叠
"syntax 语法定义折叠 || diff 对没有更改的文本进行折叠
"marker 使用标记进行折叠, 默认标记是 {{{ 和 }}}
" 代码折叠自定义快捷键
let g:FoldMethod = 0
map <leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun

"缩进配置
set autoindent "继承前一行的缩进方式，特别适用于多行注释
set smartindent "为C程序提供自动缩进
set cindent " 使用C样式的缩进

"create undo file
if has('persistent_undo')
  set undolevels=1000         " How many undos
  set undoreload=10000        " number of lines to save for undo
  set undofile                " So is persistent undo ...
  set undodir=/tmp/vimundo/
endif

" 备份,到另一个位置. 防止误删, 目前是取消备份
"set backup
"set backupext=.bak
"set backupdir=/tmp/vimbk/
" 不要生成swap文件，当buffer被丢弃的时候隐藏它
setlocal noswapfile
set nobackup " 取消备份
set bufhidden=hide

"去掉输入错误的提示声音
set noerrorbells
set novisualbell
set t_vb=
set tm=500
"在执行宏命令时，不进行显示重绘；在宏命令执行完成后，一次性重绘，以便提高性能。
set lazyredraw
"自动格式化
"set formatoptions=tcrqn
set fillchars=vert:\ ,stl:\ ,stlnc:\ " 在被分割的窗口间显示空白，便于阅读

"设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制
"好处：误删什么的，如果以前屏幕打开，可以找回
"set t_ti= t_te=

"设置session
set sessionoptions-=curdir
set sessionoptions+=sesdir
map Q gq

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 新建.c,.h,.sh,.java文件，自动插入文件头/FileType Settings 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
" 定义函数SetTitle，自动插入文件头 
functio! SetTitle() 
	if (&filetype == 'sh') 
		call setline(1,"\#!/bin/bash") 
		call append(line("."), "") 
    elseif (&filetype == 'python')
        call setline(1,"#!/usr/bin/env python")
        call append(line("."),"# coding=utf-8")  "to python2
	    call append(line(".")+1, "") 

    elseif (&filetype == 'ruby')
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
	    call append(line(".")+1, "")

"    elseif &filetype == 'mkd'
"        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
	else 
		call setline(1, "/*************************************************************************") 
		call append(line("."), "	> File Name: ".expand("%")) 
		call append(line(".")+1, "	> Author: jekor") 
		call append(line(".")+2, "	> Mail: hike2048 AT 163 DOT com") 
		" call append(line(".")+3, "	> Created Time: ".strftime("%c")) 
        call append(line(".")+3, "	> Created Time: ".strftime("%d/%m/%y\ -\ %H:%M")) 
		call append(line(".")+4, " ************************************************************************/") 
		call append(line(".")+5, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+6, "#include<iostream>")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+8, "#endif")
	endif
	if &filetype == 'java'
		call append(line(".")+6,"public class ".expand("%:r"))
		call append(line(".")+7,"")
	endif
	"新建文件后，自动定位到文件末尾
endfunc 
autocmd BufNewFile * normal G

" Python 文件的一般设置，比如不要 tab 等
autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai

" 保存python文件时删除多余空格
"fun! <SID>StripTrailingWhitespaces()
"    let l = line(".")
"    let c = col(".")
"    %s/\s\+$//e
"    call cursor(l, c)
"endfun
"autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 只在下列文件类型被侦测到的时候显示行号，普通文本文件不显示
if has("autocmd")
filetype plugin indent on
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "normal g`\"" |
\ endif
endif " has("autocmd")
if !exists(":DiffOrig")
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
\ | wincmd p | diffthis
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" shortcut ==> F1 - F6 设置 || vimrc || <C-n> || wrap ,zz
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"F1 废弃,防止调出系统帮助
"F2 行号开关，用于鼠标复制代码用
"F3 显示可打印字符开关
"F4 换行开关
"F5 粘贴模式paste_mode开关,用于有格式的代码粘贴
"F6 语法开关，关闭语法可以加快大文件的展示
"F7 C，C++, shell, python, javascript, ruby... 
inoremap <C-U> <C-G>u<C-U>
noremap <F1> <Esc>
function! HideNumber()
if(&relativenumber == &number)
set relativenumber! number!
elseif(&number)
set number!
else set relativenumber!
endif
set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>
nnoremap <F3> :set list! list?<CR>
nnoremap <F4> :set wrap! wrap?<CR>
set pastetoggle=<F5>
au InsertLeave * set nopaste
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>

"分屏窗口移动 使用<C-j>代替<C-w>+j(减少按键)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"快速编辑vimrc  编辑vimrc ,ee ;; 加载vimrc ,ss
"Set mapleader
"let mapleader = ","
"Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" 命令行模式增强，ctrl - a到行首， -e 到行尾
"cnoremap <C-a> <Home>
"cnoremap <C-e> <End>

" remap U to <C-r> for easier redo
"nnoremap U <C-r>

"C，C++, shell, python, javascript, ruby...等按F7运行
map <F7> :call CompileRun()<CR>
func! CompileRun()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -o %<"
        exec "!time ./%<"
        exec "!rm ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
        exec "!rm ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
        exec "!rm ./%<.class"
    elseif &filetype == 'sh'
        exec "!time bash %"
    elseif &filetype == 'python'
        exec "!time python3 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd' "MarkDown 解决方案为VIM + Chrome浏览器的MarkDown Preview Plus插件，保存后实时预览
        exec "!firefox % &"
    elseif &filetype == 'javascript'
        exec "!time node %"
    elseif &filetype == 'coffee'
        exec "!time coffee %"
    elseif &filetype == 'ruby'
        exec "!time ruby %"
    endif
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Vim插件管理——BundleInstall/BundleList/BundleClean
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let $BUNDLE = expand("$HOME/.vim/bundle")
let $PLUG_DIR = expand("$BUNDLE/vim-plug")

if empty(glob(expand("$PLUG_DIR/plug.vim")))
  silent !curl -fLo $PLUG_DIR/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif
source $PLUG_DIR/plug.vim

call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-easymotion'
Plug 'bling/vim-airline'
Plug 'Valloric/YouCompleteMe'
Plug 'w0rp/ale'
Plug 'kien/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'skywind3000/quickmenu.vim'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""
"==>YCM 代码自动补全(statues:85%)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"重启 :YcmRestartServer
"" using system default python3 cause conflict with conda
" @see https://github.com/Valloric/YouCompleteMe/issues/1241#issuecomment-335051278
let g:ycm_path_to_python_interpreter = "/usr/bin/python"

let g:ycm_disable_for_files_larger_than_kb = 1024
let g:ycm_confirm_extra_conf=0 " 关闭加载.ycm_extra_conf.py提示
let g:ycm_complete_in_comments = 1 "注释输入补全
let g:ycm_complete_in_strings = 1 "字符串输入补全
let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
let g:ycm_collect_identifiers_from_comments_and_strings = 1 "注释和字符串中的文字也会被收入补全
let g:ycm_seed_identifiers_with_syntax=1 "语言关键字补全, 不过python关键字都很短，所以，需要的自己打开
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项

" 引入，可以补全系统，以及python的第三方包 针对新老版本Y什么情况啊 YCM做了兼容
" old version
if !empty(glob("~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py"))
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py"
endif
" new version
if !empty(glob("~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"))
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
endif
" 黑名单,不启用
let g:ycm_filetype_blacklist = {
\ 'tagbar' : 1,
\ 'gitcommit' : 1,
\}
" 跳转到定义处, 分屏打开
let g:ycm_goto_buffer_command = 'horizontal-split'
" nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gd :YcmCompleter 	<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"==>设置ale
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

let g:ale_sign_error = "\ue009\ue009"
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! SpellBad gui=undercurl guisp=red
hi! SpellCap gui=undercurl guisp=blue
hi! SpellRare gui=undercurl guisp=magenta


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"==>设置airline状态栏(statues:95%)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
"let g:airline_enable_branch = 1
"let g:airline_extensions_syntastic = 1
set nocompatible
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_left_alt_sep = '❯'
let g:airline_right_alt_sep = '❮'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '◀'
"let g:airline_symbols.linenr = '␊'
""let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'
"set enc=utf-8
let termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936
