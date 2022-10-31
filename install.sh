#!/bin/bash

echo +++++ Linking dotfiles
ln -s $(pwd)/.gitconfig $HOME/.gitconfig
ln -s $(pwd)/.doom.d $HOME/.doom.d
ln -s $(pwd)/.vimrc $HOME/.vimrc
ln -s $(pwd)/.vim $HOME/.vim
ln -s $(pwd)/.zsh $HOME/.zsh
ln -s $(pwd)/.zshrc $HOME/.zshrc
ln -s $(pwd)/.zshrc.zni $HOME/.zshrc.zni
ln -s $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -s $(pwd)/.mbsyncrc $HOME/.mbsyncrc
ln -s $(pwd)/.notmuch-config $HOME/.notmuch-config
ln -s $(pwd)/kitty $HOME/.config/kitty

echo +++++ Install Doom Emacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
~/.emacs.d/bin/doom install
