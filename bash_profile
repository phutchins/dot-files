if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# . /Users/phutchins/github/powerline/powerline/bindings/bash/powerline.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
