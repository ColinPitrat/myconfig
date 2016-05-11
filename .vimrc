" First, clear any existing autocommands:
autocmd!

" ******************
" * User Interface
" ******************
" General colorscheme
syntax on
set background=light
colorscheme desert

" Display line and column
set ruler

" Backspace
set backspace=indent,eol,start
set t_kb=

" Have command-line completion <Tab> (for filenames, help topics, option names)
set wildmode=list:longest,full

" Keep some context
set scrolloff=2

" Display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

set loadplugins

" ******************
" * Auto  build
" ******************
autocmd BufWritePost * silent execute "!touch ~/.vimsaved"

" ****************************
" * Commands and behaving
" ****************************

" Treat lines starting with a quote mark as comments
set comments+=b:\"

command -nargs=* CVSannotate silent call CVSannotate("<args>")
function! CVSannotate(cvsversion)
    let filename=bufname("%")
    new
    execute "r!cvs annotate " . a:cvsversion . " " . filename
    1d
    set nomodified
endfunction

command CVSlog silent call CVSlog()
function! CVSlog()
    let filename=bufname("%")
    new
    execute "r!cvs log -N " filename
    1d
    set nomodified
endfunction

command -nargs=* CVSdiff silent call CVSdiff("<args>")
function! CVSdiff(cvsversion)
    diffthis
    let filename=bufname("%")
    vnew
    execute "r!cvs -q up -p " . a:cvsversion . " " . filename
    1d
    diffthis
    set nomodified
    au BufDelete <buffer> wincmd p | diffoff | wincmd p
endfunction

"Create function SVNdiff with svn cat -r <N> <file>
command -nargs=* SVNdiff silent call SVNdiff("<args>")
function! SVNdiff(...)
        let filename = bufname("%")
        execute "vertical diffsplit new"
        let svn_cmd="%!svn cat "
        for s in a:000
            let svn_cmd=svn_cmd . " " . s
        endfor
        let svn_cmd=svn_cmd . " " . filename
        echom "Will execute: " . svn_cmd
        execute svn_cmd
        execute "diffupdate"
endfunction

"Create function SVNlog with svn log <file>
command -nargs=0 SVNlog silent call SVNlog()
function! SVNlog(...)
        let filename = bufname("%")
        execute "split log"
        execute "%!svn log " . filename
endfunction
command -nargs=* HGannotate silent call HGannotate("<args>")
function! HGannotate(hgversion)
    let filename=bufname("%")
    new
    execute "r!hg annotate -r " . a:hgversion . " " . filename
    1d
    set nomodified
endfunction

command HGlog silent call HGlog()
function! HGlog()
    let filename=bufname("%")
    new
    execute "r!hg log " filename
    1d
    set nomodified
endfunction

command -nargs=* HGdiff silent call HGdiff("<args>")
function! HGdiff(cvsversion)
    diffthis
    let filename=bufname("%")
    vnew
    execute "r!hg cat " . a:cvsversion . " " . filename
    1d
    diffthis
    set nomodified
    au BufDelete <buffer> wincmd p | diffoff | wincmd p
endfunction

" ****************************
" * Text Formatting -- General
" ****************************
" Try to indent automagically
set autoindent

" Limit text width to 80 characters
"set textwidth=80

" Alias for ConqueTerm
command ShellVSplit ConqueTermVSplit bash
command ShellSplit ConqueTermSplit bash
command Shell ConqueTerm bash

" Show lines longer than 80 characters
command HideLinesTooLong hi clear LineTooLong
command ShowLinesTooLong hi LineTooLong term=bold cterm=bold gui=bold guibg=LightYellow
ShowLinesTooLong
autocmd BufWinEnter,Syntax * exe "match LineTooLong /\\%>80v.\\+/"
HideLinesTooLong

" Change tab into 4 spaces, and set indent to 4 spaces
set shiftwidth=2
set tabstop=2
set expandtab

" Enable filetype detection:
filetype on

" For Perl programming, have things in braces indenting themselves:
autocmd FileType perl set smartindent

