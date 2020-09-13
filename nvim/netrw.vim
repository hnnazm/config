" ===============================================
"  Netrw (vim file browsing)
" ===============================================
"  :help netrw-quickmap

   let g:netrw_banner = 0                  " disable annoying banner
   let g:netrw_winsize = 30                " window size
   let g:netrw_browse_split = 0            " open in prior tab
   let g:netrw_altv = 1                    " open splits to the right
   let g:netrw_liststyle = 0               " wide list view
   let g:netrw_keepdir= 0
   let g:netrw_browsex_viewer = "open"     " open with special
   let g:netrw_sort_by = "exten"
   let g:netrw_sort_direction = "reverse"
   let g:netrw_sort_options = "i"          " sorting
   let g:netrw_list_hide = netrw_gitignore#Hide()
   let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

   let g:NetrwIsOpen=0

   function! ToggleNetrw()
       if g:NetrwIsOpen
           let i = bufnr("$")
           while (i >= 1)
               if (getbufvar(i, "&filetype") == "netrw")
                   silent exe "bwipeout " . i 
               endif
               let i-=1
           endwhile
           let g:NetrwIsOpen=0
       else
           let g:NetrwIsOpen=1
           silent Lexplore
       endif
   endfunction

   function! OpenToRight()
       :normal v
       let g:path=expand('%:p')
       :q!
       execute 'belowright vnew' g:path
       :normal <C-w> l
     endfunction
   
     function! OpenBelow()
       :normal v
       let g:path=expand('%:p')
       :q!
       execute 'belowright new' g:path
       :normal <C-w> l
     endfunction
   
   function! NetrwMappings()
         noremap <buffer> V :call OpenToRight()<cr>
         noremap <buffer> H :call OpenBelow()<cr>
     endfunction
   
     augroup netrw_mappings
         autocmd!
         autocmd filetype netrw call NetrwMappings()
     augroup END

"  Keymap
   noremap <silent> <Leader>m :call ToggleNetrw()<CR>
