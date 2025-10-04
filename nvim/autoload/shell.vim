function! shell#SaveShellOutputToRegister() range abort
  if mode() ==# 'v' || mode() ==# 'V'
    normal! `<
    let start = line("'<")
    let end = line("'>")
    let lines = getline(start, end)
  else
    let lines = [getline('.')]
  endif

  let cmd = join(lines, "\n")
  let output = system(cmd)
  let @r = substitute(output, '\n\+$', '', '')
endfunction

function! shell#RunInTerminalTab() range abort
  if mode() ==# 'v' || mode() ==# 'V'
    normal! `<
    let start = line("'<")
    let end = line("'>")
    let lines = getline(start, end)
  else
    let lines = [getline('.')]
  endif

  let cmd = join(lines, "\n")

  tabnew
  call termopen(['bash', '-c', cmd])
  startinsert
endfunction
