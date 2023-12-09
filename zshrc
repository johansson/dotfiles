# Will Johansson's zshrc

SESSION_TYPE=local # unless we figure out it's a remote connection

if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    SESSION_TYPE=remote/ssh
else
    case $(ps -o comm= -p $PPID) in
        sshd|*/sshd)    SESSION_TYPE=remote/ssh;;
    esac
fi

# functions and site functions

add_fpath_if_needed() {
    if [ -x "$1" ]; then
        case "$fpath" in
            *"$1"*) ;; # do nothing, path exists and is in fpath already
            *) fpath+=($1) # path exists, not in fpath, add it to fpath
        esac
    fi
}

PURE_PATH="$HOME/.zsh/pure"

add_fpath_if_needed "$PURE_PATH" # pure prompt
add_fpath_if_needed "$HOME/.zsh/xcode-completions" # Courtesy of Keith Smiley, https://github.com/keith/zsh-xcode-completions/

# PATH

PKG_PATH="/opt/pkg/bin"
CODE_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
BIN_PATH="$HOME/bin"

if [ -x "$PKG_PATH" ]; then
    export PATH="$PKG_PATH:$PATH"
fi

if [ -x "$CODE_PATH" ] && [ "$SESSION_TYPE" = "local" ]; then
    export PATH="$PATH:$CODE_PATH"
fi

if [ -x "$BIN_PATH" ]; then
    export PATH="$PATH:$BIN_PATH"
fi

# add zsh and bash completions

autoload -U compinit; compinit
autoload -U bashcompinit; bashcompinit

# use pure prompt, if it exists

if [ -x "$PURE_PATH" ]; then
    autoload -U promptinit; promptinit
    prompt pure
else
    case $SESSION_TYPE in
        remote*)    PROMPT='%n@%m %1~ %(?.%F{green}.%F{red})%#%f ';;
        *)          PROMPT='%1~ %(?.%F{green}.%F{red})%#%f ';;
    esac
fi

# aliases

if [ -f "$HOME/.zsh_aliases" ]; then
    . $HOME/.zsh_aliases
fi

# env vars

export EDITOR=vim
export CLICOLOR=1

# zsh options

setopt share_history
setopt hist_expire_dups_first
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# unset env vars we don't need anymore

unset SESSION_TYPE
unset PURE_PATH
unset PKG_PATH
unset CODE_PATH
unset BIN_PATH
