let mapleader=','           " Lead with ,

" Jump to vimrc
nnoremap <space>v :<C-u>edit $DOTFILES_ROOT/vimrc<CR>
" Reload vimrc setting
nnoremap <space>s :<C-u>source $HOME/.vimrc<CR>
" Create new tab
cnoremap <C-t> <C-u>tabnew<CR>
nnoremap <C-h> :<C-u>tabprevious<CR>
nnoremap <C-l> :<C-u>tabnext<CR>
" Recall command-line from history, whose beginning matches the current command-line.
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>

" Move to n-th tab by Cmd-n
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> 9gt
map <D-0> :tablast<CR>