" In makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make setlocal noexpandtab shiftwidth=8
autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
let python_highlight_indent_errors=1
let python_highlight_all=1
" Doesn't work, I don't know why
"autocmd FileType python hi SpacesInIndent ctermbg=yellow guibg=LightYellow
"autocmd FileType python exe "match SpacesInIndent /^\s* /"

command -nargs=0 CreatePyFile silent call CreatePyFile()
function! CreatePyFile()
        execute "i"
#!/usr/bin/python
# -*- coding: utf8 -*-"

endfunction
autocmd! BufNewFile *.py CreatePyFile

" Octave syntax 
augroup filetypedetect 
  au! BufRead,BufNewFile *.m,*.oct set filetype=octave 
augroup END 

" Use keywords from Octave syntax language file for autocomplete 
if has("autocmd") && exists("+omnifunc") 
   autocmd Filetype octave 
  \ if &omnifunc == "" | 
  \   setlocal omnifunc=syntaxcomplete#Complete | 
  \   endif 
endif 


" Handle SConstruct and SConscript as python files
autocmd BufNewFile,BufRead SConstruct setf python
autocmd BufNewFile,BufRead SConscript setf python
autocmd BufNewFile,BufRead *.log_otf* setf logobe
autocmd BufNewFile,BufRead *.tags setf tags

" ******************
" * Search & Replace
" ******************
" Make searches case-insensitive, unless they contain upper-case letters:
"set ignorecase
"set smartcase

" Show the `best match so far' as search strings are typed:
set incsearch
set hlsearch
set modeline

com SearchError exe "/\\.[ch]p*:\\d*: error\\|scons:.*[eE]rror\\|No such file or directory\\|Error executing gramgen\\|there is [0-9]* error"

set shell=/bin/bash
"set makeprg=bms\ build\ -b
"set errorformat=%*[^\"]\"%f\"%*\\D%l:\ %m,\"%f\"%*\\D%l:\ %m,%-G%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,%-G%f:%l:\ for\ each\ function\ it\ appears\ in.),%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file\ included\ from\ %f:%l:%c\\,,%-GIn\ file\ included\ from\ %f:%l:%c,%-GIn\ file\ included\ from\ %f:%l,%-G%*[\ ]from\ %f:%l:%c,%-G%*[\ ]from\ %f:%l:,%-G%*[\ ]from\ %f:%l\\,,%-G%*[\ ]from\ %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',%D%*\\a:\ Entering\ directory\ `%f',%X%*\\a:\ Leaving\ directory\ `%f',%DMaking\ %*\\a\ in\ %f,%f\|%l\|\ %m
set errorformat=%*[^\"]\"%f\"%*\\D%l:\ %m,\"%f\"%*\\D%l:\ %m,%-G%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,%-G%f:%l:\ for\ each\ function\ it\ appears\ in.),%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file\ included\ from\ %f:%l:%c\\,,%-GIn\ file\ included\ from\ %f:%l:%c,%-GIn\ file\ included\ from\ %f:%l,%-G%*[\ ]from\ %f:%l:%c,%-G%*[\ ]from\ %f:%l:,%-G%*[\ ]from\ %f:%l\\,,%-G%*[\ ]from\ %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,%Dmake:\ Entering\ directory\ `%f',%Xmake:\ Leaving\ directory\ `%f',%D%*\\a:\ Entering\ directory\ `%f',%X%*\\a:\ Leaving\ directory\ `%f',%DMaking\ %*\\a\ in\ %f,%f\|%l\|\ %m
if hostname() == "ncegcolnx138"
  set makeprg=~intscs/delivery/bms/beta/bms\ build\ -t
endif

"set nocp
filetype plugin on
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" match pairs of < and >
autocmd FileType cpp set mps+=<:>

" YouCompleteMe configuration
"let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"
let g:ycm_error_symbol = '->'
let g:ycm_warning_symbol = '>'

" Set Ctrl-u to uppercase the current word (usefull for macros)
inoremap <c-u> <esc>mpllbmbhelme`bgU`e`pa
