#(cat ~/.cache/wal/sequences &)

source $HOME/.zinit/plugins/romkatv---zsh-defer/zsh-defer.plugin.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd depth=1
zinit light romkatv/powerlevel10k

zinit wait lucid light-mode for \
    OMZ::plugins/extract \
    romkatv/zsh-prompt-benchmark \
    romkatv/zsh-defer

zsh-defer -t 2 source $HOME/.zsh/alias.zsh

zsh-defer -t 2 source $HOME/.zsh/functions.zsh

# Basic auto/tab complete:
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit;
else
    compinit -C;
fi;
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
_comp_options+=(globdots)  # Include hidden files.

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zsh-defer -t 2 source /home/nicola/.cargo/registry/src/github.com-1ecc6299db9ec823/skim-0.9.3/shell/key-bindings.zsh

eval "$(zoxide init zsh)"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
