" Add numbers to each line on the left-hand side
set number

" Change background and color for line number on the left side
" ctermbg=white
highlight LineNr ctermfg=darkgrey

" For YAML files we set Auto Indent, Expand Tabs to spaces,
" Tab Stop to 2 spaces, Shift Width to 2 spaces used by auto
" indent, column highlighting and underlining
autocmd FileType yaml setlocal ai et ts=2 sw=2 "cuc cul
