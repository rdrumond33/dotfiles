SHELL = /bin/bash
GOVERSION = 1.16.4
NVMVERSION = 0.38.0
ZSH_CUSTOM = $(HOME)/.oh-my-zsh/custom/plugins
TEMP_DIR = ./Linux/temp
DOCKER_COMPOSE_VERSION = 1.29.2

.PHONY: all
all: bootstrap
FORCE: ;

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
	@wget -O $(TEMP_DIR)/Anonymous-fonts.zip https://fonts.google.com/download\?family\=Anonymous%20Pro \
		&& unzip $(TEMP_DIR)/Anonymous-fonts.zip -d $(TEMP_DIR)/Anonymous-fonts \

	# Create file if not existis
	@[ -d "$(HOME)/.fonts" ] || mkdir -p $(HOME)/.fonts
	@mv $(TEMP_DIR)/Anonymous-fonts/*.ttf $(HOME)/.fonts

	@rm -rf $(TEMP_DIR)/Anonymous-fonts \
		$(TEMP_DIR)/Anonymous-fonts.zip

sync_files:
	@rsync -avrh Linux/.zshrc $(HOME)/.zshrc
	@rsync -avrh Linux/.bashrc $(HOME)/.bashrc
	@rsync -avrh Linux/.gitconfig $(HOME)/.gitconfig
	@mkdir -p $(HOME)/.config/terminator/ && rsync -avrh Linux/.config/terminator/config $(HOME)/.config/terminator/config
	@mkdir -p $(HOME)/.config/synapse/ && rsync -avrh Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

remove_older_files:
	@echo "Removing older files"
	@rm -rf $(HOME)/.zshrc \
		$(HOME)/.bashrc \
		$(HOME)/.gitconfig \
		$(HOME)/.config/terminator/config \
		$(HOME)/.config/synapse/config.json

link_files:
	@[ -d "$(HOME)/.config/terminator" ] || mkdir -p $(HOME)/.config/terminator
	@[ -d "$(HOME)/.config/synapse" ] || mkdir -p $(HOME)/.config/synapse

	@ln Linux/.zshrc $(HOME)/.zshrc
	@ln Linux/.bashrc $(HOME)/.bashrc
	@ln Linux/.gitconfig $(HOME)/.gitconfig
	@ln Linux/.config/terminator/config $(HOME)/.config/terminator/config
	@ln Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

install_development_tools:
	@echo "Install vscode"
	@wget -O $(TEMP_DIR)/vscode.deb "https://az764295.vo.msecnd.net/stable/054a9295330880ed74ceaedda236253b4f39a335/code_1.56.2-1620838498_amd64.deb" \
		&& sudo dpkg -i $(TEMP_DIR)/vscode.deb \
		&& rm -f $(TEMP_DIR)/vscode.deb

	@echo "Install chrome"
	@wget -O $(TEMP_DIR)/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
		&& sudo dpkg -i $(TEMP_DIR)/google-chrome.deb \
		&& rm -f $(TEMP_DIR)/google-chrome.deb

install_basic_config:
	@echo "Install dependencies basic desenvolvimts"
	@sudo apt-get install -y \
		build-essential zsh wget curl git \
		terminator synapse plank neovim fzf \
		fonts-powerline fonts-firacode deja-dup jq

	@echo "Installing Oh My Zsh"
	@wget -O $(TEMP_DIR)/OhMyZsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		&& sh $(TEMP_DIR)/OhMyZsh.sh --unattended \
		&& rm -f $(TEMP_DIR)/OhMyZsh.sh

	@[ -d "$(HOME)/.zinit" ] || mkdir -p $(HOME)/.zinit
	@git clone https://github.com/zdharma/zinit.git $(HOME)/.zinit/bin

install_langages:
	@echo "Install Golang"
	@wget -O $(TEMP_DIR)/go-install.tar.gz "https://golang.org/dl/go$(GOVERSION).linux-amd64.tar.gz" \
    && sudo tar -C /usr/local -xzf $(TEMP_DIR)/go-install.tar.gz \
		&& rm -f $(TEMP_DIR)/go-install.tar.gz

	@echo "Install nvm"
	@wget -O $(TEMP_DIR)/nvm-install.sh https://raw.githubusercontent.com/nvm-sh/nvm/v$(NVMVERSION)/install.sh \
		&& sh $(TEMP_DIR)/nvm-install.sh \
		&& rm -f $(TEMP_DIR)/nvm-install.sh

	@echo "Install docker"
	@wget -O $(TEMP_DIR)/get-docker.sh https://get.docker.com \
	  && sudo sh $(TEMP_DIR)/get-docker.sh \
		&& rm -f $(TEMP_DIR)/get-docker.sh

	@echo "Install docker-compose"
	@sudo curl -L "https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	@sudo chmod +x /usr/local/bin/docker-compose

bootstrap: install_basic_config install_langages install_fonts remove_older_files link_files install_development_tools upgrade_linux show_completion_message
