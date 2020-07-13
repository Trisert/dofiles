# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

 # To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

colorscript random

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias dotfiles='/usr/bin/git --git-dir=/home/nicola/.dotfiles/ --work-tree=/home/nicola'
alias tsm='transmission-remote'

#source /usr/share/zsh/share/#antigen.zsh

export FZF_DEFAULT_COMMAND="locate /"


# fzf scripts

# Change including hidden directories

fda() {
	local dir
	dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Change directory with strings

cf() {
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

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
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-nvim} "$file"
  fi
)

# fh - repeat history
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/home/nicola/.gem/ruby/2.7.0/bin:$PATH"

export PATH=~/.local/bin:$PATH

export PATH=~/.emacs.d/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh




# Load the oh-my-zsh's library.
 #antigen use oh-my-zsh

# # Bundles from the default repo (robbyrussell's oh-my-zsh).
 #antigen bundle git
 #antigen bundle heroku
 #antigen bundle pip
 #antigen bundle lein
 #antigen bundle command-not-found
 #antigen bundle extract
 #antigen bundle zsh-autosuggestions
 #antigen bundle autojump

# # Syntax highlighting bundle.
 #antigen bundle zsh-users/zsh-syntax-highlighting

# # Load the theme.
 #antigen theme romkatv/powerlevel10k

# # Tell Antigen that you're done.
 #antigen apply

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
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
zinit ice wait'!0'

zinit ice depth=1; 
zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting

zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
zinit snippet 'https://github.com/sorin-ionescu/prezto/blob/master/modules/helper/init.zsh'

zinit snippet OMZ::plugins/git
zinit snippet OMZ::plugins/pip
zinit snippet OMZ::plugins/autojump
zinit light zsh-users/zsh-autosuggestions
zinit snippet OMZ::plugins/extract 
zinit light zdharma/fast-syntax-highlighting 
