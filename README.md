# DTR Worker capacityMap Updater

## Purpose
This script whille update DTR's capacityMap for the number of cores.

## Edit the Script - update variables.
```
vim dtr_worker.sh
```

## Usage
```
./dtr_worker.sh Usage
- This tool currently only works for a single DTR Repica -
Usage: ./dtr_worker.sh {get  - list |  modify  - update |  curl  - example curl |  reset  - reset values to 1}
```

## Sample get output
```
clemenko:dtr_worker clemenko $ ./dtr_worker.sh get
 - This tool currently only works for a single DTR Repica -
 DTR node core count  = 2 [ok]
 Current DTR capacityMap:
{
  "mirror": 1,
  "scan": 1,
  "scanCheck": 1
}
```

## Sample update output
```
clemenko:dtr_worker clemenko $ ./dtr_worker.sh update
 - This tool currently only works for a single DTR Repica -
 DTR node core count  = 2 [ok]
 Current DTR capacityMap:
{
  "mirror": 1,
  "scan": 1,
  "scanCheck": 1
}
 updating DTR worker count [ok]
 Current DTR capacityMap:
{
  "mirror": 1,
  "scan": 1,
  "scanCheck": 2
}
```
