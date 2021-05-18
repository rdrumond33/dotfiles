#!/bin/bash

install_fonts () {
  echo "Downloading fonts"
  sudo apt-get install -y fonts-powerline fonts-firacode

  echo "Create folder fonts"
  if [ ! -d "~/.fonts" ]; then
    mkdir ~/.fonts
  fi
}

install_depedencys () {
  echo "Installing all dependencies"
  sudo apt-get update \
  && sudo apt-get -y upgrade \
  && sudo apt-get install -y build-essential zsh wget curl git terminator synapse plank neovim

  echo "Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo "Installing Spaceship theme"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

  echo "Installing ZSH Plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echo "Installing FZF, remember to aswer Y to all questions"
  sleep 5
  sudo apt-get -y install fzf

  echo "Install nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

  cd ~/Downloads

  echo "Install vscode"
  wget "https://az764295.vo.msecnd.net/insider/82767cc1d7bf8cdea0f2897276d5d15aee91f3d9/code-insiders_1.57.0-1621228986_amd64.deb" \
  && sudo dpkg -i ~/Downloads/code-insiders_1.57.0-1621228986_amd64.deb

  echo "Install chrome"
  wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
  && sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
}

remove_older_files () {
  echo "Removing older files"
  rm -rf ~/.gitconfig ~/.zshrc ~/.bashrc ~/.config/terminator/config ~/.config/synapse/config.json
}

link_files () {
  ln ./Linux/.bashrc ~/.bashrc
  ln ./Linux/.gitconfig ~/.gitconfig
  ln ./Linux/.config/terminator/config ~/.config/terminator/config
  ln ./Linux/.config/synapse/config.json ~/.config/synapse/config.json
}

show_completion_message () {
  echo "Instalation completed"
  echo "--- IMPORTANT MANUAL STEPS ---"
  echo "1 - Change your terminal font to Fira Code Nerdfont"
  echo "2 - Restart your terminal for changes to take effect"
  echo "3 - Enter your Vim and run :PlugInstall to install all plug-ins"
  echo "4 - Set ZSH_THEME=\"spaceship\" in your .zshrc."
  echo "--------"
  echo "IMPORTANT: DO NOT REMOVE THIS REPOSITORY FOLDER OR YOU'LL LOSE THE SYMLINKS TO THE DOTFILES"
}

linux_bootstrap () {
  echo "Executing Linux bootstrap"
  install_depedencys
  remove_older_files
  link_files
  show_completion_message
}

linux_bootstrap