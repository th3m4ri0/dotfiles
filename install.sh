#!/bin/sh

set -e

scripts=${0%/*}/scripts
ruby_version=2.2.2

. "${scripts}/helpers.sh"

sudo -v
# Keep-alive: update existing `sudo` time stamp until `osx.sh` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Compatibility check
if [ ! is_osx ] && [ ! is_ubuntu ] ;then
    echo "Sorry, those dotfiles only work on Mac OS and Ubuntu 😐"
    exit 1;
fi


if is_ubuntu ;then
    echo_step "Ubuntu install \n"
elif is_osx ;then
    echo_step "Mac OS install \n"
fi


# Ubuntu specific packages
if is_ubuntu ;then
    echo_step "Installing Ubuntu specific packages."
    sudo apt-get update -y > /dev/null
    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev -y
fi

# Homebrew, OS X only
if command_exists brew ;then
    echo_step "🍺  Homebrew is already installed."
else
    if is_osx ;then
        echo_step "🍺  Installing homebrew."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
fi

# Git
if command_exists git ;then
    echo_step "Git is already installed."
else
    echo_step "Installing git."
    if is_osx ;then
        brew install git
    elif is_ubuntu ;then
        sudo apt-get install git -y
    fi
fi

# Rbenv
if command_exists rbenv ;then
    echo_step "Rbenv is already installed."
else
    echo_step "Installing rbenv."
    if is_osx ;then
        brew install rbenv
    elif is_ubuntu ;then
        git clone https://github.com/rbenv/rbenv.git ~/.rbenv
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    fi
fi

# Ruby-build
if is_osx ;then
    if command_exists ruby-build ;then
        echo_step "Ruby-build is already installed."
    else
        echo_step "Installing ruby-build."
        brew install ruby-build
    fi
elif is_ubuntu ;then
    if directory_exists ~/.rbenv/plugins/ruby-build ;then
        echo_step "Ruby-build is already installed."
    else
        echo_step "Installing ruby-build."
        git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    fi
fi


# Rbenv version
if rbenv versions |grep -q $ruby_version ;then
    echo_step "Ruby $ruby_version is already installed."
else
    echo_step "Installing ruby $ruby_version."
    rbenv install $ruby_version
    rbenv global $ruby_version
fi

# Bundle
if command_exists bundle ;then
    echo_step "Bundler is already installed."
else
    echo_step "Installing bundle."
    gem install bundle
    rbenv rehash
fi

# Pry
if command_exists pry ;then
    echo_step "Pry is already installed."
else
    echo_step "Installing pry."
    gem install pry
    rbenv rehash
fi

# Node JS npm
if command_exists node ;then
    echo_step "Node.JS already installed."
else
    echo_step "Installing node.js."
    if is_osx ;then
        brew install node
    elif is_ubuntu ;then
        sudo apt-get install nodejs -y
    fi
fi

# npm install -g without sudo

if is_ubuntu ;then
    if directory_exists ~/.npm-packages ;then
        echo_step "npm install -g without sudo already setup."
    else 
        echo_step "Setting up npm install -g without sudo."
        mkdir ~/.npm-packages
    fi
fi

# Heroku CLI
if command_exists heroku ;then 
    echo_step "Heroku CLI is already installed."
else
    echo_step "Installing Heroku CLI."
    if is_osx; then
        brew install heroku-toolbelt
    else
        wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    fi
fi

# PIP
if command_exists pip ;then 
    echo_step "PIP is already installed"
else
    echo_step "Installing pip"
    if is_osx; then
        brew install python
    elif is_ubuntu ;then
        sudo apt-get -y install python-pip
    fi
fi

# AWS CLI
if command_exists aws ;then
    echo_step "AWS CLI is already installed"
else
    echo_step "Installing AWS CLI."
    sudo pip install awscli
fi

# Homesick
if command_exists homesick ;then
    echo_step "🏰  Homesick is already installed."
else
    echo_step "🏰  Installing homesick."
    gem install homesick
fi

# Autojump
if command_exists autojump ;then
    echo_step "Autojump is already installed."
else
    echo_step "Installing autojump."
    if is_osx ;then
        brew install autojump
    elif is_ubuntu ;then
        sudo apt-get install autojump -y
    fi
fi

# Fish shell
if command_exists fish ;then
    echo_step "🐠  Fish shell already installed."
else
    echo_step "🐠  Installing fish shell. Your password will be asked soon."
    if is_osx ;then
        brew install fish
        echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
        chsh -s /usr/local/bin/fish
    elif is_ubuntu ;then
        sudo apt-add-repository ppa:fish-shell/release-2 -y
        sudo apt-get update -y > /dev/null
        sudo apt-get install fish -y
        chsh -s /usr/bin/fish
    fi
fi

# Oh-my-fish
if command_exists omf ;then
    echo_step "🐟  Oh-my-fish is already installed."
else
    echo_step "🐟  Installing oh-my-fish."
    curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish 
fi

# Mac OS X preferences
if is_osx ;then
    defaults write com.apple.dock autohide-delay -int 0
    defaults write com.apple.dock autohide-time-modifier -float 0.4
    killall Dock
fi

echo_step "Installing oh-my-fish plugins."
fish -c "omf install"

echo_step "🍸  Everything installed properly ! Congrats !"
