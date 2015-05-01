#!/bin/sh
#create link
ln -sf ~/vim-env/_vimrc ~/.vimrc
#install neobundle
mkdir ~/bundle
cd ~/bundle
git clone https://github.com/Shougo/neobundle.vim
#install ag
sudo apt-get install silversearcher-ag
#install global
sudo apt-get install global
