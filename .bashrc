# EXAMPLE

# customize bashrc by linking in system specific .bash.local
# this could be linked with .config/bin/config-alts
if [ -e ~/.bash.local ]; then
  source ~/.bash.local
fi

# this would be added by .config/bin/config-init
export PATH=$PATH:$HOME/.config/bin
export CONFIG_REPO=.config.repo
alias config='/usr/bin/git --git-dir=$HOME/$CONFIG_REPO/ --work-tree=$HOME'
