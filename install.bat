@echo off
REM _vimrc�̃V���{���b�N�����N���쐬
cd ..
mklink /h .\_vimrc .\gvim_env\_vimrc

REM NeoBundle��Install
mkdir bundle
cd bundle
git clone https://github.com/Shougo/neobundle.vim.git
