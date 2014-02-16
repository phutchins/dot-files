alias ls='ls -G'

# GIT
alias gaa='git add . --all'
alias gc='git commit -m'
alias gp='git push'
alias gu='git up'
alias gup='gu && gp'
alias gac='gaa && gc'
alias tags='git show-ref --tags -d'

# Chef & Knife
alias ku='knife cookbook upload'

# Bundler
alias be='bundle exec'

# Processes
ka () { kill $(ps aux | grep "$@" | grep -v "grep" | awk '{print $2}'); }
