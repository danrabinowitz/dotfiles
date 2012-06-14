#!/bin/bash
# This script installs the git@github.com:danrabinowitz/dotfiles.git github repo and calls the script to set up symlinks.
# It is run locally by:
# initial_install_over_ssh.sh user@remotehost

ssh $@ 'curl -o danrabinowitz-dotfiles.tgz https://nodeload.github.com/danrabinowitz/dotfiles/tarball/master; tar xzf danrabinowitz-dotfiles.tgz; mv danrabinowitz-dotfiles-* .dotfiles.git; rm danrabinowitz-dotfiles.tgz; .dotfiles.git/create_symlinks.sh'
scp -r ~/.emacs.d/lisp ~/.emacs.d/vendor $@:.emacs.d/





# TODO: Use git if it is installed. Check if curl is installed. Else fail gracefully.
