set number             " enable line numbers
set relativenumber     " enable relative line numbers
set tabstop=4          " insert 4 spaces worth of indent
set softtabstop=4      " spaces to enter for each tab
set shiftwidth=4       " amount of spaces for indentation
set expandtab          " tab key inserts spaces not tabs
set smartindent        " is like 'autoindent' but better
set nowrap             " no wrap words
set nospell            " no spelling
set spelllang=en       "   for english
set colorcolumn=80     " show mark at 80 chars length
set mouse=a            " allow mouse click in UI
set showmatch          " show matching brackets
set cmdheight=1        " space for displaying messages
set updatetime=300     " reduce update time
set noswapfile         " no swap files
set encoding=utf-8     " support unicode characters
set diffopt=filler,vertical
set signcolumn=number  " merge signcolumn and number column into one
" show invisible characters
set listchars=space:␣,tab:>-,trail:~,extends:>,precedes:<
set nolist             " list/nolist
" `:grep` command works through ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set grepformat=%f:%l:%c:%m
"
set inccommand=nosplit                          " real time substitution without splitting buffer
" gui
set guicursor=n:block,i:ver25-blinkon1
set guifont=Fira\ Code:h14
"
set scrolloff=4                                 " keep 3 lines visible above/below the cursor when scrolling
set sidescrolloff=4                             " keep 7 characters visible to the left/right of the cursor when scrolling
set sidescroll=1                                " scroll left/right one character at a time
set splitbelow splitright                       " put new windows below or to the right
"
filetype plugin on                              " load plugins based on file type
filetype indent on
"
" display hidden characters
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set nolist " set list
"
set hidden                                      " allow unsaved buffers to be hidden
"
syntax enable
" transparency
set wildoptions=pum
set winblend=10
set pumblend=10
highlight NormalNC guibg=none
highlight Normal guibg=none ctermbg=none
highlight LineNr guibg=none ctermbg=none
highlight Folded guibg=none ctermbg=none
highlight NonText guibg=none ctermbg=none
highlight SpecialKey guibg=none ctermbg=none
highlight VertSplit guibg=none ctermbg=none
highlight SignColumn guibg=none ctermbg=none
highlight EndOfBuffer guibg=none ctermbg=none
"


" Plugins
call plug#begin('~/.vim/plugged')

" netrw settings
Plug 'tpope/vim-vinegar'

" working with comments
Plug 'tpope/vim-commentary'

" theme (dark/light)
Plug 'gruvbox-community/gruvbox'
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_contrast_light = 'hard'
  let g:gruvbox_bold = 0
  let g:gruvbox_sign_column = 'bg0'

" build a syntax tree incrementally
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" git
Plug 'tpope/vim-fugitive'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" start screen
Plug 'mhinz/vim-startify'

" lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" zen mode
Plug 'folke/zen-mode.nvim'

" escaping insert mode without lagging
Plug 'jdhao/better-escape.vim'

call plug#end()


" Initializations by lua
lua <<EOF
require('init.treesitter')
require('init.zenmode')
EOF


" Theme & colors
set termguicolors

set background=dark  " dark/light
colorscheme gruvbox


" Functions

function ToggleBackground()
  if &background == 'light'
    set background=dark
    let $BAT_THEME='gruvbox-dark'
  else
    set background=light
    let $BAT_THEME='gruvbox-light'
  endif
endfunc

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let options = fzf#vim#with_preview(options, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

function! RipgrepBuffer(query, fullscreen)
  let command_fmt = 'rg --trim --column --line-number --no-heading --color=always --smart-case --glob=' . expand("%") . ' -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--layout=reverse', '--preview-window', 'down:60%', '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction


" Commands

command! EditConfig :e ~/.config/nvim/init.vim
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -nargs=* -bang RgBuffer call RipgrepBuffer(<q-args>, <bang>0)


" Auto command

"  highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"  reduce amount of opened fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete


" Settings

" --- netrw
let g:netrw_liststyle = 0
let g:netrw_banner = 1

" --- startify
" 'Most Recent Files' number
let g:startify_files_number = 7

" update session automatically as you exit vim
let g:startify_session_persistence = 1

" simplify the startify list to just recent files and sessions
let g:startify_lists = [
  \ { 'type': 'dir',       'header': ['   Recent files'] },
  \ { 'type': 'sessions',  'header': ['   Saved sessions'] },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ ]

" fancy custom header
let g:startify_custom_header = [
  \ '  ',
  \ ' ________       _______       ________      ___      ___  ___      _____ ______      ',
  \ '|\   ___  \    |\  ___ \     |\   __  \    |\  \    /  /||\  \    |\   _ \  _   \    ',
  \ '\ \  \\ \  \   \ \   __/|    \ \  \|\  \   \ \  \  /  / /\ \  \   \ \  \\\__\ \  \   ',
  \ ' \ \  \\ \  \   \ \  \_|/__   \ \  \\\  \   \ \  \/  / /  \ \  \   \ \  \\|__| \  \  ',
  \ '  \ \  \\ \  \   \ \  \_|\ \   \ \  \\\  \   \ \    / /    \ \  \   \ \  \    \ \  \ ',
  \ '   \ \__\\ \__\   \ \_______\   \ \_______\   \ \__/ /      \ \__\   \ \__\    \ \__\',
  \ '    \|__| \|__|    \|_______|    \|_______|    \|__|/        \|__|    \|__|     \|__|',
  \ '   ',
  \ ]

