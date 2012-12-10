#=============================
# LANG
#=============================
export LANG=ja=JP.UTF-8
export LC=ALL=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
#export LANG=ja_JP.eucJP
#export LC_ALL=ja_JP.eucJP
#export LC_CTYPE=ja_JP.eucJP

#=============================
# PATH
#=============================
PATH=/home/$USER/local/bin:/usr/local/Cellar:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export TERM=xterm-256color

#=============================
# Key Binding
#=============================
# Like Emacs
bindkey -e

#=============================
# colour
#=============================
local gray=$'%{\e[0;30m%}'
local red=$'%{\e[0;31m%}'
local green=$'%{\e[0;32m%}'
local yellow=$'%{\e[0;33m%}'
local blue=$'%{\e[0;34m%}'
local purple=$'%{\e[0;35m%}'
local light_blue=$'%{\e[0;36m%}'
local white=$'%{\e[0;37m%}'
local GRAY=$'%{\e[1;30m%}'
local RED=$'%{\e[1;31m%}'
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local PURPLE=$'%{\e[1;35m%}'
local LIGHT_BLUE=$'%{\e[1;36m%}'
local WHITE=$'%{\e[1;37m%}'
local DEFAULT=$white

#=============================
# Move
#=============================
# change directory with only deirectory name
setopt auto_cd
# add directory name to candidate of campletion after change directory
setopt auto_pushd
# directory path in not finding file
cdpath=(~)
# display directory stack after change directory
chpwd_functions=($chpwd_functions dirs)
# move to pushd directory
setopt autopushd

#=============================
# History
#=============================
# history file
HISTFILE=~/.zsh_history
# the number of files on memory
HISTSIZE=10000000
# the number of saving files
SAVEHIST=$HISTSIZE
# save the times in history file
setopt extended_history
# don't register same command in history
setopt hist_ignore_dups
# don't save a command starting with space in history
setopt hist_ignore_space
# add it to history
setopt inc_append_history
# share history between zsh processes
setopt share_history
# don't use C-s/C-q for searching history
setopt no_flow_control

#=============================
# Prompt
#=============================
setopt prompt_subst
setopt prompt_percent
# nodisplay RPROMPT after committing a command
setopt transient_rprompt

# left prompt
prompt_bar_left_status="%(?.$WHITE.$RED)%}%?"
# prompt_bar_left_self="$RED%n@%m"
prompt_bar_left_self="$RED@%m"
prompt_bar_left_date=" %{%B%}$BLUE%D{%H:%M:%S}%{%b%} "
prompt_bar_left_path="%{%B$GREEN%}%~%{%b%}"
prompt_bar_left="${prompt_bar_left_status} ${prompt_bar_left_self} ${prompt_bar_left_date} ${prompt_bar_left_path}"

# left prompt in the second line
prompt_left="%(1j,(%j),)%{%B%}$GREEN%#%{%b%} "

# Version Controll System Infomations
autoload -Uz colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

# if the response is too slow, comment out below.
autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

# sequence of the update sequence
update_prompt()
{
    PROMPT="${prompt_bar_left}"$'\n'"${prompt_left}"

    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    RPROMPT="%1(v|${LIGHT_BLUE}%1v%f|)"
}

# sequence before committing a command
precmd_functions=($precmd_functions update_prompt)


#=============================
# Complition
#=============================
autoload -U compinit
compinit

# group the options
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

# select candidates from menu
zstyle ':completion:*:default' menu select=2

# complitions with colours
zstyle ':completion:*:default' list-colors ""

# show obscure candidates
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'

# order of candidates
zstyle ':completion:*' completer \
    _oldlist _complete _match _history _ignored _approximate _prefix

# use cache
zstyle ':completion:*' use-cache yes
# use precise infomations
zstyle ':completion:*' verbose yes
# use PATH on sudo
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

# complement on cursor
setopt complete_in_word
# do not expand glob
setopt glob_complete
# expand history
setopt hist_expand
# no beep
setopt no_beep
# sort by number
setopt numeric_glob_sort

# expansion
# enable after "~" and "="
setopt magic_equal_subst
# enable expansive glob
setopt extended_glob
# add / automatically
setopt mark_dirs

# display PID with jobs
setopt long_list_jobs

# display time of committing
REPORTTIME=3

# display user's behaviours
watch="all"
log

# prohibit logout with C-d
setopt ignore_eof

# consider '/' as word
WORDCHARS=${WORDCHARS:s,/,,}
# consider '|' as word
WORDCHARS="${WORDCHARS}|"

# exception
fignore=(CVS .svn)

#=============================
# alias
#=============================
# PAGER
alias -g L="|& $PAGER"
alias rr="command rm -rf"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias po="popd"

# ls & ps
case $(uname) in
    *BSD|Darwin)
  if [ -x "$(which gnuls)" ]; then
      alias ls="gnuls"
      alias la="ls -lhAF --color=auto"
  else
      alias la="ls -lhAFG"
  fi
  alias ps="ps -fU$(whoami)"
  ;;
    SunOS)
  if [ -x "`which gls`" ]; then
      alias ls="gls"
      alias la="ls -lhAF --color=auto"
  else
      alias la="ls -lhAF"
  fi
  alias ps="ps -fl -u$(/usr/xpg4/bin/id -un)"
  ;;
    *)
  alias la="ls -lhAF --color=auto"
  alias ps="ps -fU$(whoami) --forest"
  ;;
esac

# grep
if type ggrep > /dev/null 2>&1; then
  alias grep=ggrep
fi
export GREP_OPTIONS
## don't match vinary files
GREP_OPTIONS="--binary-files=without-match"
case "$grep_version" in
    1.*|2.[0-4].*|2.5.[0-3])
  ;;
    *)
## ignore control files
if grep --help 2>&1 | grep -q -- --exclude-dir; then
  GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
  GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
  GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
  GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
fi
## colours if possible
if grep --help 2>&1 | grep -q -- --color; then
 GREP_OPTIONS="--color=auto $GREP_OPTIONS"
fi

# exit
alias x="exit"

# tmux alias
alias tm ="tmux"
alias tml="tmux ls"
alias tma="tmux attach -t "


#=============================
# misc
#=============================
export EDITOR=vim

# 256 colours test
function pcolor() {
  for ((f = 0; f < 255; f++)); do
    printf "\e[38;5;%dm %3d#\e[m" $f $f
    if [[ $f%8 -eq 7 ]] then
      printf "\n"
    fi
  done
  echo
}

# 38 colours test
function ppcolor() {
  for ((f = 0; f < 37; f++)); do
     printf "\e[1;%dm %2d#\e[m" $f $f
     if [[ $f%8 -eq 7 ]] then
       printf "\n"
     fi
  done
  echo
}

# load local settings
if [ -a $HOME/zshrc.local ]; then
  source $HOME/zshrc.local
fi
