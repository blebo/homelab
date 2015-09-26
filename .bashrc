# ~/.bashrc: executed by bash(1) for non-login shells.

#GREEN=$'\033[1;32m'
#RED=$'\033[1;31m'
#NONE=$'\033[m'

GREEN="$(tput setaf 2)$(tput bold)"
RED="$(tput setaf 1)$(tput bold)"
NONE=$(tput sgr0)

get_exit_status(){
   es=$?
   if [ $es -eq 0 ]
   then
       echo -e "${GREEN}${es}${NONE}"
   else
       echo -e "${RED}${es}${NONE}"
   fi
}

PROMPT_COMMAND='exitStatus=$(get_exit_status)'
PS1='\n\[${exitStatus}\] ${debian_chroot:+($debian_chroot)}\u@\h:\w\$ \n'

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

#useful
alias here='nautilus .'