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
sr () { echo "Running command on $1"; knife ssh "stack:$1" -a rackspace.public_ip -p 7453 -x philip "$2"; }

# Bundler
alias be='bundle exec'

# Processes
ka () { kill $(ps aux | grep "$@" | grep -v "grep" | awk '{print $2}'); }

# Docker
alias dockerip='docker ps | tail -n +2 | while read cid b; do echo -n "$cid\t"; docker inspect $cid | grep IPAddress | cut -d \" -f 4; done'

# BitPay
alias tnbitpay='/Applications/Bitcoin-Qt.app/Contents/MacOS/Bitcoin-Qt -datadir=/Users/phutchins/bitpay/testnet/bitpay'
alias tncustomer='/Applications/Bitcoin-Qt.app/Contents/MacOS/Bitcoin-Qt -datadir=/Users/phutchins/bitpay/testnet/customer'
alias tntestnet='/Applications/Bitcoin-Qt.app/Contents/MacOS/Bitcoin-Qt -datadir=/Users/phutchins/bitpay/testnet/pubtestnet'
