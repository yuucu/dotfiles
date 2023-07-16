eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"

### func or alias
function cd_ghq_list() {
  local destination_dir="$(ghq list --full-path| fzf)"
  if [ -n "$destination_dir" ]; then
    cd $destination_dir
  fi
  echo $destination_dir
}
alias ls="ls -G"
alias lg="lazygit"
alias fgh=cd_ghq_list
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias atheme="npx alacritty-themes"
alias memomv="cd ~/.memolist"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


### zinit plugins
zinit wait lucid blockf light-mode for \
    @'zsh-users/zsh-syntax-highlighting' \
    @'zsh-users/zsh-autosuggestions' \
    @'zsh-users/zsh-completions' \
    @'paulirish/git-open'

### pure prompt
PROMPT='%F{white}%* '$PROMPT

eval "$(starship init zsh)"


### anyenv
# eval "$(anyenv init - --no-rehash)"
if [ -x /usr/local/bin/anyenv ]
then
  if ! [ -f /tmp/anyenv.cache ]
  then
     anyenv init - > /tmp/anyenv.cache
     zcompile /tmp/anyenv.cache
  fi
  source /tmp/anyenv.cache
fi

. /opt/homebrew/opt/asdf/libexec/asdf.sh

### paths
#### goenv
export PATH="$PATH:$(go env GOPATH)/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/s09104/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/s09104/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/s09104/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/s09104/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


eval "$(direnv hook zsh)"

