###############################################################################
# .bashrc
###############################################################################

###############################################################################
# Source global definitions
###############################################################################
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

###############################################################################
# User specific aliases and functions
###############################################################################
# PATH
#export PYTHONPATH=~/local/lib/python2.7/site-packages
export PATH=$HOME/local/bin:/usr/local/bin:$PATH

# IGNORE
export FIGNORE=".svn:.git"

###############################################################################
# alias
###############################################################################
alias rm='rm -i'
alias ls='ls -htF --color=tty --show-control-chars'
alias ll='ls -l'
alias la='ls -a'
alias rmb="rm ./*~"
alias grep="grep --color"
export SLP=$HOME/svn/SLP

###############################################################################
# auto login to tmux
###############################################################################
# if [ -z "$TMUX" -a -z "$STY" ]; then
    # if type tmuxx >/dev/null 2>&1; then
        # tmuxx
    # elif type tmux >/dev/null 2>&1; then
        # if tmux has-session && tmux list-sessions | /bin/grep -qE '.*]$'; then
            # tmux attach && echo "tmux attached session "
        # else
            # tmux new-session && echo "tmux created new session"
        # fi
    # fi
# fi

###############################################################################
# history
###############################################################################
# share
function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend

# detail
HISTTIMEFORMAT='%Y-%m-%d %T '; export HISTTIMEFORMAT
export HISTSIZE=99999
export HISTIGNORE=fg*:bg*:history*:cd*
export HISTCONTROL=ignoredups

###############################################################################
# add git and svn branch to bash prompt
###############################################################################
if [ -f ~/.git-completion.bash ]; then
        . ~/.git-completion.bash
fi

export PS1='\[\033[35m\][\w]$(__git_ps1 "(%s)") \n\[\033[33m\]\u@\h$\[\033[0m\] '
