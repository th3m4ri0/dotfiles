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
end
function be 
    bundle exec $argv
end