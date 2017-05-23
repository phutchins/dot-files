# Philip Hutchins .bashrc and .bash_profile

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Use this to find what might be slowing down bash session startup
SHOW_TIMERS=false

# Get the current milliseconds
function getms {
  echo $(($(gdate +%s%N)/1000000))
}

start=$(getms)

# Determine what OS we're running on
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
   if [ -f /usr/bin/lsb_release ]; then
     OS=$(lsb_release -si)
     ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
     VER=$(lsb_release -sr)
     # Need to detect ARCH here with uname -r
   elif [ -f /etc/os-release ]; then
     source /etc/os-release
     #OS=$(uname -r | sed s/[0-9.-]*//)
     if [[ $ID == 'antergos' ]]; then
       OS='ARCH'
     fi
   fi
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Determine OS: ${duration}ms"
fi

start=$(getms)
# Packages that I want installed
if [[ $platform == 'linux' ]]; then
  if [[ $OS == 'Ubuntu' ]]; then
    if ! [ "dpkg -l | grep tmux" ] ; then
      echo "Installing Tmux"
      sudo apt-get install tmux
    fi
  elif [[ $OS == 'CentOS' ]]; then
    if ! [ "yum list installed | grep tmux" ]; then
      echo "Installing Tmux"
      sudo yum install tmux
    fi
  elif [[ $OS == 'ARCH' ]]; then
    if ! [ "which tmux" ]; then
      echo "Installing Tmux, you may be asked for sudo password"
      sudo pacman -S tmux
    fi
  fi
elif [[ $platform == 'osx' ]]; then
  if [ ! -f /usr/local/bin/brew ]; then
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  fi
  if [ ! -f /usr/local/bin/tmux ]; then
    brew install tmux
    brew install reattach-to-user-namespace
  fi
  if [ ! -f /usr/local/bin/gdate ]; then
    brew install gdate
  fi
  if [ ! -f /usr/local/bin/weechat ]; then
    echo "Installing weechat"
    brew install weechat --with-aspell --with-curl --with-python --with-perl --with-ruby --with-lua --with-guile
  fi
#  # Export Docker Host IP
#  export DOCKER_HOST=tcp://192.168.59.103:2375
fi

source "$HOME/git-completion.bash"
if [ ! -f $HOME/git-completion.bash ]; then
  cd && curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -OL
fi

# Bash completion for kubectl and kube alias
if [ -f $HOME/.bash_completion/kube ]; then
  source "$HOME/.bash_completion/kube";
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Install packages: ${duration}ms"
fi

start=$(getms)

# Set up ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initializing new SSH agent..."
    touch $SSH_ENV
    chmod 600 "${SSH_ENV}"
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >> "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    kill -0 $SSH_AGENT_PID 2>/dev/null || {
        start_agent
    }
else
    start_agent
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Starting SSH Agent: ${duration}ms"
fi

### History ###
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
#export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
#export HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
#shopt -s histappend

start=$(getms)

HISTIGNORE="hnote*"
# Used to put notes in a history file
function hnote {
    echo "## NOTE [`date`]: $*" >> $HOME/.history/bash_history-`date +%Y%m%d`
}

# used to keep my history forever
PROMPT_COMMAND="[ -d $HOME/.history ] || mkdir -p $HOME/.history; echo : [\$(date)] $$ $USER \$OLDPWD\; \$(history 1 | sed -E 's/^[[:space:]]+[0-9]*[[:space:]]+//g') >> $HOME/.history/bash_history-\`date +%Y%m%d\`"

### Editor ###
export EDITOR=vim
set -o vi
bind '\C-a:beginning-of-line'
bind '\C-e:end-of-line'

### Amazon Credentials for DealerMatch ###
export AWS_CREDENTIAL_FILE=~/aws/.credentials/aws.credentials

### OWSSH ###
export OWSSH_USER="phutchins"
export OWSSH_SSH_KEY_FILE="~/.ssh/id_rsa"

### MonDupe ###
export MONDUPE_INSTANCE_IMAGE_ID="ami-018c9568"
export MONDUPE_CHEF_RUN_LIST='"recipe[chefbp-base]"'
export MONDUPE_CHEF_IDENTITY_FILE="~/.ssh/DevOps.pem"
export MONDUPE_CHEF_ENVIRONMENT="internal_development"
export MONDUPE_SSH_KEY="~/.ssh/DevOps.pem"
export MONDUPE_SSH_USER="ubuntu"
export MONDUPE_ROUTE53_DOMAIN="b-pay.net."
export MONDUPE_KEY_PAIR_NAME="DevOps"
export MONDUPE_SECURITY_GROUP="mongo"
export MONDUPE_S3_BUCKET_NAME="cde_production_mongo_backups"
export MONDUPE_DUMP_FILE_NAME="mongodb.dump.tgz"

