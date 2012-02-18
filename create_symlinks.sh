#!/bin/bash
# This script creates symlinks. By default, it deletes any existing files.

#############################################################################
create_symlink_for_dotfiles_git() {
if [ -f ".$@" ] ; then
  mv ".$@" ".$@_orig"
fi
ln -s .dotfiles.git/dot."$@" ".$@"
}
#############################################################################
cd
create_symlink_for_dotfiles_git 'bashrc'
create_symlink_for_dotfiles_git 'dircolors'
create_symlink_for_dotfiles_git 'profile'
create_symlink_for_dotfiles_git 'screenrc'
create_symlink_for_dotfiles_git 'emacs'
create_symlink_for_dotfiles_git 'irbrc'

