#!/bin/bash
# This script creates symlinks. By default, it deletes any existing files.

#############################################################################
create_symlink_for_dotfiles_git() {
if [ -f ".$@" -o -d ".$@" ] ; then
  if [ -L ".$@" ] ; then
    rm ".$@"
  else
    echo "$@ already exists, so it is being moved to $@_orig"
    mv ".$@" ".$@_orig"
  fi
fi
ln -s .dotfiles.git/dot."$@" ".$@"
}
#############################################################################
cd
create_symlink_for_dotfiles_git 'bash_profile'
create_symlink_for_dotfiles_git 'bashrc'
create_symlink_for_dotfiles_git 'dircolors'
create_symlink_for_dotfiles_git 'emacs'
create_symlink_for_dotfiles_git 'emacs.d'
create_symlink_for_dotfiles_git 'gitconfig'
create_symlink_for_dotfiles_git 'irbrc'
create_symlink_for_dotfiles_git 'profile'
create_symlink_for_dotfiles_git 'screenrc'