### PATH ###
if [[ $platform == 'linux' ]]; then
  alias ls='ls --color=auto'
  export PATH=~/bin:/usr/local/bin:~/.local/bin:$PATH
elif [[ $platform == 'osx' ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH=~/bin:/usr/local/bin:~/Library/Python/2.7/bin:$PATH
  alias ls='ls -G'
fi

#### GO ####
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

### AWS ###
export AWS_AUTO_SCALING_HOME=~/aws/AutoScaling
export AWS_CLOUDWATCH_HOME=~/aws/CloudWatch
export PATH=/usr/local/git/bin:$PATH
export PATH=$AWS_AUTO_SCALING_HOME:$PATH
export PATH=$AWS_CLOUDWATCH_HOME:$PATH


# Eclipse
export PATH=${PATH}:~/android-sdk/tools
export PATH=${PATH}:~/android-sdk/platform-tools

### Visual Settings ###
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Include Files ###
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Exports and Aliases: ${duration}ms"
fi

### Prompt ###
#if [ -f "$HOME/Library/Python/2.7/lib/python/site-packages/Powerline-beta-py2.7.egg/powerline/bindings/bash/powerline.sh" ]; then
#  export TERM=screen-256color
#  source ~/Library/Python/2.7/lib/python/site-packages/Powerline-beta-py2.7.egg/powerline/bindings/bash/powerline.sh
#elif [ -f "$HOME/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh" ]; then
#  export TERM=screen-256color
#  source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
#fi
# Install powerline via PIP so that it registers the libs

start=$(getms)

# To do things this way I will need to register the python extension modules manually
# Possibly add the extensions directory to the python path
if [ ! -d ~/.git_repos/powerline ]; then
  echo "Cloning Powerline GIT repository"
  mkdir -p ~/.git_repos
  git clone git@github.com:Lokaltog/powerline.git ~/.git_repos/powerline
fi
if [ ! -d ~/.git_repos/powerline/build/ ]; then
  echo "- Building Powerline"
  # TODO: This requires python-pip (which includes setuptools)
  if [[ $OS == 'Ubuntu' ]]; then
    echo "Installing python-setuptools"
    sudo apt-get install python-setuptools
  elif [[ $OS == 'ARCH' ]]; then
    echo "Installing python-setuptools"
    sudo pacman -S install python-setuptools
    # Something may be funky with python here so need to test
  fi
  cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py build && cd
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Get powerline and install deps: ${duration}ms"
fi

start=$(getms)

#if [ -f ~/.git/powerline/powerline/bindings/bash/powerline.sh ]; then
  #export PATH=/Users/phutchins/Library/Python/2.7/bin:~/.git/powerline/usr/local/bin:$PATH
  #source ~/.git/powerline/usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
  # Fix this so I can use the line below. Powerline doesn't like the jobnum argument in powerline.sh
  #source ~/.git/powerline/powerline/bindings/bash/powerline.sh
if [[ $platform == 'linux' ]]; then
  #if [ ! 'pip list | grep Powerline' ]; then
  #  echo "Installing Powerline with pip"
    #sudo apt-get install python-setuptools
    #pip install --user git+git://github.com/Lokaltog/powerline
  #fi
  if [ ! -f ~/.local/bin/powerline-render ]; then
    echo "- Installing Powerline"
    cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install --user && cd
  fi
  if [ ! -h ~/.local/bin/powerline ] && [ ! -f ~/.local/bin/powerline ]; then
    ln -s ~/.git_repos/powerline/scripts/powerline ~/.local/bin/powerline
  fi
  export PATH=~/.local/bin:$PATH
  #export PATH=~/.git_repos/powerline/usr/local/bin:$PATH
  export TERM=screen-256color
  if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
  #if [ -f ~/.git_repos/powerline/build/lib.linux-x86_64-2.7/powerline/bindings/bash/powerline.sh ]; then
  #  source ~/.git_repos/powerline/build/lib.linux-x86_64-2.7/powerline/bindings/bash/powerline.sh
  #elif [ -f ~/.local/lib/python2.6/site-packages/Powerline-beta-py2.6.egg/powerline/bindings/bash/powerline.sh ]; then
  #  source ~/.local/lib/python2.6/site-packages/Powerline-beta-py2.6.egg/powerline/bindings/bash/powerline.sh
  elif [ -f ~/.git_repos/powerline/powerline/bindings/bash/powerline.sh ]; then
    source ~/.git_repos/powerline/powerline/bindings/bash/powerline.sh
  #elif [ -f ~/.local/lib/python2.7/site-packages/Powerline-beta-py2.6.egg/powerline/bindings/bash/powerline.sh ]; then
  #  source ~/.local/lib/python2.7/site-packages/Powerline-beta-py2.6.egg/powerline/bindings/bash/powerline.sh
  else
    echo "Cannot source powerline.sh for BASH"
  fi
  alias ls='ls --color=auto'

  #POWERLINE_COMMAND="$POWERLINE_COMMAND -c ext.shell.theme=default_leftonly"
  PS1="\[\033[01;34m\]\u\[\033[01;32m\]@\[\033[01;31m\]\h\[\033[32m\][\[\033[01;30m\]\w\[\033[32m\]]\[\033[31m\]>\[\033[00m\]"
elif [[ $platform == 'osx' ]]; then
  # Commenting this way out for now, may be needed... need to test
  #if [ ! 'pip list | grep Powerline' ]; then
  #  echo "Installing Powerline with pip"
  #  brew install python
  #  brew linkapps
  #  #pip install git+git://github.com/Lokaltog/powerline
  #fi

  #if [ ! -f ~/.local/bin/powerline-render ]; then
  if [ ! -f /usr/local/bin/powerline-render ]; then
    echo "- Installing Powerline"
    #cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install --user && cd
    cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install && cd
  fi
  #if [ ! -h ~/.local/bin/powerline ]; then
  #  ln -s ~/.git_repos/powerline/scripts/powerline ~/.local/bin/powerline
  #fi
  # Make this only copy files if they don't exist
  # cp -r ~/github/dot-files/fonts/* ~/Library/Fonts/
  #if [ ! -f ~/Library/Python/2.7/bin/powerline ]; then
  #  echo "- Installing Powerline"
  #  cd ~/.git_repos/powerline && python ~/.git_repos/powerline/setup.py install --user && cd
  #fi
  #export PATH=~/.git_repos/powerline/usr/local/bin:$PATH
  export TERM=screen-256color
  export JAVA_HOME=$(/usr/libexec/java_home)
  if [ -f ~/Library/Python/2.7/lib/python/site-packages/Powerline-beta-py2.7.egg/powerline/bindings/bash/powerline.sh ]; then
    source ~/Library/Python/2.7/lib/python/site-packages/Powerline-beta-py2.7.egg/powerline/bindings/bash/powerline.sh
  elif [ -f ~/.git_repos/powerline/powerline/bindings/bash/powerline.sh ]; then
    source ~/.git_repos/powerline/powerline/bindings/bash/powerline.sh
  elif [ -f ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
  fi
  #PS1="\[\033[01;34m\]\u\[\033[01;32m\]@\[\033[01;31m\]\h\[\033[32m\][\[\033[01;30m\]\w\[\033[32m\]]\[\033[31m\]>\[\033[00m\]"
  alias ls="ls -F"
  # Probably better to find how to do this though the config file but will be easier on a clean install box
  #POWERLINE_COMMAND="$POWERLINE_COMMAND -c ext.shell.theme=default_leftonly"
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Setup powerline: ${duration}ms"
fi


### Update all git repos in github directory at once ###
function gitup {
  CURR_DIR=${PWD}
  for i in $(\ls -d ~/github/*); do
    if [ -d ${i}/.git_repos ]; then
      echo "Updating $i"
      cd $i
      git up
    fi
  done
  cd $CURR_DIR
}

start=$(getms)

### RVM ###
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Configure RVM: ${duration}ms"
fi

start=$(getms)

# Install and set up NVM
if [[ $platform == 'linux' ]]; then
  if [ -f "$HOME/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  fi
elif [[ $platform == 'osx' ]]; then
  if [ -f "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  else
    brew install nvm
  fi
fi

duration=$(($(getms) - start ))
if [ "$SHOW_TIMERS" = true ]; then
  echo "Install and setup NVM: ${duration}ms"
fi
