#----------------------------------------------------------#
#                                                          #
#                         $$\                              #
#                         $$ |                             #
#     $$$$$$$$\  $$$$$$$\ $$$$$$$\   $$$$$$\   $$$$$$$\    #
#     \____$$  |$$  _____|$$  __$$\ $$  __$$\ $$  _____|   #
#       $$$$ _/ \$$$$$$\  $$ |  $$ |$$ |  \__|$$ /         #
#      $$  _/    \____$$\ $$ |  $$ |$$ |      $$ |         #
#     $$$$$$$$\ $$$$$$$  |$$ |  $$ |$$ |      \$$$$$$$\    #
#     \________|\_______/ \__|  \__|\__|       \_______|   #
#                                                          #
#----------------------------------------------------------#

# This file sets up cli environment.

# Declaration
# ===========

# Environment Variables
# ---------------------


# Variables
# ---------

# Unique array
typeset -Ua path cdpath fpath manpath

# Functions
# ---------

fpath=($HOME/.zsh/functions(N-/) $fpath)
for i in $(ls $HOME/.zsh/functions) ; do autoload -U $i ; done

# Alias Settings
# ==============

setopt complete_aliases     # expand aliases before completing

[ -x "$(which hub 2> /dev/null)" ]    && eval "$(hub alias -s)"     # use hub
[ -x "$(which direnv 2> /dev/null)" ] && eval "$(direnv hook zsh)"  # use direnv

## General
alias ll='ls -lh'
alias lla='ls -lhA'
alias la='ls -A'
alias lsd='ls -ld *(-/DN)'
alias df='df -h'
alias du='du -h'
alias sudo='env PATH=${PATH}:/sbin:/usr/sbin:/usr/local/sbin \sudo'
alias grep=egrep
alias h=history
alias j=jobs
alias ggp='command git grep -H --heading --break'
alias glg='command git log --graph --pretty="format:%C(yellow)%h%C(blue)%d%C(reset) %s %C(cyan)%an, %ar%C(reset)"'
alias gci='command git commit -v'
alias gun='command git reset HEAD~'
alias gco='command git checkout'
alias gst='command git status --short'
alias gbr='command git branch'
## Global alias
alias -g L='|less'
alias -g H='|head'
alias -g T='|tail'
alias -g G='|grep'
alias -g GI='|grep -i'
#alias tmux='tmux -u'
alias hg='hg --encoding=utf-8'
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'
alias gcc='gcc -Wall -lstdc++'
alias inflate="perl -MCompress::Zlib -e 'undef $/; print uncompress(<>)'"
#alias less=vimpager
#alias cat=vimcat
## os depending alias settings
case ${OSTYPE} in
darwin*) # Mac OS X
    function macvim () {
        if [ -d /Applications/MacVim.app ] ; then
            if [[ -n `ps aux | grep MacVim` ]] ; then
                [ ! -f $1 ] && touch $1
                open -a MacVim $1
            else
                gvim $1
            fi
        else
            command vim $1
        fi
    }
    # alias vim='macvim'
    alias ls='ls -GF'
    alias -s {png,jpg,bmp,PNG,JPG,BMP}='open -a Preview'
    alias pong='perl -nle '\''print "display notification \"$_\" with title \"Terminal\""'\'' | osascript'
    export PATH="/usr/local/sbin:$PATH"
    ;;
linux*)
    alias ls='ls -F --color=auto'
    ;;
esac
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

if [ -x "$(where grc)" ]
then
    alias mount='grc mount'
    #alias ifconfig='grc ifconfig'
    alias dig='grc dig'
    alias ldap='grc ldap'
    alias netstat='grc netstat'
    alias ping='grc ping'
    alias ps='grc ps'
    alias traceroute='grc traceroute'
    alias gcc='grc gcc'
fi
if [ -x "$(where colordiff)" ]
then
    alias diff='colordiff'
fi


### misc. settings
export LESSCHARSET=utf-8
export OUTPUT_CHARSET=utf-8
umask 022            # default umask
bindkey -e           # emacs like keybinding
export EDITOR=vim
export MANPAGER='less -R'
# Backspace key
bindkey "^?" backward-delete-char

### Prompt configuration
autoload -U colors
REPORTTIME=3
colors

# Color
local DEFAULT=$'%{\e[1;0m%}'
local RESET="%{${reset_color}%}"
local GREEN="%{${fg[green]}%}"
local BLUE="%{${fg[blue]}%}"
local RED="%{${fg[red]}%}"
local CYAN="%{${fg[cyan]}%}"
local YELLOW="%{${fg[yellow]}%}"
local WHITE="%{${fg[white]}%}"
local GRAY="%{${fg[gray]}%}"
local BOLD_GREEN="%{${fg_bold[green]}%}"
local BOLD_BLUE="%{${fg_bold[blue]}%}"
local BOLD_RED="%{${fg_bold[red]}%}"
local BOLD_CYAN="%{${fg_bold[cyan]}%}"
local BOLD_YELLOW="%{${fg_bold[yellow]}%}"
local BOLD_WHITE="%{${fg_bold[white]}%}"
local BOLD_GRAY="%{${fg_bold[gray]}%}"

#RPROMPT="%T"
setopt transient_rprompt
function precmd () {
    local color branch
    #PROMPT="${GREEN}%n${RESET}@${BLUE}%m${YELLOW} %~${RESET} "
    PROMPT="${YELLOW}%~${RESET} "
    if [ "$(is_git_repository)" = 'true' ] ; then
        st=`command git status 2>/dev/null`
        if [ $? ] ; then
            if [[ -n `echo "$st" | grep "^nothing to"` ]] ; then
                color=$CYAN
            elif [[ -n `echo "$st" | grep "^nothing added"` ]] ; then
                color=$BLUE
            elif [[ -n `echo "$st" | grep "^# Untracked"` ]] ; then
                color=$BOLD_RED
            else
                color=$RED
            fi
            branch=$(git current-branch)
            if [ $branch ] ; then
                PROMPT+="$color$branch%b${RESET} "
            fi
        fi
    fi
}

