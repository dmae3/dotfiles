# Common
export PATH=${HOME}/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}

# editor
export EDITOR=vim

# rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
[[ -d ~/.rbenv ]] && eval "$(rbenv init -)"

# go
export GOPATH=${HOME}/go
export PATH="${GOPATH}/bin:${PATH}"

# nodebrew
export PATH=${HOME}/.nodebrew/current/bin:${PATH}
