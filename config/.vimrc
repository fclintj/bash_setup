"" ┌───────────────────┐
"" │    vimrc setup    │
"" └───────────────────┘

    set encoding=utf-8 " set encoding displayed 
    set nu             " set numbers
    set wrapmargin=0   " set width of number margins
    set tabstop=4      " set characters in tab
    set softtabstop=4  " num spaces for tab 
    set shiftwidth=4   " num of spaces for indentation
    set smartindent    " reacts to the syntax/style of file
    set expandtab      " insert spaces instead of tab
    set linebreak      " wrap full words to next line
    set breakindent    " indent wrapped line
    set showbreak=...  " adds "..." at wrapped line
    set noruler        " set row and col number at bottom
    set undofile       " maintain undo history between sessions
    set undodir=~/.vim/undodir " set file path for undodir
    " set foldmethod=manual " set nocompatible
    set foldmethod=indent " manual (zf), indent, syntax, expr, marker 
    set ignorecase     " will search case insensitive if all lowercase 
    set smartcase      " if string includes Cap then sensitive 
                       " /copyright\C " Case sensitive 
    set display+=lastline " show as much as possible of last line 
    set nocompatible
    set clipboard=unnamed    


"" ┌───────────────────┐
"" │  restore cursor   │
"" └───────────────────┘
    set viminfo='10,\"100,:20,%,n~/.viminfo
    function! ResCur()
      if line("'\"") <= line("$")
        normal! g`"
        return 1
      endif
    endfunction

    augroup resCur
      autocmd!
      autocmd BufWinEnter * call ResCur()
    augroup END

    
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
    "" "zg" adds word "zw" removes word from dictionary. "z=" gives word options 
    inoremap <C-K> <Esc>[s1z=
    inoremap <C-J> <Esc>]s1z=

"" ┌───────────────────┐
"" │     pathogen      │
"" └───────────────────┘

    execute pathogen#infect()  
    syntax on
    filetype plugin indent on
    let g:auto_save = 1 " enable AutoSave on vim startup
    let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py" " c++ semantics
    let g:ycm_key_list_select_completion=[]     " ycm uses ctrl+n for next
    let g:ycm_key_list_previous_completion=[]   " ycm uses ctrl+p for previous
    set completeopt-=preview        " turn off [preview] for ycm
    let g:ycm_always_populate_location_list = 1 " filter through errors
    noremap <c-n> :lne <CR>
    autocmd FileType c,cpp,java setlocal commentstring=//\ %s " set comment as // for c and cpp
    let g:vimwiki_list = [{'path' : '/mnt/CE6C52926C527565/Users/clint/Google\ Drive/dev/vimwiki'}]  " set new default vimwiki folder 
    " setup DirDiff excluded files
    let g:DirDiffExcludes = ".git*,.swp"

    " allow grammar check on entire document
    let g:languagetool_jar='$HOME/.vim/bundle/vim-LanguageTool/languagetool-commandline.jar'
    let g:languagetool_lang='en'
    let g:languagetool_disable_rules='COMMA_PARENTHESIS_WHITESPACE,WHITESPACE_RULE,EN_QUOTES'
    let g:ycm_python_binary_path = 'python'

    " " copy text from vim to other tmux pane
    nnoremap <C-c><C-c> :SlimuxREPLSendLine<CR>
    vnoremap <C-c><C-c> :SlimuxREPLSendSelection<CR>
    nnoremap <C-c><C-v> :SlimuxREPLConfigure<CR>    
    
"" ┌────────────────────┐
"" │ search/replace all │
"" └────────────────────┘

    "" in visual mode, press ctrl+r, type, and accept with y/n
    vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"" ┌───────────────────┐
"" │   build programs  │
"" └───────────────────┘

    " Build a latex environment with new command
    :command ResaerchPaper !~/.latex/scripts/research_paper.sh

    "" export vim console to HTML
    noremap <F3> :w<CR> :%TOhtml<CR>:x <CR> 
    inoremap <F3> <ESC> :w<CR> :make<CR> <CR> 

    "" debug c program with CounqueGDB
    noremap <F5> :w<CR> :!clear;bash ~/.vim/make_prog.sh %<CR> :ConqueGdb  "../build/%<"<CR> 
    let g:ConqueTerm_StartMessages = 0
    let g:ConqueTerm_Color = 0
    let g:ConqueTerm_CloseOnEnd = 1
    let g:ConqueTerm_Interrupt = '<C-g><C-c>'
    let g:ConqueTerm_ReadUnfocused = 1

    "" make program from terminal―to add blank "params" file, add "echo -n >params" to file
    noremap <F9> :w<CR> :!clear;bash ~/.vim/make_prog.sh %<CR>
    inoremap <F9> <ESC> :w<CR> :!clear;bash ~/.vim/make_prog.sh %<CR>

    "" run program automatically from terminal 
    noremap <F10> :w<CR>:silent !clear<CR>:!~/.vim/run_prog.sh %<CR>
    inoremap <F10> <ESC> :w<CR>:silent !clear<CR>:!~/.vim/run_prog.sh %<CR>
    
    "" run program automatically from terminal 
    noremap <F12> :w<CR>:silent !clear<CR>:!~/.vim/build_ros.sh %:p<CR>
    inoremap <F12> <ESC> :w<CR>:silent !clear<CR>:!~/.vim/build_ros.sh %:p<CR>

    "" read ctags even if they are created in hidden file
    set tags=./tags;,tags;./.tags;,.tags;

"" ┌───────────────────┐
"" │ general commands  │
"" └───────────────────┘
    "" break line up into readable lengths
    map tw vipgqvipgc
    "" join broken line with comments into single paragraph
    map tj vipgcvipJvipgc
    vnoremap <C-y> "+y 
    nnoremap <C-y>y "+yy
    nnoremap <C-P> "+P 
    map g= mzgg=G`z 
    imap <m-b> <right>
