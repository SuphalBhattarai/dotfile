#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
alias ls='ls -lah --color=auto'
alias cp='cp -r -v'
alias mv='mv -v'
# Common alias for me
alias ..='cd ..'
alias poweroff='shutdown -h now'
alias shutdown='shutdown -h now'
alias vi='vim'
alias vim='sudo vim'
alias neofetch='clear && neofetch'
alias mount='sudo mount'
alias umount='sudo umount'
# Special alias
alias p='sudo pacman'
alias update='yay -Syu'
alias aur='yay -S'
alias ins='sudo pacman -S'
alias tsm='transmission-remote'
alias tsmstart='transmission-daemon'
alias d='wget'
alias torrents='sh ~/.scripts/torrents.sh'

ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line

