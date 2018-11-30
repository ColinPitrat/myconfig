if [ "`hostname`" == "virtuarch" ]
then
  if [ "$TERM" != "screen" ]
  then
    screen -RR
    exit
  fi
fi

alias ls='ls --color=auto'
alias vi=vim
alias bc='bc -l'

export PS1='[\u@\h \W]\$ '
export PS1="\[\e[1;34m\][\[\e[1;35m\]\T\[\e[1;34m\]] [\[\e[1;31m\]\u\[\e[1;37m\]@\[\e[1;32m\]\h\[\e[1;37m\]:\[\e[1;33m\]\w\[\e[1;34m\]]\[\e[1;37m\]\$ "
export EDITOR=vim
export SDL_AUDIODRIVER=alsa
export GOPATH=$HOME/Programmation/Go
export PATH=$HOME/bin:$PATH:$GOPATH/bin

if [ -f $HOME/.bashrc.local ]
then
  source $HOME/.bashrc.local
fi

# Rust
source $HOME/.cargo/env
