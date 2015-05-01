#!/bin/sh
#install global
sudo apt-get install global
#install ag
mkdir ~/envtmp
cd envtmp
git clone https://github.com/ggreer/the_silver_searcher || exit 1
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev || exit 1
cd the_silver_searcher
./build.sh
sudo make install
rm -rf ~/envtmp
