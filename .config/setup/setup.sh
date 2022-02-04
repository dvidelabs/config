#!/bin/bash

# Here additional install scripts can be added such
# as installing brew tools on os-x and apt-get on Ubuntu.
#
# Note that some OS specific features such as terminal fonts on OS-X
# can be handled by adding ~/Library/Fonts/<myfont> to the config
# repo in an OS specific branch.


SETUP=$(dirname $0)

OS=$($SETUP/detect-os.sh)

[ -e $SETUP/$OS/setup.sh ] && $SETUP/$OS/setup.sh

