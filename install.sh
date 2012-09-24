#!/bin/bash

move_this_dir_to() {
    dest=$1
    p=`pwd`
    src=`basename $p`
    (cd .. && mv "$src" "$dest")
}

move_this_dir_to "~/.dotfiles.git"
