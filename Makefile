SHELL=/bin/bash
CURRENTDIR=$(shell pwd)

DOCKER_INSTALLED:=$(shell docker -v  > /dev/null && echo 1 || echo 0)
CODE_INSTALLED:=$(shell code -v  > /dev/null && echo 1 || echo 0)
CHROME_INSTALLED:=$(shell google-chrome --version > /dev/null && echo 1 || echo 0)

VERSION_JAVA:=openjdk-18.0.2
VERSION_ASDF:=0.10.2
VERSION_GOLANG:=1.18.4
VERSION_FLUTTER:=3.0.5-stable
VERSION_RUST:=stable
VERSION_NODE:=latest

ASDF_URL:=https://github.com/asdf-vm/asdf.git
DOCKER_URL:=https://desktop.docker.com/linux/main/amd64/docker-desktop-4.10.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64
CODE_URL:=https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
CHROME_URL:=https://www.google.com/chrome/thank-you.html?statcb=0&installdataindex=empty&defaultbrowser=0#
ANONYMOUS_URL:=https://fonts.google.com/download\?family\=Anonymous%20Pro
OMYZSH_URL:=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

TEMP_DIR=$(CURRENTDIR)/temp
FONT_DIR:=$(HOME)/.fonts
ASDF_DIR:=$(HOME)/.asdf
OMYZSH_DIR:=$(HOME)/.oh-my-zsh
ZINIT_DIR:=$(HOME)/.local/share/zinit
TERMINATOR_DIR:=$(HOME)/.config/terminator
SYNAPSE_DIR:=$(HOME)/.config/synapse
HADOLINT_DIR_BIN:=/usr/bin/hadolint

PLUGINS_ASDF:=$(ASDF_DIR)/plugins
PLUGINS_ASDF_RUST:=$(PLUGINS_ASDF)/rust
PLUGINS_ASDF_GOLANG:=$(PLUGINS_ASDF)/golang
PLUGINS_ASDF_NODE:=$(PLUGINS_ASDF)/nodejs
PLUGINS_ASDF_JAVA:=$(PLUGINS_ASDF)/java
PLUGINS_ASDF_FLUTTER:=$(PLUGINS_ASDF)/flutter

GREEN:=$(shell tput -Txterm setaf 2)
YELLOW:=$(shell tput -Txterm setaf 3)
WHITE:=$(shell tput -Txterm setaf 7)
CYAN:=$(shell tput -Txterm setaf 6)
RESET:=$(shell tput -Txterm sgr0)

APP_DEFAULTS:=build-essential curl git zsh wget curl \
	git terminator synapse plank neovim fzf fonts-powerline \
	fonts-firacode deja-dup jq coreutils dirmngr gpg gawk \
	libsigsegv2 pass tree uidmap

.PHONY: all
all: help

## Help:
help: ## Show this help.
	@echo -d ''
	@echo -d 'Usage:'
	@echo -d '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo -d ''
	@echo -d 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

$(FONT_DIR):
	@echo -d "\nCreate Folder .fonts\n"
	@mkdir -p $(HOME)/.fonts

$(TEMP_DIR)/Anonymous.zip:
	@cd $(TEMP_DIR) && wget -c  -O Anonymous.zip $(ANONYMOUS_URL) \
		&& unzip Anonymous.zip -d Anonymous

$(TEMP_DIR)/docker.deb:
	@cd $(TEMP_DIR) \
		&& wget -c -O docker.deb $(DOCKER_URL)

$(TEMP_DIR)/code.deb:
	@cd $(TEMP_DIR) \
		&& wget -c -O code.deb $(CODE_URL)

$(TEMP_DIR)/chrome.deb:
	@cd $(TEMP_DIR) \
		&& wget -c -O chrome.deb $(CHROME_URL)

$(ASDF_DIR):
	@echo -d "Install asdf"
	@git clone $(ASDF_URL) ~/.asdf --branch v$(VERSION_ASDF) \
		&& echo ". $(HOME)/.asdf/asdf.sh" >> $(HOME)/.bashrc

$(OMYZSH_DIR):
	@echo -d "Install oh-my-zsh"
	@cd $(TEMP_DIR) \
		&& wget -c  -O ohmyzsh.sh $(OMYZSH_URL) \
		&& sh ohmyzsh.sh --unattended \

$(ZINIT_DIR):
	@$(shell bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)")

$(TERMINATOR_DIR):
	@echo -d "\nCreate config terminator\n"
	@mkdir -p $(HOME)/.config/terminator

$(SYNAPSE_DIR):
	@mkdir -p $(HOME)/.config/synapse

$(HADOLINT_DIR_BIN):
	@echo -d "\ninstall Hadolint\n"
	@sudo cp $(CURRENTDIR)/Linux/usr/bin/hadolint /usr/bin/hadolint

$(PLUGINS_ASDF_RUST):
	@asdf plugin-add rust https://github.com/code-lever/asdf-rust.git

$(PLUGINS_ASDF_GOLANG):
	@asdf plugin-add golang https://github.com/kennyp/asdf-golang.git

$(PLUGINS_ASDF_NODE):
	@asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

