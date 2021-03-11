#!/bin/bash

# create service account and cluster role
kubectl create serviceaccount dashboard-admin-sa && kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa

# output token to a file
kubectl describe secret $(kubectl get secrets |grep dash |awk {'print $1}') > dash-token.txt

# display the file
cat dash-token.txt
