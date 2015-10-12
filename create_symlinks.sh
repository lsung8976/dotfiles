#!/bin/bash
# create symlinks for config files mostly under ~/
# First created in June 2015
# Jun Go gojun077@gmail.com


create_sym()
{
  # this function takes 2 string arguments:
  # (1) path and filename of original file
  # (2) path and filename of the replacement file
  #
  # Given (1), the function will check if the file exists and is a symlink.
  # Depending on what it finds it will do the following
  # + File exists and is not a symlink
  #   - file will be renamed to file.old
  #   - a symlink from (2) will be created in place of (1)
  # + File exists and is a symlink
  #   - exit the function
  # + File does not exist
  #   - create a symlink from (2) to (1)

  if [[ -f $1 && ! -L $1 ]]; then
    mv $1 $1.old
    ln -s $2 $1 
  elif [[ -f $1 && -L $1 ]]; then
    echo -e "$1 exists and is already a symlink.\n"
    exit 0
  else
    ln -s $2 $1
  fi
}



####################################################
# Create Symlinks to dotfiles directly below ~/
####################################################

DOTFILES="bashrc emacs screenrc vimrc conkyrc git-prompt"

for i in $DOTFILES; do
  create_sym "$HOME/.$i" "$HOME/dotfiles/$i"
done


######################################################
# Create Symlinks to files in subdirectories of $HOME
######################################################

#CMUS CONFIG
#LXTERMINAL CONFIG
create_sym "$HOME/.config/lxterminal/lxterminal.conf" "$HOME/dotfiles/lxterminal"
#MAME CONFIG
create_sym "$HOME/.mame/mame.ini" "$HOME/dotfiles/mame.ini"
#OPENBOX CONFIG
create_sym "$HOME/.config/openbox/autostart" "$HOME/dotfiles/openbox-autostart"
#QUODLIBET CONFIG
create_sym "$HOME/.quodlibet/stations" "$HOME/dotfiles/quod_stations"
#TERMINATOR CONFIG
create_sym "$HOME/.config/terminator/config" "$HOME/dotfiles/terminator"
#XFCE CONFIG
create_sym "$HOME/.config/xfce4/terminal/terminalrc" "$HOME/dotfiles/xfceTerm"


######################################################
# Create Symlinks to files in under /root
######################################################

# NOTE: to create symlinks from root_bashrc to ~/root/.bashrc
# your regular user needs to have rwx permissions on /root
# you can achieve this using Access Control Lists
#
# setfacl -m "u:USERNAME:rwx" /root

create_sym "/root/.bashrc" "$HOME/dotfiles/root_bashrc"
create_sym "/root/.vimrc" "$HOME/dotfiles/vimrc"

