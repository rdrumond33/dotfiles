CURRENTDIR=$(shell pwd)

VERSION_JAVA:=openjdk-18.0.2
VERSION_ASDF:=0.10.2
VERSION_GOLANG:=1.18.4
DIR_TEMP=$(CURRENTDIR)/Linux/temp

ZSH_CUSTOM = $(OMYZSHDIR)/custom/plugins

ASDF_URL:=https://github.com/asdf-vm/asdf.git

APP_DEFAULTS=build-essential curl git \
	zsh wget curl git terminator synapse plank neovim fzf \
	fonts-powerline fonts-firacode deja-dup jq coreutils \
	dirmngr gpg gawk libsigsegv2 pass tree uidmap

FONT_DIR:=$(HOME)/.fonts
ASDF_DIR:=$(HOME)/.asdf
OMYZSH_DIR:=$(HOME)/.oh-my-zsh
ZINIT_DIR:=~/.local/share/zinit
TERMINATOR_DIR:=$(HOME)/.config/terminator
SYNAPSE_DIR:=$(HOME)/.config/synapse
HADOLINT_BIN:=/usr/bin/hadolint

PLUGINS_ASDF:=$(HOME)/.asdf/plugins
PLUGINS_ASDF_RUST:=$(PLUGINS_ASDF)/rust
PLUGINS_ASDF_GOLANG:=$(PLUGINS_ASDF)/golang
PLUGINS_ASDF_NODE:=$(PLUGINS_ASDF)/nodejs
PLUGINS_ASDF_JAVA:=$(PLUGINS_ASDF)/java

GREEN:=$(shell tput -Txterm setaf 2)
YELLOW:=$(shell tput -Txterm setaf 3)
WHITE:=$(shell tput -Txterm setaf 7)
CYAN:=$(shell tput -Txterm setaf 6)
RESET:=$(shell tput -Txterm sgr0)

.PHONY: all
all: help

$(FONT_DIR):
	@echo Create Folder .fonts
	@mkdir -p $(HOME)/.fonts

$(CURRENTDIR)/Linux/temp/Anonymous.zip:
	@cd $(DIR_TEMP) && wget -c  -O Anonymous.zip https://fonts.google.com/download\?family\=Anonymous%20Pro \
		&& unzip Anonymous.zip -d Anonymous

$(CURRENTDIR)/Linux/temp/docker.deb:
	@cd $(DIR_TEMP) \
		&& wget -c  -O docker.deb  "https://desktop.docker.com/linux/main/amd64/docker-desktop-4.10.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64" \

$(CURRENTDIR)/Linux/temp/code.deb:
	@cd $(DIR_TEMP) \
		&& wget -c  -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

$(CURRENTDIR)/Linux/temp/chrome.deb:
	@cd $(DIR_TEMP) \
		&& wget -c  -O chrome.deb "https://www.google.com/chrome/thank-you.html?statcb=0&installdataindex=empty&defaultbrowser=0#"

$(ASDF_DIR):
	@echo "Install asdf"
	@git clone $(ASDF_URL) ~/.asdf --branch v$(VERSION_ASDF) \
		&& echo ". $(HOME)/.asdf/asdf.sh" >> $(HOME)/.bashrc

$(OMYZSH_DIR):
	@echo "Install oh-my-zsh"
	@cd $(DIR_TEMP) \
		&& wget -c  -O ohmyzsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
		&& sh ohmyzsh.sh --unattended \

$(ZINIT_DIR):
	@$(shell bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)")

$(TERMINATOR_DIR):
	@echo "Create config terminator"
	@mkdir -p $(HOME)/.config/terminator

$(SYNAPSE_DIR):
	@mkdir -p $(HOME)/.config/synapse

$(HADOLINT_BIN):
	@echo "install Hadolint"
	@sudo cp $(CURRENTDIR)/Linux/usr/bin/hadolint /usr/bin/hadolint

$(PLUGINS_ASDF_RUST):
	@asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git

$(PLUGINS_ASDF_GOLANG):
	@asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

$(PLUGINS_ASDF_NODE):
	@asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

$(PLUGINS_ASDF_JAVA):
	@asdf plugin-add java https://github.com/halcyon/asdf-java.git

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

