SHELL = /bin/bash
GOVERSION = 1.16.4
NVMVERSION = 0.38.0

show_completion_message:
	@echo "Instalation completed"
	@echo "--- IMPORTANT MANUAL STEPS ---"
	@echo "1 - Change your terminal font to Fira Code"
	@echo "2 - Restart your terminal for changes to take effect"
	@echo "3 - Enter your Vim and run :PlugInstall to install all plug-ins"
	@echo "--------"
	@echo "IMPORTANT: DO NOT REMOVE THIS REPOSITORY FOLDER OR YOU'LL LOSE THE SYMLINKS TO THE DOTFILES"

upgrade_linux:
	@echo "Update and upgrade"
	@sudo apt-get update \
		&& sudo apt-get -y upgrade

install_fonts:
	@echo "Downloading fonts"

sync_files:
	@rsync -avrh Linux/.zshrc $(HOME)/.zshrc
	@rsync -avrh Linux/.bashrc $(HOME)/.bashrc
	@rsync -avrh Linux/.gitconfig $(HOME)/.gitconfig
	@rsync -avrh Linux/.config/terminator/config $(HOME)/.config/terminator/config
	@rsync -avrh Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

remove_older_files:
	@echo "Removing older files"
	@rm -rf $(HOME)/.gitconfig $(HOME)/.zshrc $(HOME)/.bashrc $(HOME)/.config/terminator/config \
		$(HOME)/.config/synapse/config.json $(HOME)/Downloads/*.deb $(HOME)/Downloads/get-docker.sh

link_files:
	# @ln -s .Linux/.bashrc $(HOME)/.bashrc
	@ln -s teste $(HOME)/teste
	# @ln -s .Linux/.config/terminator/config $(HOME)/.config/terminator/config
	# @ln -s .Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

install_basic_config:
	@echo "Install dependencies basic desenvolvimts"
	@sudo apt-get install -y \
		build-essential zsh wget curl git \
		terminator synapse plank neovim fzf \
		fonts-powerline fonts-firacode deja-dup jq

	@echo "Installing Oh My Zsh"
	@sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	@echo "Installing Spaceship theme"
	@git clone https://github.com/denysdovhan/spaceship-prompt.git "$(ZSH_CUSTOM)/themes/spaceship-prompt" --depth=1
	@ln -s "$(ZSH_CUSTOM)/themes/spaceship-prompt/spaceship.zsh-theme" "$(ZSH_CUSTOM)/themes/spaceship.zsh-theme"

	@echo "Installing ZSH Plugins"
	@git clone https://github.com/zsh-users/zsh-autosuggestions ${$(ZSH_CUSTOM):-$(HOME)/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	@git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${$(ZSH_CUSTOM):-$(HOME)/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	@cd $(HOME)/Downloads
	@echo "Install vscode"
	@curl "https://az764295.vo.msecnd.net/insider/82767cc1d7bf8cdea0f2897276d5d15aee91f3d9/code-insiders_1.57.0-1621228986_amd64.deb" -o code.deb \
		&& sudo dpkg -i $(HOME)/Downloads/code.deb

	@echo "Install chrome"
	@curl "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o google-chrome.deb \
		&& sudo dpkg -i $(HOME)/Downloads/google-chrome.deb
	@cd $(HOME)

install_langages:
	@cd $(HOME)/Downloads

	@echo "Install Golang"
	@wget "https://golang.org/dl/go$(GOVERSION).linux-amd64.tar.gz" \
    && sudo tar -C /usr/local -xzf go$(GOVERSION).linux-amd64.tar.gz

	@echo "Install nvm"
	@curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$(NVMVERSION)/install.sh | bash

	@echo "Install docker"
	@curl -fsSL https://get.docker.com -o get-docker.sh \
	  && sudo sh get-docker.sh
	@cd $(HOME)

bootstrap: install_basic_config link_files show_completion_message upgrade_linux
