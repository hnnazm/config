" ===============================================
"  Utilities
" ===============================================

" Floating Window -----------------------------{{{

"" This function originates from https://www.reddit.com/r/neovim/comments/eq1xpt/how_open_help_in_floating_windows/; it isn't mine
"function! CreateCenteredFloatingWindow() abort
"    let width = min([&columns - 4, max([80, &columns - 20])])
"    let height = min([&lines - 4, max([20, &lines - 10])])
"    let top = ((&lines - height) / 2) - 1 let left = (&columns - width) / 2 let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
"
"    let top = "╭" . repeat("─", width - 2) . "╮"
"    let mid = "│" . repeat(" ", width - 2) . "│"
"    let bot = "╰" . repeat("─", width - 2) . "╯"
"    let lines = [top] + repeat([mid], height - 2) + [bot]
"    let s:buf = nvim_create_buf(v:false, v:true)
"    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
"    call nvim_open_win(s:buf, v:true, opts)
"    set winhl=Normal:Floating
"    let opts.row += 1
"    let opts.height -= 2
"    let opts.col += 2
"    let opts.width -= 4
"    let l:textbuf = nvim_create_buf(v:false, v:true)
"    call nvim_open_win(l:textbuf, v:true, opts)
"    au BufWipeout <buffer> exe 'bw '.s:buf
"    return l:textbuf
"endfunction
"
"function! FloatingWindowHelp(query) abort
"    let l:buf = CreateCenteredFloatingWindow()
"    call nvim_set_current_buf(l:buf)
"    setlocal filetype=help
"    setlocal buftype=help
"    execute 'help ' . a:query
"endfunction
"
"command! -complete=help -nargs=? Help call FloatingWindowHelp(<q-args>)

" }}}

" Scrach buffer -------------------------------{{{
  function! Scratch()
      split
      noswapfile hide enew
      setlocal buftype=nofile
      setlocal bufhidden=hide
      setlocal nobuflisted
      setlocal readonly
  "lcd ~
  "file scratch
  endfunction

" }}}

" Vimscript file settings -------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Macro all line {{{
  xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
  " }}}


  " Quick search in current buffer
    " Search for selected text, forwards or backwards.
    "vnoremap <silent> * :<C-U>
    "  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    "  \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    "  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    "  \gVzv:call setreg('"', old_reg, old_regtype)<CR>
    "vnoremap <silent> # :<C-U>
    "  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    "  \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    "  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    "  \gVzv:call setreg('"', old_reg, old_regtype)<CR>

set wildcharm=<C-z>
cnoremap <expr> <Tab>   getcmdtype() =~ '[\/?]' ? "<C-g>" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[\/?]' ? "<C-t>" : "<S-Tab>"


" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
set modeline
set modelines=5

function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


" function! SearchHlClear()
"      let @/ = ""
" endfunction
" augroup searchhighlight
"     autocmd!
"     autocmd CursorHold,CursorHoldI * call SearchHlClear()
" augroup END

command! -nargs=0 Prettier :CocCommand prettier.formatFile

