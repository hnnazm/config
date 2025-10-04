command! CopyFilePath call directory#CopyFilePath()
command! ChangeToFileDir call directory#ChangeToFileDir()

nnoremap <Leader>cc :CopyFilePath<CR>
nnoremap <Leader>cd :ChangeToFileDir<CR>
