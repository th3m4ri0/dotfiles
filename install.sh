#!/bin/sh

set -e

scripts=${0%/*}/scripts
ruby_version=2.2.2

. "${scripts}/helpers.sh"

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
    sudo apt-get update -y
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
        sudo apt-get install rbenv
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

# Homesick
if command_exists homesick ;then
    echo_step "🏰  Homesick is already installed."
else
    echo_step "🏰  Installing homesick."
    gem install homesick
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
        sudo apt-get update -y
        sudo apt-get install fish -y
        chsh -s /usr/bin/fish
    fi
fi

# Oh-my-fish
if directory_exists ~/.oh-my-fish ;then
    echo_step "🐟  Oh-my-fish is already installed."
    echo_step "🐠  Updating oh-my-fish."
    git --git-dir ~/.oh-my-fish pull origin master
else
    echo_step "🐟  Installing oh-my-fish."
    git clone git://github.com/bpinto/oh-my-fish.git ~/.oh-my-fish
    fish -c omf install
fi

echo_step "🍸  Everything installed properly ! Congrats !"