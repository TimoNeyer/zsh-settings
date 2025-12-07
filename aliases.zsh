###################
# basic application
# replacemtents
###################
alias cd='z'
if command -v eza > /dev/null; then
  alias ls='eza --no-permissions --no-time --icons=auto --group-directories-first -gMo --smart-group '
fi
alias ll='ls -l'
alias la='ls -la'
if command -v bat > /dev/null; then
  alias cat='bat'
fi
if command -v doas > /dev/null; then
  alias sudo='doas'
fi
if command -v podman > /dev/null; then
  alias docker=podman
fi
if command -v toolbox > /dev/null; then
  alias tbd='toolbox enter dev'
  alias tbx='toolbox'
fi

###################
# shortcuts
###################
alias ..='cd ..'
alias ...='cd ../../'
alias q='exit'

###################
# prevent mishaps
###################
alias mv='mv -i'
alias cp='cp -ir'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

###################
# auto coloring
###################
alias dir='ls --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

###################
# extended
# applications
# replacemtents
###################

if command -v fping > /dev/null; then
  alias ping='fping -c 10'
  alias ping4='fping -4'
  alias ping6='fping -6'
fi
alias venv='python3 -m venv'

###################
# application
# shortcuts
###################
alias vi='vim'
alias svim='sudo vim'
alias py='python3'
alias con='nmcli'
alias wificon='nmcli --ask dev wifi connect '

###################
# custom overrides
###################
alias ,sshe='ssh -O exit'
if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh='kitten ssh'
fi
