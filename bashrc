# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# # set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac
export color_prompt=yes

# support for toolbox
CONTAINERNAME=''
if [ -f /run/.containerenv ]; then
  CONTAINERNAME=$(cat /run/.containerenv | sed -n '2 p' | awk -F '"' 'NF>2{print $2}')
  CONTAINERNAME='󰦭  '${CONTAINERNAME}
  # PS1=${PS1}'\[\033[01;33m\] 󰦭  ${CONTAINERNAME}'
fi

# python/conda venv
# FIXME: not automatically updated upon activation. Reload .bashrc or use tmux line.
# NOTE: as an alternative ,I manually tweak every venv's activate file to source .bashrc
VENV=''
export VIRTUAL_ENV_DISABLE_PROMPT=1 # disable venv prompt
if [[ -n "$VIRTUAL_ENV" ]]; then
  # Strip out the path and just leave the env name
  VENV=" ${VIRTUAL_ENV##*/}"
elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
  VENV=" ${CONDA_DEFAULT_ENV}"
fi

# git branch and user
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* $.*$/ (\1)/'
}

parse_git_user() {
  git config user.name
}

export PS1="\u@\h $$\033[32m$$\$(parse_git_user)$$\033[33m$$\$(parse_git_branch)$$\033[00m$$ \w \$ "

# top line (dir, container, venv)
PS1='\[\033[01;35m\] \w \[\033[01;33m\]\ $(parse_git_user) \$(parse_git_branch) ${CONTAINERNAME} \[\033[01;32m\]${VENV}\n'
# bottom line
PS1=${PS1}'\[\033[01;36m\]  \[\033[00m\]'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Set Neovim as main editor
EDITOR=nvim

### User specific aliases and functions
# explorer (check if 'eza' is installed)
if ! command -v eza &>/dev/null; then
  echo "eza not be found, reverting to ls..."
  alias ll='ls -lhF --color=auto'
  alias la='ls -A'
  alias l='ls -CF'
else
  alias ll='eza -lF'
  alias la='eza -aF'
  alias l='eza -F --icons'
fi

# ssh
alias ssh='TERM=xterm-256color /usr/bin/ssh'

# tmux
alias t="tmux"
alias tstart="tmux start-server"
alias ta="tmux attach-session -t"
tmux_refresh() {
  tmux send-keys 'C-c' ' eval "$(tmux show-env -s)"' 'Enter' ' clear' 'Enter'
}
alias tmux-refresh=' tmux_refresh'

#python alias
alias python='python3'
alias pip='pip3'

# ranger
alias rr="ranger"

# vim/neovim
alias v="nvim"

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# git
alias gs="git status"
alias gc="git commit"

# Modulepath
# MODULEPATH=$MODULEPATH:/opt/modulefiles

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
if ! [[ "$PATH" =~ "$HOME/.cargo/bin:" ]]; then
  PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH

# OpenMPI
# MPI_DIR=/usr/local/openmpi
# MPI_DIR=/opt/mpi
# export LD_LIBRARY_PATH=$MPI_DIR/lib:$LD_LIBRARY_PATH
# export PATH=$MPI_DIR/bin:$PATH

# flatpak aliases (change according to those installed)
alias spotify='flatpak run com.spotify.Client'
alias obsidianfp='flatpak run md.obsidian.Obsidian' # using AppPackage
alias gimp='flatpak run org.gimp.GIMP'
alias okular='flatpak run org.kde.okular'
alias thunderbird='flatpak run org.mozilla.Thunderbird'
alias vlc='flatpak run org.videolan.VLC'

# other aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# TODO: snap aliases

# Set vi mode
set -o vi
