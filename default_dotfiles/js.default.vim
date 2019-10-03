""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Default JS development configuration
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  " Python
    let g:python3_host_prog = $PYENV_ROOT .  '/versions/py3nvim/bin/python'
    let g:python_host_prog = $PYENV_ROOT .  '/versions/py2nvim/bin/python'

  " Misc ---------------------------------
    filetype plugin on    " Enable filetype-specific plugins
    set background=dark
    set number                     " Show current line number
    set relativenumber             " Show relative line numbers
    set tags=.git/tags
    syntax enable

  " Tabs and Spaces handling
    filetype indent on    " Enable filetype-specific indenting
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4

  " Window Navigation
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show a diff of what's changed since the last save
  if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
  endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Sources
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')

" Code Analysis
Plug 'dense-analysis/ale'
Plug 'scrooloose/syntastic'

" General
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'

" Getting Around
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 't9md/vim-choosewin'
Plug 'tpope/vim-projectionist'

" Readability
Plug 'fisadev/fisa-vim-colorscheme'
Plug 'mhinz/vim-signify'

" Snippets + Completions
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdcommenter'
Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'SirVer/ultisnips'
Plug 'tomtom/tcomment_vim'
Plug 'Townk/vim-autoclose'

" Terminal-related
Plug 'christoomey/vim-tmux-navigator'
Plug 'jpalardy/vim-slime'

" Text Wrangling
Plug 'junegunn/vim-easy-align'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" abolish.vim --------------------------

" AutoClose ----------------------------

" Choosewin ----------------------------
    nmap - <Plug>(choosewin)

" Dense Analysis -----------------------
    let g:ale_fix_on_save = 1
    let g:ale_fixers = {
          \   '*': ['remove_trailing_lines', 'trim_whitespace'],
          \   'javascript': ['eslint'],
          \}
    function! s:ToggleAleFixOnSave()
      let g:ale_fix_on_save = !g:ale_fix_on_save
      if g:ale_fix_on_save
        echo "g:ale_fix_on_save ON"
      else
        echo "g:ale_fix_on_save OFF"
      endif
    endfunction
    command! AutoFixOnSaveToggle :call s:ToggleAleFixOnSave()

" Deoplete -----------------------------
  " TODOs:
  " 1. figure out how to read other buffers from the get-go
  " 2. figure out if context_filetype is needed
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#enable_smart_case = 1
  " needed so deoplete can auto select the first suggestion
    set completeopt+=noinsert
  " comment this line to enable autocompletion preview window
  " (displays documentation related to the selected completion option)
    set completeopt-=preview
  " autocompletion of files and commands behaves like shell
  " (complete only the common part, list the options that match)
    set wildmode=list:longest

" dispatch.vim -------------------------

" EasyAlign ----------------------------
  " Start for visual mode and motion objects:
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)

" eunuch.vim ---------------------------

" exchange.vim -------------------------

" fisa-colorscheme ---------------------

" fugitive.vim -------------------------

" fzf ----------------------------------

" fzf-vim ------------------------------

" NERDCommenter ------------------------

" NERDTree -----------------------------

" projectionist.vim --------------------

" repeat.vim ---------------------------

" RipGrep ------------------------------

" Signify ------------------------------
  " Guessing order for vcs:
    let g:signify_vcs_list = [ 'git', 'hg' ]
  " nicer colors
    highlight DiffAdd           cterm=bold ctermbg=none ctermfg=119
    highlight DiffDelete        cterm=bold ctermbg=none ctermfg=167
    highlight DiffChange        cterm=bold ctermbg=none ctermfg=227
    highlight SignifySignAdd    cterm=bold ctermbg=237  ctermfg=119
    highlight SignifySignDelete cterm=bold ctermbg=237  ctermfg=167
    highlight SignifySignChange cterm=bold ctermbg=237  ctermfg=227

" sleuth.vim ---------------------------

" Slime --------------------------------
    let g:slime_target = 'tmux'

" speeddating.vim ----------------------

" surround.vim -------------------------

" Syntastic ----------------------------

