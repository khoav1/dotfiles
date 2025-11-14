export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export TERM=tmux-256color
export COLORTERM=truecolor
export EDITOR='vim'
export VISUAL='vim'
export HISTFILE=$HOME/.zhistory
export SAVEHIST=10000
export HISTSIZE=10000
export RIPGREP_CONFIG_PATH=~/.ripgreprc
export SDL_VIDEO_DRIVER=wayland
export SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY=1
export WORDCHARS='*?_[]~=/&;!#$%^(){}<>'  # remove -. so they become word boundaries
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
export FZF_DEFAULT_OPTS="--color=fg:#908caa,bg:#191724,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
[[ ! "$PATH" == *$HOME/.fzf/bin* ]] && PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
