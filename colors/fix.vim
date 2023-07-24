" Fix magenta Pmenu:
hi Pmenu     ctermbg=8 ctermfg=15
hi PmenuSel  ctermbg=7 ctermfg=0
" Nicer styles:
hi LineNr        ctermbg=8 ctermfg=15
hi StatusLine    ctermbg=7 ctermfg=0 cterm=NONE
hi StatusLineNC  ctermbg=8 ctermfg=15 cterm=NONE

" Make diff highlighting emulate `git show`:
"
" - best-effort, might be missing something
" - currently not touching gitHead
hi diffFile       cterm=bold ctermfg=none
hi diffIndexLine  cterm=bold ctermfg=none
hi diffOldFile    cterm=bold ctermfg=none
hi diffNewFile    cterm=bold ctermfg=none
hi diffLine       ctermfg=6
hi diffSubname    cterm=none ctermfg=none
hi diffAdded      ctermfg=2
hi diffRemoved    ctermfg=9
