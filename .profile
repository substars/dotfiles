export ORACLE_HOME=/Library/Oracle/instantclient_10_2_0_4
export TNS_ADMIN=$ORACLE_HOME
export LD_LIBRARY_PATH=$ORACLE_HOME
export DYLD_LIBRARY_PATH=$ORACLE_HOME
export PATH=$PATH:$ORACLE_HOME

export JRUBY_HOME=~/projects/jruby
export PATH=/usr/local/mysql/bin/:/opt/local/bin/:$PATH:$JRUBY_HOME/bin

export CLICOLOR=1;
export LSCOLORS=ExFxCxDxBxegedabagacad

complete -C "/usr/bin/gemedit --complete" gemedit

# Nifty bit to make the current rev show up when we're in a git or svn working dir

ps_scm_f() {
    local s=
    if [[ -d ".svn" ]] ; then
        local r=$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )
        s="(r$r$(svn status | grep -q -v '^?' && echo -n "*" ))"
    else
        local d=$(git rev-parse --git-dir 2>/dev/null ) b= r= a=
        if [[ -n "${d}" ]] ; then
            if [[ -d "${d}/../.dotest" ]] ; then
                if [[ -f "${d}/../.dotest/rebase" ]] ; then
                    r="rebase"
                elif [[ -f "${d}/../.dotest/applying" ]] ; then
                    r="am"
                else
                    r="???"
                fi
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/.dotest-merge/interactive" ]] ; then
                r="rebase-i"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -d "${d}/../.dotest-merge" ]] ; then
                r="rebase-m"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -f "${d}/MERGE_HEAD" ]] ; then
                r="merge"
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/BISECT_LOG" ]] ; then
                r="bisect"
                b=$(git symbolic-ref HEAD 2>/dev/null )"???"
            else
                r=""
                b=$(git symbolic-ref HEAD 2>/dev/null )
            fi

            if git status | grep -q '^# Changed but not updated:' ; then
                a="${a}*"
            fi

            if git status | grep -q '^# Changes to be committed:' ; then
                a="${a}+"
            fi

            if git status | grep -q '^# Untracked files:' ; then
                a="${a}?"
            fi

            b=${b#refs/heads/}
            b=${b// }
            [[ -n "${r}${b}${a}" ]] && s="(${r:+${r}:}${b}${a:+ ${a}})"
        fi
    fi
    s="${s}${ACTIVE_COMPILER}"
    s="${s:+${s} }"
    echo -n "$s"
}


alias evol='cd ~/projects/evolution'
alias sc='./script/console'
alias ss='./script/server'

export EDITOR='nano'
export CLICOLOR='t'


if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

if [ $INSIDE_EMACS ]; then
    export PS1="\h:\W \u\$ "
else
    export PS1="\$(ps_scm_f)\h:\W \u\$ "
    if [ $TERM == "screen" ]; then
        export PS1='\[\033k\033\\\]'$PS1
    fi
fi

complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

_mategem()
{
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    local gems="$(gem environment gemdir)/gems"
    COMPREPLY=($(compgen -W '$(ls $gems)' -- $curw));
    return 0
}
complete -F _mategem -o dirnames mategem
##
# Your previous /Users/bortega/.profile file was backed up as /Users/bortega/.profile.macports-saved_2009-04-20_at_16:11:19
##

# MacPorts Installer addition on 2009-04-20_at_16:11:19: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH=/opt/local/share/man:$MANPATH
# Finished adapting your MANPATH environment variable for use with MacPorts.

