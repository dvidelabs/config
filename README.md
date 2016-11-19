# Config scripts for managing dotfiles on private hosts

Users often share their dotfiles on github no so much for social
reasons as because it makes it very simple to bootstrap new hosts with
these dotfiles. It is much more difficult to pull from a private
repository because it requires upload of a private ssh key on one host
in order to fetch dotfiles on another host. This may not be desirable.

Here we present the reverse setup where a local repository can be pushed
to a new remote private server. This server must have a public ssh key
uploaded but then the config scripts take over without requiring any
separate hosting.

For actual dotfile management we use the novel approach already
developed by others where we define a `config` shell function the calls
git with a detached `--worktree`. This requires no scripts and nearly
no configuration at all. Still, we present a few scripts to help this
process.

## References

- <https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>
- <https://dotfiles.github.io>

## Quickstart

Both fish and bash shells are supported and it would not be difficult to
add support for other shells.

Assuming bash shell:

Copy .config/bin in this repository into `~/.config/bin` and run:

    ~/.config/bin/config-init
    source ~/.bashrc

Now a git repository has been created in ~/.config.repo and the script
files have been added to this repo.


## Overview

This project provides a few scripts to help with this setup and add a
few features that helps share private dot files on new remote servers.
it also supports a very simple and fully optional way to handle
different operating systems without branching by the use of a minimal
set of symlinks.

The basic idea is the use of the git `--worktree` feature:

    REPO=$HOME/${CONFIG_REPO:-.config.repo}

    function config {
       /usr/bin/git --git-dir=$REPO/ --worktree=$HOME $@
    }

This can actually be copied into .bashrc along with `git init
~/.config.repo`, but the config-init scripts automates this and a few
other steps such as making sure that all files in the home directory are
ignored by default.


## config-init

The script `.config/bin/config-init` adds the config function to
`~/.bashrc` and to `~/.config/fish/config.fish`, creates a
`~/.config.repo` git repo and adds the modified files and the
~/.config/bin` scripts to this repo.

Usually this is ever only done once since any new system uses other scripts to push the
current config repo to remote hosts via rsync where the repo can be
checked out and thus reproduce.

Once init has been run, add dot files as needed:

    config add -f ~/.bash.local
    config add -f ~/.vimrc
    ...
    config commit -m "Added personal dot files"

The `-f` is required because all files are ignored by default.

The init script adds `~/.config/bin` to the `PATH` variable so all the
`config-` prefixed commands are avaialbe directly. It is also possible
to add user scripts to this bin folder:

    config add -f ~/.config/bin/myscript.sh
    config commit -m  "Add custom script"

Note that `git status` will not show anything while `config status` will
work as intended.


## config-upload

It is important to note that it is perfectly possibly to skip this step
and move a git reposity by any suitable transport followed by checkout.
This script merely automates things like difficult to remember rsync
syntax and handles a rudimentary backup of overwritten files.

The config-upload script accepts a remote host name argument and will
rsync the repo to the remote host and optionally run some install
scripts to ensure a sufficiently new version of git is installed, and
the check out the repo so the dot files gets populated.

See `config-upload -h` for details.

The upload script moves existing files covered by the repo into a backup
tarball, but it is not fool proof because the tarball could be
overwritten be repeated uploads.

It is possible to have multiple remote hosts with different names and
these can be tracked with:

    config remote show

When loggin in to the remote host after the first upload run
`config-setup` if alternatives are being used - see below.

The upload procedure also adds the new host to the local git repo with
an optional name (see -h).

Local changes can be pushed using for example:

    config push origin
    config push myotherhost

The remote repo name can be given as an upload argument.

When logging in to the remote host after a push, use `config-sync` and
optionally `config-alts` as discussed below.

## config-sync

After pushing changes to a remote host the home directory needs to be
updated on the affected host using:

    config-sync

Any OS specific configurations are automatically linked if the
`config-alts` mechanism is being used.

Please inspect the script and make sure it works with your
mode of operation because it does call --reset on the branch - otherwise
the sync does not seem to work correctly.

`config-sync` is also used after fetching or pulling a change from a
remote host:

    config pull myotherhost

When logging in to the remote host, the latest changes only reside in
the git repository, not in the home directory.

Note: config-upload should only be called once for each remote system.
After that use `config push origin` and run `config-sync` as appropriate.

## config-alts

It is possible to have some files different on different systems or for
different purposes. For example, `~/.bash.local` might differ between MacOS
and Linux. Other files such as `~/.gitconfig` might differ based on the
current use by changing commit credentials.

The alternate system is very simple but powerful:

There is an optional file `~/.config/alts/alts.conf` that must list the
path to all files relative to home directory where a file should be
optional or have multiple alternatives.

Each alternative has a name. Some names are taken from the current OS
name such as `osx` or `ubuntu`. Other names are enterily custom such as
`work` and `hobby` and `misc`. Each name is simply a directory such as
`~/.config/alts/osx`.

Each of these alternative directories act as a home directory for only
these alternative files and the file is then linked into the real home
directory.

For example, to `~/.bash.local` to ubuntu, but not osx simply create or
move the file into `~/.config/alts/ubuntu/bash.local` and make sure
`~/.bash.local` is absent. Then add a the entry the alts.conf and commit
everything using `config add -f ...`:

    mkdir -p ~/.config/alts/ubuntu
    mv ~/.bash.local ~/.config/alts/ubuntu
    echo ~/.bash.local >> ~/.config/alts/alts.conf
    config add -f ~/.config/alts

If a default version should exist for all systems that does not have a
default, simply add the default version to the default folder, such as
`touch ~/.config/alts/default/.bashrc`.

After doing the above which have no automated script support, the
alternative file (or files) needs to be symlinked back into the home
directory. This is done with

    config-alts

This script simply reads the alts.conf file, links the default if
present, the repeats to link files in the current os name if such a
folder exists. This might overwrite the default linked file and for some
systems the file will be entirely absent if the default is missing.

It is important not to add the symlinked files to source control
otherwise these files cannot be absent on some systems.

Custom alternatives:

    config-alts hobby misc


If we are running on ubuntu, the above is the same as running:

    config-alts default ubuntu hobby misc

Alt works by simply searching files and linking them in order.

Later we can change to work using

    config-alts work misc

Symbolic links will not be removed, only added or replaced.

As an example note that `~/.gitconfig` can include files and we can thus
use this with the alts meachinsm to switch git user name and email
easily.

When calling config-sync, config-alts is also called so the default and
current os files are linked, but we may still need to change our git
user name etc. by calling `config-alts devops` etc.

When calling config-upload, `config-sync` is automatically called and
therefore also `config-alts` with default and OS alternatives. This
ensures, as an example, that the proper host variant of `.bash.local`
will be present if `.bash.local` has been added as an alternative.

## config-install

The `config-install` script is normally called by `config-upload` and is
not used directly. However, it can be used to check out an existing repo with
support for backuping up files that would be overwritten.

## config-setup

A tiny wrapper around `config-alts` that makes it possible to remember
custom alternatives. At may be run a second time in a fresh shell to
take advantage of settings linked in by the first run. See script source
for details.

## bin dir

The config scripts are hosted in ~/.config/bin by default and a path is
added to this directory. This means that this bin directory is also
suitable for other custom scripts. For example if a script is used to
push to github or update ghpages, it would make sense to place in
.config/bin using `config add -f ~/.config/bin/myscript`. The alts
mechanism can even be used to very the script by OS type.
