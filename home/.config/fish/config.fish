

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

        # Sublime Text
        set -Ux EDITOR subl
end
function be 
    bundle exec $argv
end