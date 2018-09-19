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

function get_dtr_node_core (){
  echo -n " DTR node core count"
  token=$(curl -sk -d '{"username":"admin","password":"'$password'"}' https://$ucp_server/auth/login | jq -r .auth_token)
  node=$(curl -skX GET "https://$ucp_server/containers/json" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Image | contains("docker/dtr-nginx")) | .Labels."com.docker.swarm.constraints" '|sed -e 's/\[\"node==//g' -e 's/\"\]//g')

  #get cpu
  node_cpu=$(curl -skX GET "https://$ucp_server/nodes" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Description.Hostname | contains("'$node'")) | .Description.Resources.NanoCPUs')

  #get mem - not needed
  #node_mem=$(curl -skX GET "https://$ucp/nodes" -H  "accept: application/json" -H "Authorization: Bearer $token" | jq -r '.[] | select (.Description.Hostname | contains("'$node'")) | .Description.Resources.MemoryBytes')

  #calculate core and 1/2 of core.
  node_core=$(( $node_cpu/1000000000 ))
  node_core_half=$(( $node_core/2 ))
  echo "$GREEN" " = "$node_core"" "[ok]" "$NORMAL"
  get_map
}

function modify_workers (){
  echo -n " updating DTR worker count"
  worker_id=$(curl -skX GET -u admin:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq -r .workers[0].id)
  curl -skX POST -u admin:$password "https://$dtr_server/api/v0/workers/$worker_id/capacity" -H "accept: application/json" -H "content-type: application/json" -d '{ "capacityMap": { "mirror": '$node_core_half', "scan": '$node_core_half', "scanCheck": '$node_core' }}' > /dev/null 2>&1
  echo "$GREEN" "[ok]" "$NORMAL"
  get_map
}

function get_map (){
  echo " Current DTR capacityMap:"
  curl -skX GET -u admin:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq .workers[0].capacityMap
}

function example (){
  echo "$GREEN" "- Here is an example curl for manual manipulation. " "$NORMAL"
  echo " #get worker id"
  echo "$GREEN" 'worker_id=$(curl -skX GET -u admin:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq -r .workers[0].id)' "$NORMAL"
  echo ""
  echo " #update capacityMap"
  echo "$GREEN" "curl -skX POST -u admin:$password "https://$dtr_server/api/v0/workers/$worker_id/capacity" -H "accept: application/json" -H "content-type: application/json" -d '{ "capacityMap": { "mirror": '$node_core_half', "scan": '$node_core_half', "scanCheck": '$node_core' }}'" "$NORMAL"
}


function reset (){
  echo -n " updating DTR worker count"
  worker_id=$(curl -skX GET -u admin:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq -r .workers[0].id)
  curl -skX POST -u admin:$password "https://$dtr_server/api/v0/workers/$worker_id/capacity" -H "accept: application/json" -H "content-type: application/json" -d '{ "capacityMap": { "mirror": 1, "scan": 1, "scanCheck": 1 }}' > /dev/null 2>&1
  echo "$GREEN" "[ok]" "$NORMAL"
  get_map
}

function status (){
  echo " Usage: $0 {"$GREEN"get "$NORMAL" - list | "$GREEN" modify "$NORMAL" - update | "$GREEN" curl "$NORMAL" - example curl | "$GREEN" reset "$NORMAL" - reset values to 1}"
  exit 1
}

echo "$RED" "- This tool currently only works for a single DTR Repica -" "$NORMAL"
if ! $(which -s curl); then echo "$RED" " ** Curl was not found. Please install before preceeding. ** " "$NORMAL" ; fi
if ! $(which -s jq); then echo "$RED" " ** Jq was not found. Please install before preceeding. ** " "$NORMAL" ; fi

case "$1" in
        get) get_dtr_node_core;;
        update) get_dtr_node_core && modify_workers;;
        reset) reset;;
        curl) example;;
        *) status
esac

#curl -skX GET -u admin:$password "https://$dtr_server/api/v0/workers/" -H "accept: application/json" | jq .
