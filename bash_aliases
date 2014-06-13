alias ls='ls -G'

alias gaa='git add . --all'
alias gc='git commit -m'
alias gp='git push'
alias gu='git up'

alias gup='gu && gp'
alias gac='gaa && gc'
alias tags='git show-ref --tags -d'
alias sha='git rev-parse HEAD'
alias sgrep='egrep -Rso '.{0,40}$@.{0,40}' ./*'

# Chef & Knife
alias ku='knife cookbook upload'
knife-bootstrap () { knife bootstrap -N $@ -E internal_production -i ~/.ssh/DevOps.pem -r "recipe[base]" -x ubuntu --sudo $@; }

# Bundler
alias be='bundle exec'

# Processes
ka () { kill $(ps aux | grep "$@" | grep -v "grep" | awk '{print $2}'); }
