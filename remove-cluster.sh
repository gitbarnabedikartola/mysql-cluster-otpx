#!/usr/bin/env bash

nameSpace=otpx

kubectl patch -n $nameSpace innodbclusters.mysql.oracle.com mysql-cluster --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]'

podList=$(kubectl -n $nameSpace get pods | grep -E mysql-cluster-[0-9] | awk '{print $1}')
for pod in $podList; do
  kubectl patch -n $nameSpace pods $pod --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done

pvcList=$(kubectl -n $nameSpace get persistentvolumeclaims | grep -E mysql-cluster-[0-9] | awk '{print $1}')
for pvc in $pvcList; do
  kubectl patch -n $nameSpace persistentvolumeclaims $pvc --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done

kubectl delete -f deployment.yml
