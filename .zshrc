(cat ~/.cache/wal/sequences &)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit ice silent wait '2!'
zinit light-mode for \
     zinit-zsh/z-a-rust \
     zinit-zsh/z-a-as-monitor \
     zinit-zsh/z-a-patch-dl \
     zinit-zsh/z-a-bin-gem-node

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-autosuggestions

zinit ice silent wait '2!'
zinit light zdharma/fast-syntax-highlighting

zinit ice silent wait '2!'
zinit snippet OMZ::plugins/autojump
 
zinit ice silent wait '2!'
zinit snippet OMZ::plugins/extract

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias dotfiles='/usr/bin/git --git-dir=/home/nicola/.cfg/ --work-tree=/home/nicola'

# fzf scripts

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# Open file
fo() (
  IFS=$'\n' out=("$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
  fi
)

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

 # Basic auto/tab complete:
autoload -Uz compinit ; compinit
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#zmodload zsh/complist
#compinit
#_comp_options+=(globdots)		# Include hidden files.

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
