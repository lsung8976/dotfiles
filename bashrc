#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export BROWSER=firefox
export EDITOR=vim
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export TERM=xterm-256color

if [ -f  /usr/sbin/pacman ]; then
  archey3 # Archlinux only
fi

PS1='[\u@\h \W]\$ '
alias ls='ls --color=auto'
alias pxe='cd /usr/local/tftpboot/pxelinux'
alias meditation='cd /usr/local/apache2/htdocs/cam1'
alias vi='vim'
#alias fbterm='fbterm -n "WenQuanYi Micro Hei" --font-width=11 -s 14'
alias ㅊㅇ='cd'
alias 니='ls'
alias wanderer='cd /MULTIMEDIA/vagrant_boxen'
alias startxfce4='ssh-agent startxfce4'
# When you run ssh-agent for the first time, you need to add
# your private key(s) with 'ssh-add /path/to/priv/key'
alias genpw='date +%s | sha256sum | base64 | head -c 32 ; echo'
alias wine='WINEARCH=win32 WINEPREFIX=/MULTIMEDIA/wine /usr/bin/wine'

# vim: ts=2 sw=2 et :

# Programing Box
alias box='cd ~/MULTIMEDIA/box'