show_completion_message:
	@echo "Instalation completed"
	@echo "--- IMPORTANT MANUAL STEPS ---"
	@echo "1 - Change your terminal font to Fira Code"
	@echo "2 - Restart your terminal for changes to take effect"
	@echo "3 - Enter your Vim and run :PlugInstall to install all plug-ins"
	@echo "--------"
	@echo "IMPORTANT: DO NOT REMOVE THIS REPOSITORY FOLDER OR YOU'LL LOSE THE SYMLINKS TO THE DOTFILES"

## Linux
upadate: ## Update and upgrade
	@sudo apt update \
		&& sudo apt dist-upgrade -y

.PHONY: install-vscode
install-vscode:
	@echo "Install vscode"
	@cd $(DIR_TEMP) \
		&& sudo dpkg -i code.deb

.PHONY: install-chrome
install-chrome: $(CURRENTDIR)/Linux/temp/chrome.deb
	@echo "Install chrome"
	@cd $(DIR_TEMP) \
		&& sudo dpkg -i $(TEMP_DIR)/chrome.deb \

install-golang: $(ASDF_DIR) $(PLUGINS_ASDF_GOLANG)
	@echo "Install golang $(VERSION_GOLANG)"
	@asdf install golang $(VERSION_GOLANG) \
		&& asdf global golang $(VERSION_GOLANG)

install-node: $(ASDF_DIR) $(PLUGINS_ASDF_NODE)
	@echo "Install node"
	@asdf install nodejs latest \
		&& asdf global nodejs latest

install-rust: $(ASDF_DIR) $(PLUGINS_ASDF_RUST)
	@echo "Install rust"
	@asdf install rust stable \
		&& asdf global rust stable \
		&& cargo install ytop exa bat starship --locked

install-java: $(ASDF_DIR) $(PLUGINS_ASDF_JAVA)
	@echo "Install Java"
	@asdf install java $(VERSION_JAVA) \
		&& asdf global java $(VERSION_JAVA)

install-docker: $(CURRENTDIR)/Linux/temp/docker.deb
	@echo "Install docker"
	@cd $(DIR_TEMP) \
	  && sudo dpkg -i docker.deb

install-hadolint: $(HADOLINT_BIN)
	@echo "Hadolint installed"

install-znit:
	@$(shell bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)")

# install-vscode install-chrome
install: fonts install-docker install-hadolint install-rust install-golang install-node install-java ## install apps default
	@sudo apt install -y $(APP_DEFAULTS) \
		&& sudo apt autoremove

clean:
	@cd $(DIR_TEMP) && rm -rf Anonymous* \
		Fira_Code* \
		code.* \
		ohmyzsh.sh \
		docker.deb

fonts: $(FONT_DIR) $(CURRENTDIR)/Linux/temp/Anonymous.zip
	@echo "Downloading fonts"
	@cd $(DIR_TEMP) \
		&& cp Anonymous/*.ttf $(HOME)/.fonts

sync_files:
	@rsync -avrh Linux/.zshrc $(HOME)/.zshrc
	@rsync -avrh Linux/.bashrc $(HOME)/.bashrc
	@rsync -avrh Linux/.gitconfig $(HOME)/.gitconfig
	@mkdir -p $(HOME)/.config/terminator/ && rsync -avrh Linux/.config/terminator/config $(HOME)/.config/terminator/config
	@mkdir -p $(HOME)/.config/synapse/ && rsync -avrh Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

backup_files:
	@echo "backup older files"
	@cp $(HOME)/.zshrc \
		$(HOME)/.bashrc \
		$(HOME)/.gitconfig \
		$(HOME)/.config/terminator/config \
		$(HOME)/.config/synapse/config.json \
		$(CURRENTDIR)/backups_files/backup \
		2>/dev/null || :

remove_older_files:
	@echo "Removing older files"
	@rm -rf $(HOME)/.zshrc \
		$(HOME)/.bashrc \
		$(HOME)/.gitconfig \
		$(HOME)/.config/terminator/config \
		$(HOME)/.config/synapse/config.json

# link_files:
# 	@[ -d "$(HOME)/.config/terminator" ] || mkdir -p $(HOME)/.config/terminator
# 	@[ -d "$(HOME)/.config/synapse" ] || mkdir -p $(HOME)/.config/synapse

# 	@ln Linux/.zshrc $(HOME)/.zshrc
# 	@ln Linux/.bashrc $(HOME)/.bashrc
# 	@ln Linux/.gitconfig $(HOME)/.gitconfig
# 	@ln Linux/.config/terminator/config $(HOME)/.config/terminator/config
# 	@ln Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

bootstrap: backup_files install
