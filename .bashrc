#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		#PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]] λ\[\033[00m\] '
	else
        # this line executed !!! λλ  ->> color: \[\033[01;35m\]
        #
		#PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
        # \[\033[01;32m\]\u@\h   ✓ ➜ ✗
        #               user             host              path            prompt    end_flag
		PS1="\[\033[01;37m\]\$(exit=\$?; if [[ \$exit == 0 ]]; then echo \"\[\033[01;30m\]➜\"; else echo \"\[\033[01;31m\]➜\"; fi) \[\033[01;32m\]\W \[\033[01;36m\]λ\[\033[00m\] "
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W  λ '
		# PS1='\u@\h \W \$ '
	else
		# PS1='\u@\h \w \$'
		PS1='\u@\h \w  λ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000000
HISTFILESIZE=200000000

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# better yaourt colors
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# useful alias
alias dic='/home/john/git_packages/dict'
alias soub='source /home/john/.bashrc'
# ws_alias
alias dmc="cd /home/john/workspace/cpp_"
alias hy="cd /home/john/workspace/imdb"
alias tp="cd /home/john/workspace/network"
alias sys="cd /home/john/workspace/op_sys/eig"
alias cpcore='coredumpctl list -1 | sed -n "2, 1p" | awk "{print $5}" |coredumpctl dump $1 -o core'
alias ccpp="cd /home/john/workspace/CCPP"

# git completion
source /usr/share/git/completion/git-completion.bash

# git_alias
# @TODO why using both .bashrc and .gitconfig to apply the alias of git
# So, why does it failes?
alias g="git status"
alias ga="git add"                  # alias gau="git add -u"
alias gc="git commit -m"            # alias gca="git commit -am"

# alias gja="git --no-pager commit --amend --reuse-message=HEAD" # git just amend

alias gb="git branch"
alias gbd="git branch -d"
alias gnb="git checkout -b"

alias gts="git stash save"
alias gtp="git stash pop"
alias gtl="git stash list"
# alias gta="git stash apply"

alias gm="git merge"
alias gr="git rebase"
alias gl="git log --pretty=oneline --abbrev-commit --decorate --graph"
alias glp="git log --date=short --decorate --graph --pretty=format:'%C(yellow)%h%Creset%C(green)%d%Creset %ad %s %Cred(%an)%Creset' -p"
alias gs="git show"
alias gsb="git show-branch"
# alias gss="git show --stat"
alias gd="git diff"
alias gds="git diff --stat"
alias gdc="git diff --cached"
alias gdcs="git diff --cached --stat"

# alias gbl="git blame"
alias gps="git push"
alias gpl="git pull"
alias gcf="git config"
# alias cg='cd $(git rev-parse --show-toplevel)' #goto root dir

# rust  http://mirrors.ustc.edu.cn/help/rust-static.html
# without repalce domestic mirror for cargo
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# emacs
alias emacs_net='http_proxy=http://127.0.0.1:1080 emacs -nw'
alias emacs='emacs -nw'

# shadowsocks daemon mode + path of *.json file
conf_ss='/home/john/conf_files/ss/sf1.json'
alias sdstart="sudo sslocal -c $conf_ss -d start"
alias sdstop="sudo sslocal -c $conf_ss -d stop"
alias sdre="sudo sslocal -c $conf_ss -d restart"
alias ws="cd /home/john/ws"

## gdm (gnome desktop manager)
# stucked at the boot process, since gdm version is 3.28.2-1(may be the next version will fix it)
#
alias ggdm="sh /home/john/conf_files/gdm_tmp.sh"
alias log="emacs /home/john/ws/log.org"

## tmux
# support utf-8
alias tmux='tmux -u'

#cargo <-- Rust
export PATH="$HOME/.cargo/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# keep the same dir in new tabs within terminal
source /etc/profile.d/vte.sh

# run the same command N time
function run() {
    number=$1
    shift
    for n in $(seq $number); do
      $@
    done
}

# add for clion
# export PATH="/home/john/.depend/clion-2018.3.1/bin:$PATH"
alias clion="/home/john/.depend/clion-2018.3.1/bin/clion.sh"
