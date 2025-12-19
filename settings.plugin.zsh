0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

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

###################
# functions
###################

function md() {
  pandoc $@ | lynx -stdin
}

function mdpdf() {
  if [ -f "$2" ]; then
    echo Error: output file exists
  elif [ ! -f "$1" ]; then
    echo Error: input file not found
  else
    DATA_DIR="$(mktemp -d -p /tmp mdpdf.XXXXXXXX)"
    mkdir $DATA_DIR
    pandoc \
      --from=markdown \
      --to=pdf \
      --data-dir $DATA_DIR \
      -o $2 $1
    rm -r $DATA_DIR
  fi
}

function fuck() {
  local last_command=$(fc -n -l -1 -1)
  echo "Executing: sudo $last_command"
  echo -n "Continue? (Y/n) "
  read -r response
  if [[ $response =~ ^([Yy][Ee][Ss]|[Yy]|)$ ]]; then
    bash -c "sudo $last_command"
    return 0
  else
    echo "Aborted."
    return 1
  fi
}

function ,() {
  command $@
}

function vault() {
  DEFAULT_VAULT=cert
  CONFIG_PATH="$HOME/.config/vaults.json"
  SELECTED_VAULT=

  function cryfs-vault-open() {
    cryfs \
      -o allow_root \
      --unmount-idle 5 \
      $(jq -r --arg p "$SELECTED_VAULT" '.[$p].e' "$CONFIG_PATH") \
      $(jq -r --arg p "$SELECTED_VAULT" '.[$p].m' "$CONFIG_PATH")
  }

  function cryfs-vault-close() {
    cryfs-unmount \
      $(jq -r --arg p "$SELECTED_VAULT" '.[$p].m' "$CONFIG_PATH")
  }

  function gocryptfs_vault_open() {
    gocryptfs -nodev -noexec -nosuid -acl -i 15m -ro -allow_other $(jq -r --arg p "$SELECTED_VAULT" '.[$p].e' "$CONFIG_PATH") $(jq -r --arg p "$SELECTED_VAULT" '.[$p].m' "$CONFIG_PATH")
  }

  function gocryptfs_vault_close() {
    fusermount -u \
      $(jq -r --arg p "$SELECTED_VAULT" '.[$p].m' "$CONFIG_PATH")
  }
  if [[ $# -eq 2 ]]; then
    SELECTED_VAULT="$2"
  elif [[ $# -eq 1 ]]; then
    SELECTED_VAULT=$DEFAULT_VAULT
  fi
  case $1 in
  "open")
    gocryptfs_vault_open $SELECTED_VAULT
    ;;
  "close")
    gocryptfs_vault_close $SELECTED_VAULT
    ;;
  *)
    echo "error: unkown option $1, [open|close] VAULTNAME"
    return 1
    ;;
  esac
}
