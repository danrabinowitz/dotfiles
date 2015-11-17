#!/usr/bin/env bash
echo "Start of remote install script"

: ${DOTFILES_DIR:="$HOME/.dotfiles"}
DOTFILES_GIT_REPO="https://github.com/danrabinowitz/dotfiles.git"

function ensure_directory_exists_and_is_current() {
  echo "1"
  if git_is_available ; then
    echo "Using git"
    use_git_repo
  elif we_should_use_curl ; then
    echo "Using curl"
    echo "Not implemented"
  else
    echo "ERROR: Unable to get config files"
  fi
}

function git_is_available() {
  (git --version 2>&1 >/dev/null)
  return $?
}

function we_should_use_curl() {
  return 1
}

function use_git_repo() {
  if directory_does_not_exist ; then
    echo "Cloning git repo"
    git clone "$DOTFILES_GIT_REPO" "$DOTFILES_DIR"
  else
    # Directory exists
    if [ directory_is_a_git_repo ] ; then
      echo "Directory exists. Updating it."
      # (cd "$DOTFILES_DIR"; git pull)
    else
      echo "Directory exists, but is not a git repo. Removing and cloning."
      # Remove it, and then git clone
      # rm -rf "$DOTFILES_DIR"
      echo "Prepared to remove: $DOTFILES_DIR"
      git clone "$DOTFILES_GIT_REPO" "$DOTFILES_DIR"
    fi
  fi
}

function directory_does_not_exist() {
  echo "Checking if directory exists"
  if [ ! -d "$DOTFILES_DIR" ] ; then
    return 0
  else
    return 1
  fi
}

function directory_is_a_git_repo() {
  (cd "$DOTFILES_DIR"; git rev-parse --git-dir > /dev/null 2>&1)
  return $?
}

function ensure_symlinks_are_in_place() {
  echo "ensure_symlinks_are_in_place"
  source "${DOTFILES_DIR}/create_symlinks.sh"
}

function update() {
  ensure_directory_exists_and_is_current
  ensure_symlinks_are_in_place
}

function rate_limited_update() {
  if [ -z $SKIP_REMOTE_DOTFILES ] ; then
    # TODO: Rate limit the updates
    update
  else
    echo "Refusing to install or update dotfiles because SKIP_REMOTE_DOTFILES is set."
  fi
}

rate_limited_update
