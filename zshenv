export DOTFILES_ROOT=~/src/github.com/yuku-t/dotfiles

for file in ${DOTFILES_ROOT}/zshenv.d/*; do
    source "$file"
done

[ -f ~/.zshenv.local ] && source ~/.zshenv.local