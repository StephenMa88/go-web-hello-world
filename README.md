# Demo Project - go-web-hello-world
There are 14 tasks total. Tasks 0-7 will be covered in this README. Tasks 9-12 README are around kubernetes, which can be found inside the k8-golang folder.
You can find sample code for tasks 0-7 in the golang and docker-golang folder.  You might notice that task 8 and 13 isn't listed, those tasks were documentation tasks in the form of README, so you can ignore those. Please do the tasks in order as we will be reusing the files from previous tasks.

Let's begin!

## Task 0 Install a ubuntu 16.04 server 64-bit
For this Demo, I installed latest virtualbox and used an installed ubuntu provided by osboxes.org

1. Install latest Virtualbox on your machine
	My Environment: Windows 10
    Specs for my VM were:
	- 2 vCPUs
	- 6 GB Memory
	- 20GB disk space
2. Download the programs below and install items one and two on your machine:
   1. virtual box - https://www.virtualbox.org/wiki/Downloads
   2. 7zip - https://www.7-zip.org/download.html
   3. mputty for ssh (portable) - https://ttyplus.com/downloads/
   4. VDI image of Ubuntu - https://sourceforge.net/projects/osboxes/files/v/vb/55-U-u/16.04/16.04.6/1604.664.7z/download
3. Use 7zip to extract the ubuntu VDI
3. Open Virtualbox Manager and select New
4. Give it a name - "ubuntu-k8-demo"
5. For machine folder select where you want this VM to be saved
6. The type will automatically switch to Linux
7. The version will automatically switch to Ubuntu, Press Next