" tcomment -----------------------------

" UltiSnips ----------------------------
    let g:UltiSnipsJumpForwardTrigger = '<Tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    let g:UltiSnipsSnippetsDir = 'ultisnips'
    let g:UltiSnipsSnippetDirectories = ['ultisnips', 'ultisnips-private']

" unimpaired.vim -----------------------

" Vim Snippets -------------------------

" Vim Tmux Navigator -------------------

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  let mapleader="\<Space>"
  let maplocalleader="\\"

  " <Leader>g -- git grep for something (mnemonic: [g]it [g]rep).
    " nnoremap <Leader>g :VcsJump grep<Space> " TODO

  " filepaths
    nnoremap <LocalLeader>p :echo expand('%')<CR>
    " nnoremap <Leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR> " TODO Fix

  " <Leader><Leader> -- Open last buffer.
    nnoremap <Leader><Leader> <C-^>
    nnoremap <Leader>e :edit!<CR>
    nnoremap <Leader>o :only<CR>
    nnoremap <Leader>q :quit<CR>
    nnoremap <Leader>w :write<CR>
    nnoremap <Leader>x :xit<CR>

" --------------------------------------
" Custom Functions ---------------------
" --------------------------------------
  " <LocalLeader>d... -- Diff mode bindings:
    noremap <silent> <LocalLeader>do :DiffOrig<CR>
  " - yof: toggle auto-fix on saving (mnemonic: [f] = fix)
    noremap <silent> yof :AutoFixOnSaveToggle<CR>

" --------------------------------------
" Plugins ------------------------------
" --------------------------------------

" abolish.vim --------------------------

" AutoClose ----------------------------
  " - yop: toggle bracket auto-closing (mnemonic: [p] = parenthesis)
    noremap <silent> yop :AutoCloseToggle<CR>

" Choosewin ----------------------------

" Dense Analysis -----------------------

" Deoplete -----------------------------

" dispatch.vim -------------------------

" EasyAlign ----------------------------

" eunuch.vim ---------------------------

" exchange.vim -------------------------

" fisa-colorscheme ---------------------

" fugitive.vim -------------------------
  " <LocalLeader>d... -- Diff mode bindings:
  " - <LocalLeader>dd: show diff view (mnemonic: [d]iff)
  " - <LocalLeader>dh: choose hunk from left (mnemonic: [h] = left)
  " - <LocalLeader>dl: choose hunk from right (mnemonic: [l] = right)
    nnoremap <silent> <LocalLeader>dd :Gvdiff<CR>
    nnoremap <silent> <LocalLeader>dh :diffget //2<CR>
    nnoremap <silent> <LocalLeader>dl :diffget //3<CR>

" fzf ----------------------------------

" fzf-vim ------------------------------
  " file finder mapping
    nmap <LocalLeader>e :Files<CR>
  " tags (symbols) in current file finder mapping
    nmap <LocalLeader>g :BTag<CR>
  " tags (symbols) in all files finder mapping
    nmap <LocalLeader>G :Tag<CR>
  " general code finder in current file mapping
    nmap <LocalLeader>f :BLines<CR>
  " general code finder in all files mapping
    nmap <LocalLeader>F :Lines<CR>
  " commands finder mapping
    nmap <LocalLeader>c :Commands<CR>

" NERDCommenter ------------------------

" NERDTree -----------------------------
    nmap <leader>n :NERDTreeFind<CR>
    nmap <leader>m :NERDTreeToggle<CR>

" projectionist.vim --------------------

" repeat.vim ---------------------------

" RipGrep ------------------------------
    nmap <LocalLeader>r :Rg
    nmap <LocalLeader>wr :Rg <cword><CR>

" Signify ------------------------------

" sleuth.vim ---------------------------

" Slime --------------------------------

" speeddating.vim ----------------------

" surround.vim -------------------------

" Syntastic ----------------------------

" tcomment -----------------------------

" UltiSnips ----------------------------

" unimpaired.vim -----------------------

" Vim Snippets -------------------------

" Vim Tmux Navigator -------------------
