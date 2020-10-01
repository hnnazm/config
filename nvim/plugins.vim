" ================================================
"  Plug In
" ================================================
   packloadall

"  Packages
   packadd! papercolor-theme
   packadd! lightline.vim
   packadd! goyo.vim
   packadd! limelight.vim
   packadd! fzf.vim
   packadd! vim-floaterm
   packadd! vimwiki
   packadd! vim-sandwich
   packadd! vim-easy-align
   packadd! coc.nvim
   packadd! vim-polyglot
   packadd! vim-snippets


" Plugin Setting –––––––––––––––––––––––––––––––––

" ------------------------------------------------
"  papercolor-theme
" ------------------------------------------------
   colorscheme PaperColor

" ------------------------------------------------
"  lightline
" ------------------------------------------------
"  :h 'statusline'
"  :h g:lightline.component

   let g:lightline = {
       \ 'colorscheme': 'PaperColor_light',
       \ 'tabline_separator': { 'left': '', 'right': '' },
       \ 'tabline_subseparator': { 'left': '', 'right': '' },
       \ 'separator': { 'left': '', 'right': '' },
       \ 'subseparator': { 'left': ' ', 'right': '' },
       \
       \ 'tabline': {
       \   'left': [ ['vim_logo', 'tabs' ] ],
       \   'right': [ ['git_status', 'close' ] ]
       \ },
       \
       \ 'active': {
       \   'left': [ [ 'mode', 'paste' ],
       \             [ 'readonly', 'filename' ] ],
       \   'right': [ [ 'lineinfo' ],
       \              [ 'percent' ],
       \              [ 'fileformat', 'fileencoding', 'filetype'] ]
       \ },
       \ 
       \'component_function': {
       \   'git_status': 'LightlineGitStatus',
       \   'git_blame': 'LightlineGitBlame',
       \ },
       \ 'component': {
       \   'vim_logo': '',
       \   'filename': '%<%F'
       \ },
       \ }

   function! LightlineReload()
       call lightline#init()
       call lightline#colorscheme()
       call lightline#update()
   endfunction

   function! LightlineGitStatus() abort
       let status = get(g:, 'coc_git_status', '')
       " return blame
       return winwidth(0) > 80 ? status : ''
   endfunction


" ------------------------------------------------
"  fzf.vim
" ------------------------------------------------
"  Fzf binary
   set rtp+=/usr/local/opt/fzf

"  Default layout
   let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'sharp' } }

   function! s:build_quickfix_list(lines)
       call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
       copen
       cc
   endfunction

   let g:fzf_action = {
       \ 'ctrl-q': function('s:build_quickfix_list'),
       \ 'ctrl-t': 'tab split',
       \ 'ctrl-x': 'split',
       \ 'ctrl-v': 'vsplit' }

   command! -bang -nargs=? -complete=dir Buffers call fzf#vim#buffers(
               \ <q-args>,
               \ {'options': [
                  \ '--layout=reverse',
                  \ '--info=inline']},
              \ <bang>0)


"  Text object &visual mode
   function! s:GrepFromSelected(type)
       let saved_unnamed_register = @@
       if a:type ==# 'v'
           normal! `<v`>y
       elseif a:type ==# 'char'
           normal! `[v`]y
       else
           return
       endif
       let word = substitute(@@, '\n$', '', 'g')
       let word = escape(word, '| ')
       let @@ = saved_unnamed_register
       execute 'RG! '.word
   endfunction

"  Rg command with preview window
   function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg
                  \ --column
                  \ --line-number
                  \ --no-heading
                  \ --color=always
                  \ --smart-case %s
                  \ || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'down': '40%',
                  \ 'options': [
                      \ '--phony',
                      \ '--query', a:query,
                      \ '--bind',
                      \ 'change:reload:'.reload_command
                  \ ]}
      call fzf#vim#grep(initial_command,
                  \ 1,
                  \ fzf#vim#with_preview(spec),
                  \ a:fullscreen)
   endfunction

   command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"  Keymap
   nnoremap <silent> <Leader>f :<C-u>Files!<CR>
   nnoremap <silent> <Leader>b :<C-u>Buffers<CR>
   nnoremap <silent> <Leader>/ :<C-u>RG<CR>
   vnoremap <Leader>* :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
   nnoremap <Leader>* :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@


" ------------------------------------------------
"  floaterm
" ------------------------------------------------
   let g:floaterm_shell = "/bin/zsh -l"
   let g:floaterm_title = "$1/$2"
   let g:floaterm_winype = "floating"
   let g:floaterm_width = 0.6
   let g:floaterm_height = 0.6
   let g:floaterm_winblend = 0
   let g:floaterm_position = "center"
   let g:floaterm_autoclose = 1
   let g:floaterm_borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']

"  Set floaterm window's background to black
   hi Floaterm ctermbg=bg
"  Set floating window border line color to cyan, and background to orange
   hi FloatermBorder ctermbg=bg ctermfg=fg

   function s:floatermSettings()
       setlocal nonumber norelativenumber
       " more settings
   endfunction

   autocmd FileType floaterm call s:floatermSettings()

