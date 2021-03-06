"
" author:    Lv Zhandong <larrylv1990@gmail.com>
" modified at:    2012 Sep 15
"

set t_Co=256
colorscheme wombat256mod

" basic configuration
syntax on
set nocompatible
set nu
set ruler
set nobackup
set fdm=marker
set bs=2
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set diffopt+=iwhite " ignore whitespaces with vimdiff

" tab/indent configuration
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set autoindent
set cindent

filetype plugin indent on

" search configuration
set smartcase
set hlsearch

" status line configuration
set laststatus=2
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %l:%c\ \(%p%%\)%)

" Tab triggers buffer-name auto-completion
set wildchar=<Tab> wildmenu wildmode=full

" Misc Key Maps
imap <c-c> <ESC>
imap jj <ESC>
" Move around splits with <c-hjkl>
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <c-n> :nohlsearch<cr>
endfunction
call MapCR()
" Remove trailing whitespaces
nnoremap <silent> <F4> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" use comma as <Leader> key instead of backslash
let mapleader=","

" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" scrollfix.vim shortcut for open/close scrollfix
map <leader>on :FIXON<cr>
map <leader>of :FIXOFF<cr>
" FIXOFF    :let g:scrollfix=-1
" FIXON     :let g:scrollfix=60

" Insert the current time
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S')<cr>

" Map shortcuts for rails.vim"{{{
map <leader>c :Rcontroller<cr>
map <leader>v :Rview<cr>
map <leader>m :Rmodel<cr>
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
"map <leader>u :Runittest<cr>
"map <leader>s :Rfunctionaltest<cr>"}}}

" Marks settings"{{{
let showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1
hi ShowMarksHLl ctermbg=Yellow  ctermfg=Black guibg=#FFDB72 guifg=Black
hi ShowMarksHLu ctermbg=Magenta ctermfg=Black guibg=#FFB3FF guifg=Black
if !hasmapto( '<Plug>ShowmarksClearMark'       ) | map <silent> <unique> <leader>mq :ShowMarksClearMark<cr>| endif"}}}

" Syntastic settings"{{{
set statusline+=\ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=0
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['tex'] }"}}}

" Autocomplete configuration"{{{
set complete=.,w,b,u,t,i
set completeopt=longest,menu
highlight Pmenu ctermbg=238 gui=bold
let g:neocomplcache_enable_at_startup = 1
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
" Enable omni completion.
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
imap <silent><C-l> <Plug>(neocomplcache_snippets_force_expand)
smap <silent><C-l> <Plug>(neocomplcache_snippets_force_expand)
imap <silent><C-j> <Plug>(neocomplcache_snippets_force_jump)
smap <silent><C-j> <Plug>(neocomplcache_snippets_force_jump)
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><C-e>  neocomplcache#close_popup()
inoremap <expr><C-y>  neocomplcache#cancel_popup()
"inoremap <expr><C-h> neocomplcache#smart_close_popup()
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>""}}}

" Highlight trailing whitespace"{{{
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()"}}}

" CommandT plugin configuration {{{
" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
nnoremap <leader><leader> <c-^>
let g:CommandTCancelMap=['<Esc>', '<C-c>']
let g:CommandTAcceptSelectionSplitMap=['<C-f>']
set wildignore+=*.o,*.log,*.obj,.git,*.jpg,*.png,*.gif,vendor/bundle,vendor/cache,tmp,public/download " exclude files from listings

function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  " :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT public<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT spec<cr>
map <leader>gg :topleft :vsplit Gemfile<cr>
map <leader>gr :topleft :vsplit config/routes.rb<cr>
" }}}

" NERDTree plugin configuration"{{{
let NERDTreeWinSize = 26
let NERDTreeAutoCenter=1
map <F1> :NERDTreeToggle<CR>"}}}

" ctags/Tlist plugin configuration"{{{
map <F2> :Tlist<CR>
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1
let Tlist_WinWidth = 40
map <F5> :!ctags -R --languages=-javascript --exclude=.git --exclude=log --fields=+iaS --extra=+q .<CR>
map <F7> :tprevious<CR>
map <F8> :tnext<CR>
set tags=./tags;"}}}

" a.vim configuration"{{{
nnoremap <silent> <F6> :A<CR>"}}}

" ack.vim configuration"{{{
if executable("ack")
    " ,a to Ack (search in files)
    nnoremap <leader>a :Ack 
    let g:ackprg="ack -H --smart-case --nocolor --nogroup --column --nojs --nocss --ignore-dir=vendor/bundle --ignore-dir=./binstubs --ignore-dir=bin --ignore-dir=log --ignore-dir=tmp"
endif"}}}

" vim-javascript plugin configuration"{{{
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc""}}}

" SuperTab plugin configuration"{{{
let g:SuperTabRetainCompletionType = 2
let g:SuperTabDefaultCompletionType = "<C-X><C-P>""}}}

" filetype detection"{{{
autocmd BufNewFile,BufRead Thorfile set filetype=ruby
autocmd BufNewFile,BufRead *.thor set filetype=ruby
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufNewFile,BufRead Capfile set filetype=ruby
" autocmd BufRead *.erb set filetype=html
autocmd BufNewFile,BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:>
"autocmd BufNewFile,BufRead *.mkd set wrap nonumber"}}}

" encoding configuration {{{
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,chinese
set formatoptions+=mM
set ambiwidth=double
"}}}

" gb2312 encoding configuration {{{
"set encoding=gb2312
"set fileencoding=chinese
"set fileencodings=chinese,ucs-bom,utf-8
"set formatoptions+=mM
"set ambiwidth=double
"}}}
