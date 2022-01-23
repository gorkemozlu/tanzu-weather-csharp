#!/bin/bash -xe

workloadName=$1
imageRef=$(kubectl get workload ${workloadName} -n dev -o=jsonpath='{.spec.source.image}')
jsonpath='{.items[?(@.metadata.annotations.developer\.apps\.tanzu\.vmware\.com/image-source-digest=="'$imageRef'")].metadata.name}'
while [[ -z $(kubectl get pod -n dev -o jsonpath=$jsonpath) ]]; do echo "Waiting for new workload \"${workloadName}\"" && sleep 10; done
podName=$(kubectl get pod -n dev -o jsonpath=$jsonpath)
kubectl wait pod -n dev --for=condition=ready $podName