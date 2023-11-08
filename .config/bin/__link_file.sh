#!/bin/bash

# Helper function to simplify xargs expansion.

# We may overwrite a link we just created because
# default links may be added before OS specific
#
#   link linkdir relpath

SRC=$1/$2
DST=$HOME/$2
DST_DIR=$(dirname $DST)
if [ -e $SRC ] ; then
    # if not a symbolic link, back it up
    if [ -e $DST ] && [ ! -L $DST ] ; then
        echo "  backing up '$DST' to '$DST.backup'"
        mv $DST $DST.backup
    fi
    if [ ! -d "$DST_DIR" ]; then
        echo "  creating directory '$DST_DIR'"
        mkdir -p $DST_DIR
    fi
    echo "  linking $DST"
    ln -sf $SRC $DST
fi
