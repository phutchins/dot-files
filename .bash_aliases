alias ls='ls -G'

alias gaa='git add . --all'
alias gc='git commit -m'
alias gp='git push'
alias gu='git up'

alias gup='gu && gp'

alias gac='gaa && gc'
alias ku='knife cookbook upload'

ka () { kill $(ps aux | grep "$@" | grep -v "grep" | awk '{print $2}'); }

alias tags='git show-ref --tags -d'
