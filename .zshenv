export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=tmux-256color
export COLORTERM=truecolor
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export EDITOR='nvim'
export VISUAL='nvim'
export HISTFILE=$HOME/.zhistory
export SAVEHIST=10000
export HISTSIZE=10000
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_DEFAULT_OPTS='--color=bg:-1,bg+:#4d4d4d,gutter:-1'
