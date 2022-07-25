export ZSH="$HOME/.oh-my-zsh"
export FLUTTER_ROOT="$(asdf where flutter)"

ZSH_THEME=""

HIST_STAMPS="mm/dd/yyyy"

plugins=(
  git
  nvm
  vscode
  fzf
  docker
  docker-compose
  golang
  node
	nvm
	npx
	npm
	asdf
	flutter
)

source $ZSH/oh-my-zsh.sh

alias cd..="cd .."
alias cd~="cd ~"
alias lss="exa -a --long --header --git"
alias cat="bat"
alias docker-rmi="docker rmi -f $(docker images -aq)"
alias docker-rm="docker rm -f $(docker ps -aq)"

eval "$(starship init zsh)"
. ~/.asdf/plugins/java/set-java-home.zsh

source ~/.zinit/bin/zinit.zsh

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light spaceship-prompt/spaceship-prompt
