if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# . /Users/phutchins/github/powerline/powerline/bindings/bash/powerline.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# The next line updates PATH for the Google Cloud SDK.
[[ -e "$HOME/google-cloud-sdk/path.bash.inc" ]] && source '/Users/philip/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
[[ -e "$HOME/google-cloud-sdk/completion.bash.inc" ]] && source '/Users/philip/google-cloud-sdk/completion.bash.inc'

export PATH="$HOME/.cargo/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/philip/google-cloud-sdk/path.bash.inc' ]; then source '/Users/philip/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/philip/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/philip/google-cloud-sdk/completion.bash.inc'; fi

function kubectl() { command ~/.kube/plugins/verify/verify.sh "${@}" &&  case $* in "deploy"*) shift 1; command kubectl plugin deploy --path=$PWD "${@/--silent/}" ;; *"ssh"* ) shift 1; command kubectl plugin ssh "${@/--silent/}";; *"get-node-ip"* )shift 1; command kubectl plugin get-node-ip "${@/--silent/}" ;; *"switch"* ) shift 1; command kubectl plugin switch "${@/--silent/}" ;; *"uptime"* ) shift 1; command kubectl plugin uptime ;; * ) command kubectl "${@/--silent/}" ;; esac }

