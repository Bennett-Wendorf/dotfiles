set spell spelllang=en_us
set number
set tabstop=4
set expandtab

set ignorecase
set smartindent

set cursorline

set completeopt+=menuone

function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatusLineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

if !has('gui_running')
    set t_Co=256
endif

let q_git_branch=StatusLineGit()

" set statusline=

"set statusline+=%#PmenuSel#
"set statusline+=%{q_git_branch}

"set statusline+=%#LineNr#
"set statusline+=\ %.20f\ %M\ %y\ %R

"set statusline+=%=

"set statusline+=%#CursorColumn#
"set statusline+=\ ascii:\ %b\ row:\ %l\ col:\ %c\ per:\ %p%%

set laststatus=2

set noshowmode

" theming in .vim/colors
let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'background': 'dark',
    \ }
syntax on
colorscheme onedark
hi Normal guibg=NONE ctermbg=NONE
