CLUSTER_NAME=<Your Cluster Name>
HIGH_MEM_SPOT=("n2d-highmem-16" "c2d-highmem-16" "n2-highmem-16")
HIGH_MEM_ONDEMAND=("n2d-highmem-16" "c2d-highmem-16" "n2-custom-20-131072")
HIGH_CPU_SPOT=("n2d-custom-16-32768" "t2d-standard-16" "c2d-standard-16" "n2-standard-16")
HIGH_CPU_ONDEMAND=("n2d-custom-16-32768" "t2d-standard-16" "c2d-standard-16" "n2-custom-16-81920")
INTEL_SPOT=("n2-custom-16-32768" "c2-standard-16")
INTEL_ONDEMAND=("n2-custom-16-32768" "c2-standard-16")
SA_NAME="<Your service-account name>"

echo "start GKE node pool provisioning, cluster name: "$CLUSTER_NAME
##default node pool
# gcloud beta container clusters create $CLUSTER_NAME \
# --region us-central1 \
# --node-locations us-central1-a \
# --machine-type=e2-standard-4 \
# --service-account=$SA_NAME \
# --num-nodes 1


gcloud container clusters get-credentials $CLUSTER_NAME --region us-central1

# echo "start high mem on-demand provisioning"
echo "start high mem ondemand provisioning"
for instancetype in ${HIGH_MEM_ONDEMAND[@]}; do
  if [[ ${instancetype} =~ "t2d" ]];then
    gcloud beta container node-pools create "ondemand-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=ondemand,machine-type=memoptimize \
    --node-locations "us-central1-a","us-central1-f"
  elif [[ ${instancetype} =~ "c2d" ]];then
    gcloud beta container node-pools create "ondemand-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=ondemand,machine-type=memoptimize \
    --node-locations "us-central1-a","us-central1-f","us-central1-c"
  elif [[ ${instancetype} =~ "n2d" ]];then
    gcloud beta container node-pools create "ondemand-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --min-cpu-platform=AMD\ Milan \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=ondemand,machine-type=memoptimize
  else
    gcloud beta container node-pools create "ondemand-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=ondemand,machine-type=memoptimize
   fi
done

#high mem spot
echo "start high mem spot provisioning"
for instancetype in ${HIGH_MEM_SPOT[@]}; do
  if [[ ${instancetype} =~ "t2d" ]];then
    gcloud beta container node-pools create "spot-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=spot,machine-type=memoptimize \
    --node-locations "us-central1-a","us-central1-f" \
    --spot
  elif  [[ ${instancetype} =~ "c2d" ]];then
    gcloud beta container node-pools create "spot-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=spot,machine-type=memoptimize \
    --node-locations "us-central1-a","us-central1-f","us-central1-c"  \
    --spot
  elif  [[ ${instancetype} =~ "n2d" ]];then
    gcloud beta container node-pools create "spot-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --min-cpu-platform=AMD\ Milan \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=spot,machine-type=memoptimize \
    --spot
  else
    gcloud beta container node-pools create "spot-mem-"${instancetype%%-*}"-v2" \
    --cluster=$CLUSTER_NAME \
    --region us-central1 \
    --machine-type=$instancetype \
    --num-nodes 0 \
    --max-nodes=600 \
    --enable-autoscaling \
    --disk-size "500" \
    --disk-type "pd-ssd" \
    --service-account=$SA_NAME \
    --node-labels=ondemand-spot=spot,machine-type=memoptimize \
    --spot
  fi
done

echo "start high cpu on-demand provisioning"
for instancetype in ${HIGH_CPU_ONDEMAND[@]}; do
    if [[ ${instancetype} =~ "t2d" ]];then
      gcloud beta container node-pools create "ondemand-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=ondemand,machine-type=cpuoptimize \
      --node-locations "us-central1-a","us-central1-f"
    elif [[ ${instancetype} =~ "c2d" ]];then
      gcloud beta container node-pools create "ondemand-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=ondemand,machine-type=cpuoptimize \
      --node-locations "us-central1-a","us-central1-f","us-central1-c"
    elif [[ ${instancetype} =~ "n2d" ]];then
      gcloud beta container node-pools create "ondemand-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --min-cpu-platform=AMD\ Milan \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=ondemand,machine-type=cpuoptimize
    else
      gcloud beta container node-pools create "ondemand-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=ondemand,machine-type=cpuoptimize
    fi
done

#high CPU spot
echo "start high cpu spot provisioning"
for instancetype in ${HIGH_CPU_SPOT[@]}; do
   if [[ ${instancetype} =~ "t2d" ]];then
      gcloud beta container node-pools create "spot-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=spot,machine-type=cpuoptimize \
      --node-locations "us-central1-a","us-central1-f" \
      --spot
    elif [[ ${instancetype} =~ "c2d" ]];then
      gcloud beta container node-pools create "spot-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=spot,machine-type=cpuoptimize \
      --node-locations "us-central1-a","us-central1-f","us-central1-c" \
      --spot
     elif [[ ${instancetype} =~ "n2d" ]];then
      gcloud beta container node-pools create "spot-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --min-cpu-platform=AMD\ Milan \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=spot,machine-type=cpuoptimize \
      --spot
    else
      gcloud beta container node-pools create "spot-cpu-"${instancetype%%-*}"-v2" \
      --cluster=$CLUSTER_NAME \
      --region us-central1 \
      --machine-type=$instancetype \
      --num-nodes 0 \
      --max-nodes=600 \
      --enable-autoscaling \
      --disk-size "500" \
      --disk-type "pd-ssd" \
      --service-account=$SA_NAME \
      --node-labels=ondemand-spot=spot,machine-type=cpuoptimize \
      --spot
    fi

done

#intel CPU spot
echo "start intel on-demand provisioning"
for instancetype in ${INTEL_ONDEMAND[@]}; do
  gcloud beta container node-pools create "ondemand-cpu-intel-"${instancetype%%-*}"-v2" \
  --cluster=$CLUSTER_NAME \
  --region us-central1 \
  --machine-type=$instancetype \
  --num-nodes 0 \
  --max-nodes=600 \
  --enable-autoscaling \
  --disk-size "500" \
  --disk-type "pd-ssd" \
  --service-account=$SA_NAME \
  --node-labels=ondemand-spot=ondemand,machine-type=inteloptimize
done

#intel CPU spot
echo "start intel spot provisioning"
for instancetype in ${INTEL_SPOT[@]}; do
  gcloud beta container node-pools create "spot-cpu-intel-"${instancetype%%-*}"-v2" \
  --cluster=$CLUSTER_NAME \
  --region us-central1 \
  --machine-type=$instancetype \
  --num-nodes 0 \
  --max-nodes=600 \
  --enable-autoscaling \
  --disk-size "500" \
  --disk-type "pd-ssd" \
  --service-account=$SA_NAME \
  --node-labels=ondemand-spot=spot,machine-type=inteloptimize \
  --spot
done