" --- persistent undo (except temporary files)
set undofile
set undodir=~/.vim/undo
augroup vimrc
  autocmd!
  autocmd BufWritePre /tmp/* setlocal noundofile
augroup END


" Abbreviations

abbr esle else
abbr retrun return


" Remap

" set leader key
let mapleader = " "

nnoremap <leader>M :Maps<CR>
nnoremap <leader>l :nohlsearch<CR>

" search for word on cursor
nnoremap <leader>fw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fW :CocSearch <C-R>=expand("<cword>")<CR><CR>

" toggle
nnoremap <leader>kr :set relativenumber!<CR>
nnoremap <leader>kz :ZenMode<CR>
nnoremap <leader>km :Filetypes<CR>

" movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>l
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
" beggining of the line
inoremap <C-a> <ESC>^i
" end of the line
inoremap <C-e> <End>
" toggle last buffers
inoremap <C-^> <C-o><C-^>

" window switching for normal & terminal modes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" tmux sessionizer from vim
nnoremap <silent> <C-f> :silent !tmux neww tmux-sessionizer<CR>

" spell toggle
nnoremap <leader>s :set spell!<CR>

" split
" ctr+\ and alt+\
nnoremap <C-\> :vsplit<CR>
nnoremap <M-Bslash> :split<CR>
"  resize
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" move selected lines down / up
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" toggle background
nnoremap <leader><F12> :call ToggleBackground()<CR>

" reload config
nnoremap <leader><CR> :source ~/.config/nvim/init.vim<CR>
" save file
nnoremap <leader>w :w<CR>
" quit from buffer, delete buffer
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :bd<CR>

" go to file (with respect to line) in new tab
nnoremap gf <C-w>gF

" quickfix list
"   back and forth quickfix list
nnoremap ]q :cnext<CR>zz
nnoremap [q :cprevious<CR>zz
nnoremap ]Q :clast<CR>zz
nnoremap [Q :cfirst<CR>zz
nnoremap ]l :lnext<CR>zz
nnoremap [l :lprevious<CR>zz

" buffer
"   back and forth buffers
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>

" tab
"   back and forth tabs
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>
nnoremap <leader>tq :tabclose<CR>

" terminal
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>tt :execute 'terminal' \| let b:term_type = 'wind' \| startinsert <CR>
nnoremap <leader>tv :execute 'vnew +terminal' \| let b:term_type = 'vert' \| startinsert <CR>
nnoremap <leader>th :execute 15 .. 'new +terminal' \| let b:term_type = 'hori' \| startinsert <CR>

" git
"  navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
"  navigate conflicts of current buffer
nmap [c <Plug>(coc-git-prevconflict)
nmap ]c <Plug>(coc-git-nextconflict)
"  show chunk diff at current position
nmap <leader>gp <Plug>(coc-git-chunkinfo)
"  show commit contains current position
nmap <leader>gc <Plug>(coc-git-commit)
"
nnoremap <leader>G :Git<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gC :BCommits<CR>
nnoremap <leader>gf :vsplit \| :Gclog -50 -- %<CR>
nnoremap <leader>gd :Gdiff<CR>
vnoremap <leader>gl :Gclog<CR>

" fzf
nnoremap <leader>ff :GFiles<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fB :Windows<CR>
nnoremap <leader>fe :History<CR>
nnoremap <leader>fc :History:<CR>
nnoremap <leader>fs :History/<CR>
nnoremap <leader>fg :RG!<CR>
nnoremap <leader>fG :RgBuffer<CR>
nnoremap <leader>`  :Marks<CR>

" copy to the system clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y
" delete & copy to the system clipboard
vnoremap <leader>d "+d
nnoremap <leader>d "+d
" copy whole acitve buffer
nnoremap <leader>Y gg"+yG
" copy current relative file path to system clipboard
nnoremap <leader>yp :let @+ = expand("%")<CR>

" coc
"  use tab for trigger completion with characters ahead and navigate
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"  make <CR> auto-select the first completion item and notify coc.nvim to format on enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"  code navigation
nmap <leader>jd <Plug>(coc-definition)
nmap <leader>jy <Plug>(coc-type-definition)
nmap <leader>ji <Plug>(coc-implementation)
nmap <leader>jr <Plug>(coc-references)

"  use K to show documentation in preview window.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

"  symbol renaming
nmap <leader>rn <Plug>(coc-rename)
"  show commands
nnoremap <leader>c  :<C-u>CocList commands<CR>
"  find symbol of current document
nnoremap <leader>o  :<C-u>CocList outline<CR>
" Show all diagnostics
nnoremap <leader>a  :<C-u>CocList diagnostics<CR>
"  manage extensions.
nnoremap <leader>e  :<C-u>CocList extensions<CR>
"  add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
"
nnoremap <leader>cd :CocDiagnostics<cr>
nnoremap <leader>cf :CocFix<cr>
nnoremap <leader>ch :call CocAction('doHover')<cr>


" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'Normal·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                 " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %Y\                                 " FileType
set statusline+=%3*│                                     " Separator
set statusline+=%2*\ %{''.(&fenc!=''?&fenc:&enc).''}     " Encoding
set statusline+=\ (%{&ff})                               " FileFormat (dos/unix..)
set statusline+=%=                                       " Right Side
set statusline+=%2*\ col:\ %02v\                         " Colomn number
set statusline+=%3*│                                     " Separator
set statusline+=%1*\ ln:\ %02l/%L\ (%3p%%)\              " Line number / total lines, percentage of document
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

au InsertEnter * hi statusline guifg=#4e4e4e guibg=red ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=#4e4e4e guibg=yellow ctermfg=black ctermbg=cyan
hi statusline guifg=#4e4e4e guibg=yellow ctermfg=black ctermbg=cyan

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#ffffff
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e
