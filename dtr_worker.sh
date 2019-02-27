#!/bin/bash
#simplify the updating of dtr workers.
###################################
# edit vars
###################################
set -e

#set variables
ucp_server=ucp.dockr.life
dtr_server=dtr.dockr.life
username=admin

######  NO MOAR EDITS #######
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

#get password.
#read -sp 'password: ' password;
password=Pa22word

#reset variables
token=""
replicas=""

function get_replicas () {
  token=$(curl -sk -d '{"username":"'$username'","password":"'$password'"}' https://$ucp_server/auth/login | jq -r .auth_token)
  replicas=$(curl -skX GET "https://$ucp_server/containers/json" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Image | contains("docker/dtr-nginx")) | .Labels."com.docker.compose.service" '|sed -e 's/nginx-//g')
}


function list_workers (){
  get_replicas
  for rep in $replicas; do 
    node=$(curl -skX GET "https://$ucp_server/containers/json" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Labels."com.docker.compose.service" | tostring | contains("nginx-'$rep'")) | .Labels."com.docker.swarm.constraints" '|sed -e 's/\[\"node==//g' -e 's/\"\]//g')
    node_cpu=$(curl -skX GET "https://$ucp_server/nodes" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Description.Hostname | contains("'$node'")) | .Description.Resources.NanoCPUs')

    echo " Node = "$GREEN"$node"$NORMAL" Replica = "$GREEN"$rep"$NORMAL" CPU = "$GREEN"$node_cpu"$NORMAL" "
    curl -skX GET -u $username:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq '.workers[] | select (.id | contains("'$rep'")) | .capacityMap ' 
  done
}


function update_workers (){
  echo " updating DTR workers"
  get_replicas

  for rep in $replicas; do
    node=$(curl -skX GET "https://$ucp_server/containers/json" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Labels."com.docker.compose.service" | tostring | contains("nginx-'$rep'")) | .Labels."com.docker.swarm.constraints" '|sed -e 's/\[\"node==//g' -e 's/\"\]//g')
    node_cpu=$(curl -skX GET "https://$ucp_server/nodes" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Description.Hostname | contains("'$node'")) | .Description.Resources.NanoCPUs')

    #calculate core and 1/2 of core.
    node_core=$(( $node_cpu/1000000000 ))
    node_core_half=$(( $node_core/2 ))

    curl -skX POST -u $username:$password "https://$dtr_server/api/v0/workers/$rep/capacity" -H "accept: application/json" -H "content-type: application/json" -d '{ "capacityMap": { "mirror": '$node_core_half', "scan": '$node_core_half', "scanCheck": '$node_core' }}' > /dev/null 2>&1
    echo "  Updated $rep $GREEN" "[ok]" "$NORMAL"

  done
}

function reset (){
    echo " resetting DTR workers"
  list_workers  

  for rep in $replicas; do
    node=$(curl -skX GET "https://$ucp_server/containers/json" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Labels."com.docker.compose.service" | tostring | contains("nginx-'$rep'")) | .Labels."com.docker.swarm.constraints" '|sed -e 's/\[\"node==//g' -e 's/\"\]//g')
    curl -skX POST -u $username:$password "https://$dtr_server/api/v0/workers/$rep/capacity" -H "accept: application/json" -H "content-type: application/json" -d '{ "capacityMap": { "mirror": '1', "scan": '1', "scanCheck": '1' }}' > /dev/null 2>&1
    echo "  Updated $rep $GREEN" "[ok]" "$NORMAL"

  done
}

function status (){
  echo " Usage: $0 {"$GREEN"list "$NORMAL" - list current map | "$GREEN" update "$NORMAL" - update map to half core | "$GREEN" reset "$NORMAL" - reset values to 1}"
  exit 1
}

#better error checking
command -v curl >/dev/null 2>&1 || { echo "$RED" " ** Curl was not found. Please install before preceeding. ** " "$NORMAL" >&2; exit 1; }

command -v jq >/dev/null 2>&1 || { echo "$RED" " ** Jq was not found. Please install before preceeding. ** " "$NORMAL" >&2; exit 1; }

case "$1" in
        list) list_workers;;
        update) update_workers;;
        reset) reset;;
        *) status
esac