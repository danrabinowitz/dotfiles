#!/bin/bash
# This script creates symlinks. By default, it deletes any existing files.

#############################################################################
create_symlink_for_dotfiles_git() {
  # echo "Check if $@ exists"
  if [ -f "${HOME}/.$@" -o -d "${HOME}/.$@" -o -L "${HOME}/.$@" ] ; then
    if [ -L "${HOME}/.$@" ] ; then
      # echo "It is a link"
      rm -f "${HOME}/.$@"
    else
      echo "$@ already exists, so it is being moved to $@_orig"
      mv "${HOME}/.$@" "${HOME}/.$@_orig"
    fi
  fi
  ln -s "${DOTFILES_DIR}"/dot."$@" "${HOME}/.$@"
}
#############################################################################
create_symlink_for_dotfiles_git 'bash_profile'
create_symlink_for_dotfiles_git 'bashrc'
create_symlink_for_dotfiles_git 'dircolors'
create_symlink_for_dotfiles_git 'emacs'
create_symlink_for_dotfiles_git 'emacs.d'
create_symlink_for_dotfiles_git 'gitconfig'
create_symlink_for_dotfiles_git 'irbrc'
create_symlink_for_dotfiles_git 'profile'
#create_symlink_for_dotfiles_git 'screenrc'
create_symlink_for_dotfiles_git 'inputrc'
create_symlink_for_dotfiles_git 'psqlrc'