# No beep
set bell-style none; setopt nobeep; setopt nolistbeep

setopt prompt_subst         # Use escape sequences
setopt interactive_comments # Ignore commands following # in cui
setopt no_flow_control      # Disable C-s and C-q
setopt print_eight_bit      # Enable Japanese file name

# NOCLOBBER prevents accidentally overwriting an existing file.
# To really clobber a file, use the >! operator.
setopt noclobber

# C-w deletes the caractor next to the /
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export LS_COLORS='di=01;36' # Show direcotry in water color

# Automatically escape URL string
autoload -Uz url-quote-magic; zle -N self-insert url-quote-magic

# Colorize
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

setopt noautoremoveslash    # Don't automatically remove / on the tail


# MySQL
#export MYSQL_PS1='(^[[32m\u^[[00m@^[[33m\h^[[00m) ^[[34m[\d]^[[00m > '


### History settings
HISTFILE=$HOME/.zsh-history # history file
HISTSIZE=10000              # number of saved history on memory
SAVEHIST=10000              # number of saved history
setopt hist_ignore_all_dups # ignore duplicated history
setopt hist_reduce_blanks   # strip white spaces
setopt hist_no_store        # ignore history command
setopt hist_ignore_space    # ignore command starts with white spaces
setopt extended_history     # current time is also saved
setopt share_history        # share history across multi processes
setopt append_history
setopt inc_append_history
setopt hist_verify          # can edit history before execute it
# short cut
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# incremental search
#bindkey "^R" history-incremental-search-backward
#bindkey "^S" history-incremental-search-forward
#function history-all () { history -E 1 }

### misc. settings

# colorize less
if [ -x "${HOME}/.source-highlight/src-hilite-lesspipe.sh" ]; then
  export LESS='-R'
  export LESSOPEN="| $HOME/.source-highlight/src-hilite-lesspipe.sh %s"
fi

setopt no_hup               # Keep processs when logging out
setopt checkjobs            # Check background job when logging out
setopt notify               # Immediately notify when backgroung job finishes
setopt auto_cd              # Change direcroty with it's name
setopt auto_pushd           # Execute pushd command when current directory is
                            # changed by cd command
setopt pushd_ignore_dups    # Make pushd command ignore duplicated directories
#setopt pushd_silent         # Do not print the directory stack after popd

export GREP_OPTIONS='--color=auto'

### Completion settings
# Use full complement functionality
autoload -Uz compinit
# Update fpath
for i (
    $HOME/.zsh/completions
    $HOME/.zsh/zsh-completions/src
    $HOME/.go/src/github.com/motemen/ghq/zsh
)
do
    [ -d $i ] && fpath=($i $fpath)
done

compinit -u
setopt auto_list            # Show all candidates
setopt auto_menu            # Toggle complement candidates using TAB
setopt auto_param_slash     # Insert / after a complemented directory name
setopt correct              # Do spell check
setopt list_packed          # Use compackt style candidates viewer mode
setopt list_types           # Show kinds of file using marks
setopt magic_equal_subst    # Even option args are complemented
# Can use Emacs style keybind to select candidates
zstyle ':completion:*:default' menu select=1
# Complement process name with kill command
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin/bin
# Don't show current directory
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

### Python settings
export NOSE_REDNOSE=1
export PYTHONSTARTUP=${HOME}/.pythonrc
[ -f $(which virtualenvwrapper.sh 2> /dev/null) ] && source $(which virtualenvwrapper.sh)

### Perl settings
export PERL_BADLANG=0

# Extra zshrc files


# Activate cdr command for zaw-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both
zstyle ':filter-select' case-insensitive yes
zstyle ':filter-select' max-lines $(($LINES / 2))

for i (
    $HOME/.zsh/zaw/zaw.zsh
    $HOME/.zsh/zaw-sources/git-recent-branches.zsh
    $HOME/.zsh/zaw-sources/zaw-git-show-branch.zsh
    $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
do
  [ -f $i ] && source $i
done


# zaw keybinding
bindkey '^O^B' zaw-git-recent-branches
bindkey '^O^R' zaw-git-branches
bindkey '^R' zaw-history
bindkey '^T' zaw-cdr

#source $DOTFILES/modules/auto-fu.zsh/auto-fu.zsh
#zle-line-init () {auto-fu-init;}; zle -N zle-line-init
#zstyle ':completion:*' completer _oldlist _complete
#zle -N zle-keymap-select auto-fu-zle-keymap-select

# local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local



# Git Keybindings
# ---------------

zle -N git_status
bindkey '^G^S' git_status

zle -N git_pull_current_branch_from_origin
bindkey '^G^P' git_pull_current_branch_from_origin

zle -N git_fetch
bindkey '^G^F' git_fetch

zle -N percol-src
bindkey '^S' percol-src

case ${OSTYPE} in
darwin*) # Mac OS X
    source ~/.zsh/zsh-notify/notify.plugin.zsh
    export SYS_NOTIFIER=$(which terminal-notifier)
    export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10
    ;;
esac

_orig_bundle=$(which bundle 2> /dev/null)
function bundle() {
    if [ "$1" = "cd" ]; then
        local gem
        if [ "$2" ]; then
            gem=$2
        else
            gem=$($_orig_bundle list | awk '{ print $2 }' | percol)
        fi
        cd $($_orig_bundle show $gem)
    else
        $_orig_bundle $*
    fi
}

# vim: set filetype=zsh :
