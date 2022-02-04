#!/bin/bash

# See also comments in `.config/alts/alts.conf`.

SETUP=$(dirname $0)

OS=$($SETUP/detect-os.sh)

ALTS_SRC=$HOME/.config/alts
ALTS_CONF=$ALTS_SRC/alts.conf

function mk_links() {
    if [ -d "$LINKS_SRC/$1" ] ; then
        echo "processing alternative configuration: $1"
        # http://stackoverflow.com/a/28806991
        # egrep strips comments and blank lines
        [ -e $ALTS_CONF ] && cat $ALTS_CONF | \
            egrep -v '^[[:space:]]*$|^ *#' | \
            tr '\n' '\0' | xargs -0 -I{} $SETUP/link_file.sh $1 {}
    else
        echo "skipping missing alternative configuration: $1"
    fi
}

mk_links $ALTS_SRC/default
mk_links $ALTS_SRC/$OS

while [[ $# > 0 ]]
do
    mk_links $ALTS_SRC/$1
    shift
done
