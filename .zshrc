# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/.cargo/bin:$PATH
source <(sheldon source)

eval "$(zoxide init zsh)"

timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do time $shell -i -c exit; done
}

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

. /home/nicola/.cargo/registry/src/github.com-1ecc6299db9ec823/skim-0.9.3/shell/key-bindings.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias dotfiles='/usr/bin/git --git-dir=/home/nicola/.cfg/ --work-tree=/home/nicola'

