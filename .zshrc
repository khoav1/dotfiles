setopt auto_cd
autoload -Uz compinit; compinit
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
# prevent ctrl-d (eof) from closing the shell (must type `exit`)
# this conflicts with scrolling in tmux copy-mode-vi
setopt IGNORE_EOF
bindkey -e
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word
source ~/.zsh/plugins/git/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM='verbose'
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_COMPRESSSPARSESTATE=true
setopt PROMPT_SUBST
PS1='%B%F{magenta}%0~%f%b% %F{blue}$(__git_ps1 " [%s]") %f%(?..%F{red})%(!.#.$)%f%b '
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
alias vim=nvim
source $HOME/.profile
