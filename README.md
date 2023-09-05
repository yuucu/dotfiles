# dotfiles

## install

```
git clone git@github.com:yuucu/dotfiles.git
cd dotfiles
make install
---
ln -sfnv $(pwd)/.zshrc ~/ 
mkdir -p ~/.config/tmux/ && ln -sfnv $(pwd)/config/tmux/tmux.conf ~/.config/tmux/
ln -sfnv $(pwd)/config/starship.toml ~/.config/ 
ln -sfnv $(pwd)/config/alacritty/alacritty.yml ~/.config/
ln -sfnv $(pwd)/config/nvim/ ~/.config/ 
```

## 参考

### アイコン探し
https://www.nerdfonts.com/cheat-sheet

https://tech-unlimited.com/escape-unicode.html
