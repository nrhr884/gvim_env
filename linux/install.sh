#!/bin/sh
#create link
ln -sf ~/vim-env/_vimrc ~/.vimrc
#install neobundle
mkdir ~/bundle
cd ~/bundle
git clone https://github.com/Shougo/neobundle.vim
