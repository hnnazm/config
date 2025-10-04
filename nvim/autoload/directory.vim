function! directory#CopyFilePath() abort
  let file_path = expand('%:p')
  if file_path == ''
    echo 'No file path available'
    return
  endif
  let @+ = file_path
  echo 'Copied: ' . file_path
endfunction

function! directory#ChangeToFileDir() abort
  let file_dir = expand('%:p:h')
  if file_dir == ''
    echo 'No directory available'
    return
  endif

  let current_dir = getcwd(0)
  if fnamemodify(file_dir, ':p') == fnamemodify(current_dir, ':p')
    exec 'lcd -'
    echo 'Changed to previous directory'
    return
  endif

  exec 'lcd ' . fnameescape(file_dir)
  echo 'Changed directory to: ' . file_dir
endfunction
