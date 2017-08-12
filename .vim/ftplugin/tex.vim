set showbreak=  " adds "..." at wrapped line

" Navigate up and down visually
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Set preset commands
:command ResaerchPaper !~/.latex/scripts/research_paper.sh
:command GeneralDoc !~/.latex/scripts/general_doc.sh

