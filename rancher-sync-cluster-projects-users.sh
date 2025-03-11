 export KUBECONFIG=~/Downloads/rancher-local.yaml
 SOURCE_CLUSTER=c-m-cp5rckkd
 TARGET_CLUSTER=c-m-9rtg6cmz

 kubectl get project.management.cattle.io -n ${SOURCE_CLUSTER} -o  yaml |\
 yq -y 'del(.items[].status)|del(.items[].metadata.resourceVersion)|del(.items[].metadata.uid)|del(.items[].metadata.creationTimestamp)|.items[]' |\
 sed "s,${SOURCE_CLUSTER},${TARGET_CLUSTER},g" |\
 kubectl apply -f -

kubectl get projectroletemplatebindings.management.cattle.io -n ${SOURCE_CLUSTER} -o  yaml |\
 yq -y 'del(.items[].status)|del(.items[].metadata.resourceVersion)|del(.items[].metadata.uid)|del(.items[].metadata.creationTimestamp)|.items[]' |\
 sed "s,${SOURCE_CLUSTER},${TARGET_CLUSTER},g" | sed -E -e "s,name: (prtb-[a-zA-Z0-9]+),name: \\1-${TARGET_CLUSTER},g" |\
 kubectl apply -f -