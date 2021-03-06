# Demo Project Part 2


## Task 9: Install a single node Kubernetes cluster using kubeadm
In task 9, we will be installing a single node kubernetes inside our ubuntu VM and copying the kubernete's admin.conf file to our repo.

1. Comment out the auto mount for swap -> sudo vi /etc/fstab
2. Find the line with swap and UUID in it
3. Go into modify mode, Press i
4. Insert a # in front of the line
   1. Before -> UUID=dec25862-42c7-4494-8f75-e6cc76aa65ea none            swap    sw              0       0
   2. After -> #UUID=dec25862-42c7-4494-8f75-e6cc76aa65ea none            swap    sw              0       0
5. To save, Press ESC and then type in :wq and then Enter and reboot the VM -> sudo reboot
6. Turn off swap -> sudo swapoff -a
7. Update repository information -> sudo apt update
8. Install latest packages -> sudo apt install -y apt-transport-https ca-certificates curl
9. Download the google cloud public signing key
```
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```
10. Add the kubernetes apt repository
```
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
11. Update repository information -> sudo apt update
12. Install latest packages -> sudo apt install -y kubelet kubeadm kubectl
13. Put these programs on hold -> sudo apt-mark hold kubelet kubeadm kubectl
14. Initialize kubernetes -> sudo kubeadm init --pod-network-cidr=192.168.0.0/16
15. Make a home dir for kubernetes conf -> mkdir -p $HOME/.kube
16. Copy config to directory -> sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
17. Change ownership of file -> sudo chown $(id -u):$(id -g) $HOME/.kube/config
18. Copy the file to our git directory -> sudo cp -i /etc/kubernetes/admin.conf ~/project/go-web-hello-world/k8-golang
19. Changing ownership of the file -> sudo chown $(id -u):$(id -g) ~/project/go-web-hello-world/k8-golang/admin.conf
20. We can now check in our code, but let's first check -> cd ~/project/go-web-hello-world/ && git status
21. Add all for posting to repo -> git add --all
22. Write a message for commit -> git commit -m "added admin.conf after kubernetes install"
23. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
    2. Type in password and press enter
24. Unhold Kubernetes' programs -> sudo apt-mark unhold kubelet kubeadm kubectl
25. Remove taint so we can deploy containers on master node -> kubectl taint nodes --all node-role.kubernetes.io/master-
26. Change ownership of file -> sudo chown $(id -u):$(id -g) /etc/kubernetes/kubelet.conf
27. Deploy tigera container -> kubectl apply -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
28. Deploy custom resouces for tigera -> kubectl apply -f https://docs.projectcalico.org/manifests/custom-resources.yaml
29. Check status of pods and services -> kubectl get pods -A ; kubectl get service -A

This concludes the task for setting up kubernetes and copying the config file to our git repository folder.


## Task 10: Deploy the hello world container
In task 10, we will be deploying a kubernetes container using our previous docker image

1. cd ~/project/go-web-hello-world/k8-golang
2. Create kubernetes deployment yaml file ->  kubectl create deployment go-web-hello-world --image=sma88/go-web-hello-world:v0.1 --dry-run=client -o yaml > go-web-deploy.yaml
3. Get the app label from deploy -> cat go-web-deploy.yaml |grep app:
4. Create kubernetes service file to expose the port -> kubectl create service nodeport go-web-nodeport --tcp=8085:31080 --dry-run=client -o yaml > go-web-nodeport.yaml
5. Get the app label from nodeport -> cat go-web-nodeport.yaml |grep app:
6. Replace the label in nodeport yaml with the correct one -> sed -i 's/app: go-web-nodeport/app: go-web-hello-world/g' go-web-nodeport.yaml && cat go-web-nodeport.yaml
7. Replace test targetPort to nodePort -> sed -i 's/targetPort/nodePort/g' go-web-nodeport.yaml && cat go-web-nodeport.yaml
8. Deploy the container -> kubectl apply -f go-web-deploy.yaml
9. Expose the port for the container -> kubectl apply -f go-web-nodeport.yaml
10. Test the container webapp -> curl 127.0.0.1:31080

![image](https://user-images.githubusercontent.com/29349049/110834157-0e133100-8252-11eb-9e96-38c32826aa01.png)

11. We can now check in our code, but let's first check -> cd ~/project/go-web-hello-world/ && git status
12. Add all for posting to repo -> git add --all
13. Write a message for commit -> git commit -m "deployed golang container on k8"
14. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
    2. Type in password and press enter


## Task 11: Install kubernetes dashboard
In task 11, we will be deploying the kubernetes dashboard UI.

1. Deploy kubernetes dashboard UI -> kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
2. Modify service to use nodeport -> kubectl edit service kubernetes-dashboard --namespace kubernetes-dashboard
3. Under the specs section add nodeport and change type to NodePort. Review below for the change

Before 
```
spec:
  clusterIP: 10.98.197.140
  clusterIPs:
  - 10.98.197.140
  externalTrafficPolicy: Cluster
  ports:
  - port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: ClusterIP
```
After
```
spec:
  clusterIP: 10.98.197.140
  clusterIPs:
  - 10.98.197.140
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 31081
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: NodePort
```
4. To save, Press ESC and then type in :wq and then Enter
5. Check if they are running -> kubectl get pods -A ; kubectl get service -A
![image](https://user-images.githubusercontent.com/29349049/110833855-baa0e300-8251-11eb-8ce5-4b76c92a3cef.png)
6. You can type into the browser https://127.0.0.1:31081 and it will lead to the login page below.

![image](https://user-images.githubusercontent.com/29349049/110834421-5a5e7100-8252-11eb-95db-e9e6290e8c90.png)

Please keep this open for our final task.

## Task 12: Generate token for dashboard login in task 11
In task 12, we will be generating a token for the dashboard login.

1. Back inside your mputty session. Let's create service account and cluster role
```
kubectl create serviceaccount dashboard-admin-sa && kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
```
2. Save token info to a file -> kubectl describe secret $(kubectl get secrets |grep dash |awk {'print $1}') > dash-token.txt
3. Display the token -> cat dash-token.txt
4. Copy the token info and paste it into the browser and press Sign in

![image](https://user-images.githubusercontent.com/29349049/110834633-a01b3980-8252-11eb-8eef-92972955ba52.png)

5. You have now successfuly finished deploying the dashboard

![image](https://user-images.githubusercontent.com/29349049/110834822-e375a800-8252-11eb-81fc-f1339ea88406.png)

6. We can now check in our code, but let's first check -> cd ~/project/go-web-hello-world/ && git status
7. Add all for posting to repo -> git add --all
8. Write a message for commit -> git commit -m "deployed dashboard UI and documented steps and saved token"
9. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
    2. Type in password and press enter

## Great Job Everyone! Hope you enjoyed this demo.

