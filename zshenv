# Common
export PATH=${HOME}/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}

# editor
export EDITOR=vim

# go
export GOPATH=${HOME}/go
export PATH="${GOPATH}/bin:${PATH}"

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
[[ -d ~/.anyenv/envs/rbenv ]] && eval "$(rbenv init -)"
[[ -d ~/.anyenv/envs/pyenv ]] && eval "$(pyenv init -)"
[[ -d ~/.anyenv/envs/nodenv ]] && eval "$(nodenv init -)"
