# Aliases to write
# Delete pods with sleep
# for host in $(kubectl -n storj-staging get pods | awk '{print $1;}'); do echo $host; sleep 15; done

alias ls='ls -G'

alias gaa='git add . --all'
alias gc='git commit -m'
alias gp='git push'
alias gu='git up'
alias gss='git rev-parse --short HEAD'

alias gup='gu && gp'
alias gac='gaa && gc'
alias gbl='git for-each-ref --sort=-committerdate refs/heads/'
alias tags='git show-ref --tags -d'
alias sha='git rev-parse HEAD'
alias sgrep='egrep -Rso '.{0,40}$@.{0,40}' ./*'
alias vi='vim'
alias vim='/usr/local/bin/vim'
alias gfer='git for-each-ref --sort=-committerdate refs/heads/'
alias sbrc='source ~/.bashrc'
alias timeout='gtimeout'

# Chef & Knife
alias ku='knife cookbook upload'
knife-bootstrap () { knife bootstrap -N $@ -E internal_production -i ~/.ssh/DevOps.pem -r "recipe[base]" -x ubuntu --sudo $@; }

# Knife SSH Shortcut - Need to make sure to enter the command to execute in quotes and use sudo with -i to get env
# Should add ability to do environment also and some help...
# knife ssh "name:bridge-api-* AND chef_environment:production" -a cloud_v2.public_ipv4 -x philip "sudo -i hostname"
crn () { echo "Running command on $1"; knife ssh "name:$1" -a cloud_v2.public_ipv4 -x philip "$2"; }
crr () { echo "Running command on $1"; knife ssh "recipes:$1" -a cloud_v2.public_ipv4 -x philip "$2"; }

# Bundler
alias be='bundle exec'

# Processes
ka () { kill $(ps aux | grep "$@" | grep -v "grep" | awk '{print $2}'); }

# Docker
alias dockerip='docker ps | tail -n +2 | while read cid b; do echo -n "$cid\t"; docker inspect $cid | grep IPAddress | cut -d \" -f 4; done'
dockerenv () { eval $(docker-machine env $@); }
dcleanup(){
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
alias dc='docker-compose'

# Plist Services for OSX
alias startmongo='launchctl load /usr/local/Cellar/mongodb/3.2.4/homebrew.mxcl.mongodb.plist'
alias stopmongo='launchctl unload /usr/local/Cellar/mongodb/3.2.4/homebrew.mxcl.mongodb.plist'
alias startredis='launchctl load /usr/local/Cellar/redis/3.0.7/homebrew.mxcl.redis.plist'
alias stopredis='launchctl unload /usr/local/Cellar/redis/3.0.7/homebrew.mxcl.redis.plist'
alias starttinyproxy='/usr/local/Cellar/tinyproxy/1.8.3/sbin/tinyproxy'
alias startelasticsearch='launchctl load /usr/local/Cellar/elasticsearch/5.3.0/homebrew.mxcl.elasticsearch.plist'
#alias startelasticsearch='brew services start elasticsearch'
alias stopelasticsearch='launchctl unload /usr/local/Cellar/elasticsearch/5.3.0/homebrew.mxcl.elasticsearch.plist'

alias pp='python -mjson.tool'

certinfo () { echo | openssl s_client -connect $1:443 2>/dev/null | openssl x509 -noout -issuer -subject -dates; }
getcert () { echo | openssl s_client -connect $1:443 2>/dev/null | openssl x509 -noout -text; }
getcertexp () { echo | openssl s_client -connect $1:443 2>/dev/null | openssl x509 -noout -dates; }
getallcertexp () {
  exp=`openssl x509 -noout -text -in $cert | grep "Not After" | cut -d: -f2-10`
  echo $cert expires $exp
}

# alias awsenv='echo $AWS_ENVIRONMENT'
awsenv () {
  if [[ -z "$@" ]]; then
    echo $AWS_ENVIRONMENT;
  else
    source ~/.aws/$@.sh;
    echo "AWS Environment Set To: $AWS_ENVIRONMENT";
  fi;
}
awssetenv () { source ~/.aws/$@.sh; }

## Kubernetes ##
# Run kubectl and set the namespace by environment variable
kube () { kubectl --namespace=$KUBECTL_NAMESPACE $@; }
# Copy files out of a container
# ToDo later: $(kubectl exec <pod-name> [-c <container-name>] -it -- cat <file-path>) > <local-file>
# Set the kubernetes namespace environment variable
kns () {
  if [[ -z "$@" ]]; then
    echo "Kubernetes Namespace is currently: $KUBECTL_NAMESPACE";
  else
    export KUBECTL_NAMESPACE="$@";
    echo "Kubernetes Namespace Set To: $KUBECTL_NAMESPACE";
  fi;
}
# Execute a bash shell inside of a container
keb () {
  if [[ -z "$@" ]]; then
    echo "Please provide a pod name"
  else
    kube exec -it $@ /bin/bash
  fi;
}

# Tail the logs for a container starting with the last 100 lines
ktl () {
  if [[ -z "$@" ]]; then
    echo "Please provide a pod name"
  else
    kube logs --tail=100 -f $@
  fi;
}

# Set the kubernetes current context
kenv () {
  if [[ -z "$@" ]]; then
    CURRENT_CONTEXT=$(kubectl config current-context);
    echo "Kubernetes environment is currently: $CURRENT_CONTEXT";
  else
    PREVIOUS_CONTEXT=$(kubectl config current-context);
    KUBECTL_OUTPUT=$(kubectl config use-context $@.storj.io)
    CURRENT_CONTEXT=$(kubectl config current-context);
    echo "Kubernetes environment changed from $PREVIOUS_CONTEXT to $CURRENT_CONTEXT";
  fi;
}

# Patch a cronjob to sleep
#kubectl --context prod-europe-west1 -n jupiter-satellite patch cronjob pg-backup-runner-jupiter-satellite-postgres --type json -p='[{"op": "add", "path": "/spec/jobTemplate/spec/template/spec/containers/0", "value": { "args": [{"-c", "while true; do echo hello; sleep 10; done"}], "command": "/bin/sh" } }]'

# Storj SDK
sdk-mongo () { mongo $($STORJ_SDK_DIR/scripts/get_local_db.sh); }
