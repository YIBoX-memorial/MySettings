"-------------------------------- set line number --------------------------------
set nu

"-------------------------------- set  mouseclick --------------------------------
set mouse=a

"--------------------------------     set tab     --------------------------------
" tab = 4
set ts=4
" use tab instead of space, in python only space is allowed
set noexpandtab
%retab!

"--------------------------------  set clipboard  --------------------------------
vmap <C-c> "+y
vmap <C-v> "+pg

"--------------------------------   set  indent   --------------------------------
set shiftwidth=4
set autoindent
set smartindent

"--------------------------------  set highlight  --------------------------------
" highlight search content
set hlsearch
" highlight current line
set cursorline

"--------------------------------   set  cursor   --------------------------------
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Only one call can avoid bugs
"--------------------------------     vim-plug    --------------------------------
call plug#begin('~/.vim/plugged')
"--------------------------------   set gruvbox   --------------------------------
Plug 'taigacute/gruvbox9'
" set background transparent
let g:gruvbox_transp_bg = 1
" enable italic
let g:gruvbox_italic = 1

"--------------------------------   set airline   --------------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" set airline theme
let g:airline_theme='term_light'
let g:airline_powerline_fonts=1
let g:airline_left_sep = '' " ''
let g:airline_right_sep = '' " ''

"--------------------------------   set  vimtex   --------------------------------
" call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex', { 'for': 'tex' }
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
" vimtex completion
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1
" let g:vimtex_complete_bib=1
" let g:vimtex_compiler_latexmk = {
"     \ 'options' : [
"     \   '-xelatex',
"     \   '-verbose',
"     \   '-file-line-error'  ,
"     \   '-synctex=1',
"     \   '-interaction=nonstopmode',
"     \ ],
"     \}

"--------------------------------  set  template  --------------------------------
" tababit
Plug 'tibabit/vim-templates'

call plug#end()

"-------------------------------- set tex-preview --------------------------------
" A Vim Plugin for Lively Previewing LaTeX PDF Output
" Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" let g:livepreview_previewer = 'zathura'
" call plug#end()
" <F12> = preview
" nmap <F12> :LLPStartPreview<cr>



"--------------------------------   set  bundle   --------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"--------------------------------   set snippet   --------------------------------
" Track the engine.
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-d>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plugin 'ycm-core/YouCompleteMe'
call vundle#end()            " required
filetype plugin indent on    " required

"--------------------------------    set color    --------------------------------
" use this command to adopt dark scheme
" set bg=dark
colorscheme gruvbox9


"--------------------------------   set compile   --------------------------------

func! CompileGcc()
    exec "w"
    let compilecmd="!gcc "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpicc "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc
func! CompileGpp()
    exec "w"
    let compilecmd="!g++ "
    let compileflag="-o %< "
    if search("mpi\.h") != 0
        let compilecmd = "!mpic++ "
    endif
    if search("glut\.h") != 0
        let compileflag .= " -lglut -lGLU -lGL "
    endif
    if search("cv\.h") != 0
        let compileflag .= " -lcv -lhighgui -lcvaux "
    endif
    if search("omp\.h") != 0
        let compileflag .= " -fopenmp "
    endif
    if search("math\.h") != 0
        let compileflag .= " -lm "
    endif
    exec compilecmd." % ".compileflag
endfunc

func! RunPython()
        exec "!python3 %"
endfunc
func! CompileJava()
    exec "!javac %"
endfunc


func! CompileCode()
        exec "w"
        if &filetype == "cpp"
                exec "call CompileGpp()"
        elseif &filetype == "c"
                exec "call CompileGcc()"
        elseif &filetype == "python"
                exec "call RunPython()"
        elseif &filetype == "java"
                exec "call CompileJava()"
        endif
endfunc

func! RunResult()
        exec "w"
        if search("mpi\.h") != 0
            exec "!mpirun -np 4 ./%<"
        elseif &filetype == "cpp"
            exec "! ./%<"
        elseif &filetype == "c"
            exec "! ./%<"
        elseif &filetype == "python"
            exec "call RunPython"
        elseif &filetype == "java"
            exec "!java %<"
        endif
endfunc

map <F5> :call CompileCode()<CR>
imap <F5> <ESC>:call CompileCode()<CR>
vmap <F5> <ESC>:call CompileCode()<CR>
