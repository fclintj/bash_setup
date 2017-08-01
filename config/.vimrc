"" ┌───────────────────┐
"" │    vimrc setup    │
"" └───────────────────┘

    set nu             " set numbers
    set wrapmargin=0   " set width of number margins
    set tabstop=4      " set characters in tab
    set shiftwidth=4   " num of spaces for indentation
    set expandtab      " insert spaces instead of tab
    set linebreak      " wrap full words to next line
    set breakindent    " indent wrapped line
    set showbreak=...  " adds "..." at wrapped line
    set noruler        " set row and col number at bottom
    set undofile       " maintain undo history between sessions
    set undodir=~/.vim/undodir
    set foldmethod=indent 
     "":set mouse=a


"" ┌───────────────────┐
"" │    theme setup    │
"" └───────────────────┘

    syntax enable       " set darcula dark theme 
    colorscheme darcula

    :highlight LineNr ctermfg=DarkGrey guifg=DarkGrey " over-ride num highlighting

"" ┌───────────────────┐
"" │    spell check    │
"" └───────────────────┘

    :setlocal spell spelllang=en_us " to turn off inline type :set nospell
    "" ctrl+j auto-correct next word, ctrl+k previous word
    noremap <C-K> <Esc>[s1z=
    noremap <C-J> <Esc>]s1z=
    "" "zg" adds word "zw" removes word from dictionary. "z+" gives word options 
    inoremap <C-K> <Esc>[s1z=
    inoremap <C-J> <Esc>]s1z=

"" ┌───────────────────┐
"" │     pathogen      │
"" └───────────────────┘

    execute pathogen#infect()  
    syntax on
    filetype plugin indent on
    map <C-b> :NERDTreeToggle <CR>
    let g:auto_save = 1 " enable AutoSave on vim startup
    let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py" " c++ semantics
    let g:ycm_filetype_blacklist = {
          \ 'tex' : 1}
    let g:ycm_key_list_select_completion=[]     " ycm uses ctrl+n for next
    let g:ycm_key_list_previous_completion=[]   " ycm uses ctrl+p for previous
    set completeopt-=preview        " turn off [preview] for ycm
    let g:ycm_always_populate_location_list = 1 " filter through errors
    noremap <c-n> :lne <CR>
    autocmd FileType c,cpp,java setlocal commentstring=//\ %s " set comment as // for c and cpp

"" ┌────────────────────┐
"" │ search/replace all │
"" └────────────────────┘

    "" in visual mode, press ctrl+v, type, and accept with y/n
    vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"" ┌───────────────────┐
"" │   build programs  │
"" └───────────────────┘

    "" export vim console to html
    noremap <F3> :w<CR> :%TOhtml<CR>:x <CR> 
    inoremap <F3> <ESC> :w<CR> :make<CR> <CR> 

    "" build latex document
    noremap <F4> :w<CR> :!xelatex -output-directory=output %<CR> <CR>
    inoremap <F4> <ESC> :w<CR> :!xelatex -output-directory=output %<CR> <CR>

    "" debug c program with CounqueGDB
    noremap <F5> :w<CR> :make<CR> :ConqueGdb  "%<"<CR> 
    let g:ConqueTerm_StartMessages = 0
    let g:ConqueTerm_Color = 0
    let g:ConqueTerm_CloseOnEnd = 1
    let g:ConqueTerm_Interrupt = '<C-g><C-c>'
    let g:ConqueTerm_ReadUnfocused = 1

    "" make program from terminal―to add blank "params" file, add "echo -n >params" to file
    noremap <F9> :w<CR> :!clear;bash ~/.vim/cpMakefile.sh %<CR>:!make<CR>
    inoremap <F9> <ESC> :w<CR> :!clear;bash ~/.vim/cpMakefile.sh %<CR>:!make<CR>

    "" run program automatically from terminal 
    noremap <F10> :w<CR>:silent !clear<CR>:!~/.vim/run_prog.sh %<CR>
    inoremap <F10> <ESC> :w<CR>:silent !clear<CR>:!~/.vim/run_prog.sh %<CR>

"" ┌───────────────────┐
"" │ general commands  │
"" └───────────────────┘
"" break line up into readable lengths
map tw vipgqvipgc
"" join broken line with comments into single paragraph
map tj vipgcvipJvipgc

