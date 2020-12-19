#!/bin/sh

GIT_DOT_REPO="https://github.com/yuucu/dotfiles.git"

DOT_DIR="${HOME}/dotfiles"
DOT_FILES_DIR="${DOT_DIR}/dots"
VIM_PLUG_PATH="${HOME}/.vim/autoload/plug.vim"


# git clone dotfiles
if [ -d "$DOT_DIR" ]; then
  echo "Already downloaded dotfiles"
else
  echo "Downloading dotfiles..."
  mkdir -p $DOT_DIR
  git clone $GIT_DOT_REPO $DOT_DIR
  echo "done."
fi

# install vim.plug
if [ -e "$VIM_PLUG_PATH" ]; then
  echo "Already installed plug.vim"
else
  curl -fLo "$VIM_PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "done."
fi

# link dotfiles
for dot_file in $(find $DOT_FILES_DIR -maxdepth 1 -type f); do
  dot_file_name=$(basename $dot_file)
  ln -svf ${DOT_FILES_DIR}/$dot_file_name ${HOME}/$dot_file_name
done
