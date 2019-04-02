# DTR Worker capacityMap Updater

## Purpose

This script will list, update, and reset DTR's capacityMap `mirror`, `scan`, and `scanCheck` based on the number of cores per DTR replica (i.e. DTR Worker node).

## How to Run

You may build a Docker image and then run the image wherever you so chose. Or, you can run the bash script directly.

## How to Run: Docker Image

1. Clone this repo
1. Build the Docker image:

    `docker image build -t dtr_worker:1.0 -f ./Dockerfile .`

1. Run the Docker image:

    `read -sp 'Password: ' password; docker container run -it --rm -e ucp_server="ucp.example.com" -e dtr_server="dtr.example.com" -e username="admin-user" -e password=${password} dtr_worker:1.0 <command>`

## How to Run: bash script

1. Run the script:

    ```
    username=admin-user; \
    ucp_server=ucp.example.com; \
    dtr_server=dtr.example.com; \
    read -sp 'Password: ' password; ./dtr_worker.sh <command>
    ```

## Usage

```bash
clemenko:clemenko Desktop $ ./dtr_worker.sh usage
 Usage: ./dtr_worker.sh {list  - list current map |  update  - update map to half core |  reset  - reset values to 1}
```

## Sample get output
```bash
clemenko:clemenko Desktop $ username=admin-user; \
ucp_server=ucp.example.com; \
dtr_server=dtr.example.com; \
read -sp 'Password: ' password; ./dtr_worker.sh list
Password:


 connecting to UCP for node name and node NanoCPU values, then connecting to DTR to get capacityMap for each DTR replica.
 connecting to UCP for a token and the list of DTR replicas
 Node = ip-172-33-23-244.us-west-2.compute.internal Replica = a07a1ebe2036 CPU = 4000000000 
{
  "mirror": 1,
  "scan": 2,
  "scanCheck": 2
}
 Node = ip-172-33-47-225.us-west-2.compute.internal Replica = 543ab90f1e19 CPU = 4000000000 
{
  "mirror": 1,
  "scan": 2,
  "scanCheck": 2
}
 Node = ip-172-33-7-220.us-west-2.compute.internal Replica = 0c5c109ed45c CPU = 4000000000 
{
  "mirror": 1,
  "scan": 2,
  "scanCheck": 2
}

```

## Sample update output
```bash
clemenko:clemenko Desktop $ username=admin-user; \
ucp_server=ucp.example.com; \
dtr_server=dtr.example.com; \
read -sp 'Password: ' password; ./dtr_worker.sh update
Password:


 connecting to UCP for a token and the list of DTR replicas
 updating DTR workers
  Updated a07a1ebe2036  [ok] 
  Updated 543ab90f1e19  [ok] 
  Updated 0c5c109ed45c  [ok] 
clemenko:clemenko Desktop $ username=admin-user; \
ucp_server=ucp.example.com; \
dtr_server=dtr.example.com; \
read -sp 'Password: ' password; ./dtr_worker.sh list
Password:


 connecting to UCP for node name and node NanoCPU values, then connecting to DTR to get capacityMap for each DTR replica.
 connecting to UCP for a token and the list of DTR replicas
 Node = ip-172-33-23-244.us-west-2.compute.internal Replica = a07a1ebe2036 CPU = 4000000000 
{
  "mirror": 2,
  "scan": 2,
  "scanCheck": 4
}
 Node = ip-172-33-47-225.us-west-2.compute.internal Replica = 543ab90f1e19 CPU = 4000000000 
{
  "mirror": 2,
  "scan": 2,
  "scanCheck": 4
}
 Node = ip-172-33-7-220.us-west-2.compute.internal Replica = 0c5c109ed45c CPU = 4000000000 
{
  "mirror": 2,
  "scan": 2,
  "scanCheck": 4
}
```
