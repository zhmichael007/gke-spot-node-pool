# gke-spot-node-pool

open cloud shell. 


git clone the source code:
```bash
git clone https://github.com/zhmichael007/gke-spot-node-pool
```

Set the cluster name in the 
```bash
CLUSTER_NAME=<Your Cluster Name>
SA_NAME="<Your service-account name>"
```

and use bash to run the script
```bash
bash gke_cluster_nodepool_create.sh
```
