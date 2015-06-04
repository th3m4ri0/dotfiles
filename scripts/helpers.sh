
# Environment helpers

is_ubuntu () {
    command_exists apt-get
}

is_osx () {
    [[ "$OSTYPE" == "darwin"* ]];
}



# Existance helpers

directory_exists () {
    [ -d "$1" ]
}

command_exists () {
    type "$1" &> /dev/null ;
}



# Display helpers

echo_step () {
    echo "---> $1"
}


