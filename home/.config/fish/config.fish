# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Theme
Theme "cmorrell.com"


Plugin "brew"
Plugin "rbenv"
Plugin "theme"
Plugin "vundle"


# Custom stuff
set --erase fish_greeting
switch (uname)
    # Linux
    case Linux
        . /usr/share/autojump/autojump.fish
    # Mac OS
    case Darwin
        . (brew --prefix autojump)/share/autojump/autojump.fish
        # Docker
        set -x DOCKER_CERT_PATH ~/.boot2docker/certs/boot2docker-vm
        set -x DOCKER_TLS_VERIFY 1
        set -x DOCKER_HOST tcp://192.168.59.103:2376
end
function be 
    bundle exec $argv
end