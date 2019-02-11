# DTR Worker capacityMap Updater

## Purpose
This script whille update DTR's capacityMap for the number of cores.

## Edit the Script - update variables.
```
vim dtr_worker.sh
```

## Usage
```bash
clemenko:clemenko Desktop $ ./dtr_worker.sh usage
 Usage: ./dtr_worker.sh {list  - list current map |  update  - update map to half core |  reset  - reset values to 1}
```

## Sample get output
```bash
clemenko:clemenko Desktop $ ./dtr_worker.sh list
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
clemenko:clemenko Desktop $ ./dtr_worker.sh update
 updating DTR workers
  Updated a07a1ebe2036  [ok] 
  Updated 543ab90f1e19  [ok] 
  Updated 0c5c109ed45c  [ok] 
clemenko:clemenko Desktop $ ./dtr_worker.sh list
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