$(PLUGINS_ASDF_JAVA):
	@asdf plugin-add java https://github.com/halcyon/asdf-java.git

$(PLUGINS_ASDF_FLUTTER):
	@asdf plugin-add flutter


show_completion_message:
	@echo -d "--- IMPORTANT MANUAL STEPS ---"
	@echo -d "1 - Change your terminal font to Fira Code"
	@echo -d "2 - Restart your terminal for changes to take effect"
	@echo -d "3 - Enter your Vim and run :PlugInstall to install all plug-ins"
	@echo -d "--------"
	@echo -d "IMPORTANT: DO NOT REMOVE THIS REPOSITORY FOLDER OR YOU'LL LOSE THE SYMLINKS TO THE DOTFILES"

## Linux
.PHONY: upadate
upadate: ## Update and upgrade
	@sudo apt update \
		&& sudo apt dist-upgrade -y \
		2>/dev/null || :

.PHONY: vscode
vscode:
ifeq ($(CODE_INSTALLED), 1)
	@echo -d "Vscode installed"
else
	@echo -d "Install vscode"
	@cd $(TEMP_DIR) \
		&& sudo dpkg -i code.deb
endif

.PHONY: chrome
chrome: $(TEMP_DIR)/chrome.deb
ifeq ($(CHROME_INSTALLED), 1)
	@echo -d "Google Chrome installed"
else
	@echo -d "Install chrome"
	@cd $(TEMP_DIR) \
		&& sudo dpkg -i $(TEMP_DIR)/chrome.deb
endif

.PHONY: golang
golang: $(ASDF_DIR) $(PLUGINS_ASDF_GOLANG)
	@echo -d "\nInstall golang $(VERSION_GOLANG)\n"
	@asdf install golang $(VERSION_GOLANG) \
		&& asdf global golang $(VERSION_GOLANG)

.PHONY: node
node: $(ASDF_DIR) $(PLUGINS_ASDF_NODE)
	@echo -d "\nInstall node\n"
	@asdf install nodejs $(VERSION_NODE) \
		&& asdf global nodejs $(VERSION_NODE)

.PHONY: rust
rust: $(ASDF_DIR) $(PLUGINS_ASDF_RUST)
	@echo -d "\nInstall rust\n"
	@asdf install rust $(VERSION_RUST) \
		&& asdf global rust $(VERSION_RUST)

.PHONY: java
java: $(ASDF_DIR) $(PLUGINS_ASDF_JAVA)
	@echo -d "\nInstall Java\n"
	@asdf install java $(VERSION_JAVA) \
		&& asdf global java $(VERSION_JAVA)

.PHONY: flutter
flutter: $(ASDF_DIR) $(PLUGINS_ASDF_FLUTTER)
	@echo -d "\nInstall Flutter\n"
	@asdf install flutter $(VERSION_FLUTTER) \
		&& asdf global flutter $(VERSION_FLUTTER)

.PHONY: docker
docker: $(TEMP_DIR)/docker.deb
ifeq ($(DOCKER_INSTALLED), 1)
	@echo -d "Docker installed"
else
	@cd $(TEMP_DIR) \
		&& sudo dpkg -i docker.deb
endif

.PHONY: hadolint
hadolint: $(HADOLINT_DIR_BIN)
	@echo -d "\nHadolint installed\n"

install-znit:
	@$(shell bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)")

cargo-installs:
	@cargo install ytop exa bat starship --locked

# vscode chrome
install-depes: upadate ## install apps default
	@sudo apt install -y $(APP_DEFAULTS) \
		&& sudo apt autoremove

asdf-reshim:
	@asdf reshim

clean:
	@cd $(TEMP_DIR) && rm -rf Anonymous* \
		Fira_Code* \
		*.sh \
		*.deb \

fonts: $(FONT_DIR) $(TEMP_DIR)/Anonymous.zip
	@echo -d "Downloading fonts"
	@cd $(TEMP_DIR) \
		&& cp Anonymous/*.ttf $(HOME)/.fonts

sync_files:
	@rsync -avrh Linux/.zshrc $(HOME)/.zshrc
	@rsync -avrh Linux/.bashrc $(HOME)/.bashrc
	@rsync -avrh Linux/.gitconfig $(HOME)/.gitconfig
	@mkdir -p $(HOME)/.config/terminator/ && rsync -avrh Linux/.config/terminator/config $(HOME)/.config/terminator/config
	@mkdir -p $(HOME)/.config/synapse/ && rsync -avrh Linux/.config/synapse/config.json $(HOME)/.config/synapse/config.json

backup_files:
	@echo -d "\nbackup older files\n"
	@cp $(HOME)/.zshrc \
		$(HOME)/.bashrc \
		$(HOME)/.gitconfig \
		$(HOME)/.config/terminator/config \
		$(HOME)/.config/synapse/config.json \
		$(CURRENTDIR)/backups_files/backup \
		2>/dev/null || :

remove_older_files:
	@echo -d "\nRemoving older files\n"
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

install: install-depes fonts docker hadolint rust golang node java flutter cargo-installs asdf-reshim
	@echo -d "Start install deps"

bootstrap: backup_files install
	@echo -d "\nInstalation completed"