"  Keymap
   let g:floaterm_keymap_new    = '<F7>'
   let g:floaterm_keymap_prev   = '<F8>'
   let g:floaterm_keymap_next   = '<F9>'
   let g:floaterm_keymap_toggle = '<F12>'


" ------------------------------------------------
"  vimwiki
" ------------------------------------------------
"  3 syntaxes: VimWiki (default), Markdown (markdown), and MediaWiki (media)

   let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
       \ 'syntax': 'default', 'ext': '.wiki'}]


" ------------------------------------------------
"  goyo
" ------------------------------------------------
"  Config
   let g:goyo_width=80
   let g:goyo_height='70%'
   let g:goyo_linenr=0

"  Keymap
   nnoremap <silent> <leader>d :Goyo<CR>


" ------------------------------------------------
"  limelight
" ------------------------------------------------
"  Color name (:help cterm-colors) or ANSI code
   let g:limelight_conceal_ctermfg = 'bg'
"  let g:limelight_conceal_ctermfg = 240
 
"  Default coefficient
   let g:limelight_default_coefficient = str2float('0.9')

"  Autoload when entering goyo mode
   autocmd! User GoyoEnter Limelight0.9
   autocmd! User GoyoLeave Limelight!

 " Keymap
    nmap <Leader>l <Plug>(Limelight)
    xmap <Leader>l <Plug>(Limelight)


" -------------------------------------------------
"  vim-sandwich
" -------------------------------------------------
"  if you have not copied default recipes
   let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)

"  vim-surround key mapping
   runtime macros/sandwich/keymap/surround.vim

"  add spaces inside bracket
   let g:sandwich#recipes += [
       \   {'buns': ['{ ', ' }'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['{']},
       \   {'buns': ['[ ', ' ]'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['[']},
       \   {'buns': ['( ', ' )'], 'nesting': 1, 'match_syntax': 1, 'kind': ['add', 'replace'], 'action': ['add'], 'input': ['(']},
       \   {'buns': ['{\s*', '\s*}'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['{']},
       \   {'buns': ['\[\s*', '\s*\]'], 'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['[']},
       \   {'buns': ['(\s*', '\s*)'],   'nesting': 1, 'regex': 1, 'match_syntax': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['(']},
       \ ]


" ------------------------------------------------
"  vim-easy-align
" ------------------------------------------------
"  Start interactive EasyAlign in visual mode (e.g. vipga)
   xmap ga <Plug>(EasyAlign)

"  Start interactive EasyAlign for a motion/text object (e.g. gaip)
   nmap ga <Plug>(EasyAlign)


" ------------------------------------------------
"  coc.nvim
" ------------------------------------------------
"  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"  delays and poor user experience.
   set updatetime=300

"  Use K to show documentation in preview window.
   nnoremap <silent> K :call <SID>show_documentation()<CR>

   function! s:show_documentation()
       if (index(['vim','help'], &filetype) >= 0)
           execute 'h '.expand('<cword>')
       else
           call CocAction('doHover')
       endif
   endfunction

"  Highlight the symbol and its references when holding the cursor.
   autocmd CursorHold * silent call CocActionAsync('highlight')

"  Keymap

"  Use `[e` and `]e` to navigate diagnostics
"  Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
   nmap <silent> [e <Plug>(coc-diagnostic-prev)
   nmap <silent> ]e <Plug>(coc-diagnostic-next)

"  GoTo code navigation.
   nmap <silent> gd <Plug>(coc-definition)
   nmap <silent> gy <Plug>(coc-type-definition)
   nmap <silent> gi <Plug>(coc-implementation)
   nmap <silent> gr <Plug>(coc-references)

"  Show all diagnostics.
   nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>

"  Manage extensions.
   nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
   
"  Show commands.
   nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>

"  Find symbol of current document.
   nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>

"  Search workspace symbols.
   nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>

"  Do default action for next item.
   nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>

"  Do default action for previous item.
   nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>

"  Resume latest coc list.
   nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>

"  coc-snippets ----------------------------------
"  Use <C-j> for jump to next placeholder, it's default of coc.nvim
   let g:coc_snippet_next = '<c-j>'

"  Use <C-k> for jump to previous placeholder, it's default of coc.nvim
   let g:coc_snippet_prev = '<c-k>'

"  Use <C-l> for trigger snippet expand.
   imap <C-l> <Plug>(coc-snippets-expand)
   
"  Use <C-j> for select text for visual placeholder of snippet.
   vmap <C-j> <Plug>(coc-snippets-select)

"  Use <C-j> for both expand and jump (make expand higher priority.)
   imap <C-j> <Plug>(coc-snippets-expand-jump)

"  coc-git ----------------------------------------
"  navigate chunks of current buffer
   nmap [g <Plug>(coc-git-prevchunk)
   nmap ]g <Plug>(coc-git-nextchunk)

"  show chunk diff at current position
   nmap gs <Plug>(coc-git-chunkinfo)
   
"  show commit contains current position
   nmap gc <Plug>(coc-git-commit)