![image](https://user-images.githubusercontent.com/29349049/110809673-f8920d00-8239-11eb-8320-1a9c945c70f1.png)

9. For memory I gave it 6144 MB, 6GB total, Press Next
10. Select "Use an existing virtual hard disk file" and Press the folder with green arrow button
11. Press Add and Browse for the extracted vdi image from osboxes.
12. Select the VDI and press Open
13. select the VDI and press Choose
14. Press Create
15. After the VM finishes building, select the VM and press on Settings
16. Go into Systems > Processor > change to 2 if you have it, otherwise leave it as 1
17. Press Ok
18. Press the Start button to power on the VM

![image](https://user-images.githubusercontent.com/29349049/110809782-13648180-823a-11eb-89f2-8486758c4c21.png)

20. Password for the user osboxes is osboxes.org
21. after logging in, click on the first top icon on the left side bar
22. type in terminal and press enter to open up the CLI
23. type in ifconfig to find the IP of the enp0s3, for me it was 10.0.2.15
24. Now we go back to the virtualbox manager and open up the settings for the VM again.
25. Now we will be exposing some ports so we can see the results of the demo
26. Click on Network > Adapter 1.
27. Keep it as Attached to NAT and click on Advanced and then Port Forwarding.
28. Click on the green plus on the right side six times and fill out the rows as display below.

Name | Protocol | Host IP | Host Port | Guest IP | Guest Port
---- | -------- | ------- | --------- | -------- | ----------
SSH | TCP | 127.0.0.1 | 2222 | 10.0.2.15 | 22
gitlab | TCP | 127.0.0.1 | 8080 | 10.0.2.15 | 80
goapp | TCP | 127.0.0.1 | 8081 | 10.0.2.15 | 8081
goappdocker | TCP | 127.0.0.1 | 8085 | 10.0.2.15 | 8085
goappk8 | TCP | 127.0.0.1 | 31080 | 10.0.2.15 | 31080
k8dash| TCP | 127.0.0.1 | 31081 | 10.0.2.15 | 31081

27. Check your rules with the table above. Press Ok Twice to finish network configuration.
28. Now we open mputty portable
29. Click on the computer icon under the word Server and fill out the data as shared in table below

Item | Value
---- | -----
Putty session | Default Settings
Server name | 127.0.0.1
Protocol | 
Port | 2222
Display name | 127.0.0.1
user name | osboxes
password | osboxes.org
30. You can check the box to save password and press Ok.

You can keep this session of mputty up for the next task.


## Task 1: Update Systems
In Task 1, we will be updating Ubuntu's Kernel to the latest for version 16. If your system has extra space for extra disk. You can also apply a backup to your system before upgrading. Please follow instructions from https://www.thegeekdiary.com/how-to-backup-linux-os-using-dd-command/

1. Check current version -> uname -r
   1. Output -> 4.15.0-136-generic
2. Update repository information -> sudo apt-get update
   1. for all future instances of using sudo, it might prompt for password, please type in the users password. for osboxes it is osboxes.org
3. To upgrade the kernel -> sudo apt-get install linux-image-generic-hwe-16.04
   1. Press Y to accept
   2. Output -> linux-image-generic-hwe-16.04 is already the newest version (4.15.0.136.132)
   3. If you needed to update, please reboot after -> sudo reboot

![image](https://user-images.githubusercontent.com/29349049/110809885-25462480-823a-11eb-9c29-8c853defb9e0.png)

At the time of this write up, we are on the latest. So we can move on to next task.


## Task 2: Install gitlab-ce version in the host
In Task 2, we will be installing gitlab-ce.

1. Update repository information -> sudo apt update
2. Install these applications -> sudo apt install -y ca-certificates curl openssh-server git
3. Add the gitlab CE repo for installing gitlab CE -> curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
4. Install gitlab CE -> sudo apt -y install gitlab-ce
5. Configure and start gitlab -> sudo gitlab-ctl reconfigure
6. Check the gitlab status -> sudo gitlab-ctl status

![image](https://user-images.githubusercontent.com/29349049/110809997-3a22b800-823a-11eb-890c-db787022878a.png)

8. Configure the /etc/hosts -> sudo sed -i 's/localhost/localhost\ gitlab.example.com/g' /etc/hosts && cat /etc/hosts
9. Configure the namesaver -> sudo sed -i 's/127.0.1.1/8.8.8.8/g' /etc/resolv.conf && cat /etc/resolv.conf
10. Using Browser of your choice type in 127.0.0.1:8080 and press Enter
11. You will be prompted to type in a password, I used friend123 for this demo
12. Afterwards, you can login using user root and password friend123

Please keep this browser open for the next section.


## Task 3: Create a demo group/project in gitlab
In task 3, we will be creating a group, a new project, and configuring a repo for our demo.

1. In the top banner,
   1. using firefox -> click on More and then Groups
   2. using chrome -> click on Groups and your groups
2. Click on the button New Group
3. Group name is demo
4. Set visibility to public
5. Click Create Group
6. Click on New Project
7. Click on Create blank project
8. Project name is go-web-hello-world
9. Set visibility to Public
10. Check box to initialize a README file.
11. Click on Create Project
12. scroll down and click on the blue button Copy HTTP clone URL
13. Now going back to mputty
14. Create a directory -> mkdir ~/project
15. Move into the directory -> cd ~/project
16. Configure git with user -> git config --global user.name root
17. Configure git with email -> git config --global user.email root@example.com
18. Clone the new repo created ->  git clone http://gitlab.example.com/demo/go-web-hello-world.git
19. Download package to install golang -> wget https://golang.org/dl/go1.16.linux-amd64.tar.gz
20. Cleanup any old golang and extract golang -> sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.linux-amd64.tar.gz
21. Check golang -> go version
   1. Output -> go version go1.16 linux/amd64
   2. if you get "The program 'go' is currently not installed.." it means the link wasn't created.
   3. create softlink -> sudo ln -s /usr/local/go/bin/go /usr/bin/go
22. Move in git working directory -> cd ~/project/go-web-hello-world
23. Create directory for our different projects -> mkdir {golang,docker-golang,k8-golang}
24. Move into golang directory -> cd golang
25. Create go.od file -> go mod init localhost
26. Create golang file -> vi hello-world.go
27. Go into modify mode, Press i
28. Copy and Paste the content below into the the file
```
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Go Web Hello World!\n")
	})

	http.ListenAndServe(":8081", nil)
}
```
29. To save, Press ESC and then type in :wq and then Enter
30. Find the import files needed for our script -> go mod tidy
31. We can now check in our code, but let's first check -> cd .. && git status
32. Add all for posting to repo -> git add --all
33. Write a message for commit -> git commit -m "coded golang webapp"
34. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
	2. Type in password and press enter


## Task 4: Build the app and expose ($ go run) the service to 8081 port
In task 4, we will be building the web app using golang.

1. Build our web app -> cd ~/project/go-web-hello-world/golang && go build hello-world.go
2. Run our webapp -> ./hello-world
3. Check the output using windows cmd -> curl 127.0.0.1:8081
    1. You can also put this URL into your browser -> 127.0.0.1:8081
    2. Output -> Go Web Hello World!

![image](https://user-images.githubusercontent.com/29349049/110835785-1bc9b600-8254-11eb-9f4f-426ea66ee893.png)


4. After you are done verifying, you can go back to the mputty control and input Ctrl+C to close the webapp program.


## Task 5: Install docker
In Task 5, we will be installing docker community edition.

1. Update repository information -> sudo apt update
2. Installing packages -> sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
3. Download the docker public signing key -> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
4. Add the docker apt repository -> echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
5. Update repository information -> sudo apt update
6. Install docker -> sudo apt-get install -y docker-ce docker-ce-cli containerd.io
7. Add current user to docker group -> sudo usermod -aG docker osboxes
8. Relog to have the group activated
9. Check that you can run docker command line -> docker image ls
   1. Output -> REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

Great, we have docker installed and now we can move to the next task.


## Task 6: Run the app in container
In task 6, we will be building docker image and deploying a docker container from our golang webapp

1. Change to docker project directory -> cd ~/project/go-web-hello-world/docker-golang
2. Create Dockerfile -> vi Dockerfile
3. Go into modify mode, Press i
4. Copy and Paste the content below into the the file
```
FROM golang:latest

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
RUN mkdir /build
WORKDIR /build

# copy go files to build dir
COPY go.mod /build/
COPY hello-world.go /build/
 
# Build the application
RUN cd /build && go build hello-world.go 

# Export necessary port
EXPOSE 8085

CMD ["/build/hello-world"]
```
5. To save, Press ESC and then type in :wq and then Enter
6. Copy the golang files to this directory -> cp ../golang/*go* .
7. Modify the file to use a different port -> sed -i 's/":8081"/":8085"/g' hello-world.go && cat hello-world.go
8. Build docker image -> docker build -t sma88/go-web-hello-world:v0.1 .
9. Check your image -> docker image ls

![image](https://user-images.githubusercontent.com/29349049/110836202-a27e9300-8254-11eb-84c1-a8ff95d9333a.png)

11. Run docker image -> docker run -p 8085:8085 -tid sma88/go-web-hello-world:v0.1
12. Check your container -> docker ps

![image](https://user-images.githubusercontent.com/29349049/110836263-b4603600-8254-11eb-84e9-4b20f781758c.png)

14. Test the docker webapp using windows cmd or the browser-> curl 127.0.0.1:8085
    1. Output -> Go Web Hello World!

![image](https://user-images.githubusercontent.com/29349049/110836336-c6da6f80-8254-11eb-9e53-7ffc6492349c.png)

15. We can now check in our code, but let's first check -> cd ~/project/go-web-hello-world/ && git status
16. Add all for posting to repo -> git add --all
17. Write a message for commit -> git commit -m "Finished docker image of golang"
18. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
	2. Type in password and press enter	
Great! Now we also have the webapp deploying through docker.

## Taks 7: : Push image to dockerhub
In task 7, we will be uploading our docker image to docker hub.
Please have a docker account created and with repository named go-web-hello-world

1. Login to Docker -> docker login
    1. Type in user and press Enter
	2. Type in password and press Enter
2. Push docker image to remote repo -> docker push <user>/<tag of image>:<version>
   1. My example: docker push sma88/go-web-hello-world:v0.1

![image](https://user-images.githubusercontent.com/29349049/110835932-49aefa80-8254-11eb-8053-c076cd6f8cd8.png)

You can clean up the environment using the commands below.
```
for x in $(sudo docker ps |grep sma |awk '{ print $1 }'); do sudo docker rm -f $x; done
for x in $(sudo docker image ls |grep sma |awk '{print $3}'); do sudo docker rmi -f $x; done
```

## Good job!

## Helpful Guides
1. https://computingforgeeks.com/how-to-install-gitlab-ce-on-ubuntu-linux/
2. https://docs.docker.com/engine/install/ubuntu/
3. https://levelup.gitconnected.com/complete-guide-to-create-docker-container-for-your-golang-application-80f3fb59a15e
4. https://semaphoreci.com/community/tutorials/how-to-deploy-a-go-web-application-with-docker
5. https://hub.docker.com/repository/docker/sma88/go-web-hello-world
6. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
7. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
8. https://docs.projectcalico.org/getting-started/kubernetes/quickstart
9. https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#create
10. https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard


