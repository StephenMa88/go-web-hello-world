# go-web-hello-world

# Demo Project


## Task 0 Install a ubuntu 16.04 server 64-bit
For this Demo, I installed latest virtualbox and used an installed ubuntu provided by osboxes.org

1. Install latest Virtualbox on your machine
	My Environment: Windows 10
    Specs for my VM were:
	- 2 vCPUs
	- 6 GB Memory
	- 20GB disk space
2. Download the programs below:
   1. virtual box - https://www.virtualbox.org/wiki/Downloads
   2. mputty for ssh (portable) - https://ttyplus.com/downloads/
   3. VDI image of Ubuntu - https://sourceforge.net/projects/osboxes/files/v/vb/55-U-u/16.04/16.04.6/1604.664.7z/download
3. Extract with 7zip
3. Open Virtualbox Manager
4. Give it a name - "ubuntu-k8-demo"
5. For machine folder select where you want this VM to be saved
6. The type will automatically switch to Linux
7. The version will automatically siwthc to Ubuntu, Press Next
8. For memory I gave it 6144 MB, 6GB total, Press Next
9. Select "Use an existing virtual hard disk file" and Press the folder with green arrow button
10. Press Add and Browse for the extracted vdi image from osboxes.
11. Select the VDI and press Open
12. select the VDI and press Choose
13. Press Create
14. After the VM finishes building, select the VM and press on Settings
15. Go into Systems > Processor > change to 2 if you have it, otherwise leave it as 1
16. Press Ok
17. Press the Start button to power on the VM
18. Password for the user osboxes is osboxes.org
19. after logging in, click on the first top icon on the left side bar
20. type in terminal and press enter to open up the CLI
21. type in ifconfig to find the IP of the enp0s3, for me it was 10.0.2.15
22. Now we go back to the virtualbox manager and open up the settings for the VM again.
23. Now we will be exposing some ports so we can see the results of the demo
24. Click on Network > Adapter 1.
25. Keep it as Attached to NAT and click on Advanced and then Port Forwarding.
26. Click on the green plus on the right side six times and fill out the rows as display below.

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
29. Click on the computer icon under the word Server and fill out the data as shared in table below.

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

You can keep this session of mputty up for the next task


## Task 1: Update Systems
In Task 1, we will be updating Ubuntu's Kernel to the latest for version 16. If your system has extra space for extra disk. You can also apply a backup to your system before upgrading. Please follow instructions from https://www.thegeekdiary.com/how-to-backup-linux-os-using-dd-command/

1. Check current version -> uname -r
   1. output -> 4.15.0-136-generic
2. Update repository information -> sudo apt-get update
   1. for all future instances of using sudo, it might prompt for password, please type in the users password. for osboxes it is osboxes.org
3. To upgrade the kernel -> sudo apt-get install linux-image-generic-hwe-16.04
   1. Press Y to accept
   2. output -> linux-image-generic-hwe-16.04 is already the newest version (4.15.0.136.132)
   3. If you needed to update, please reboot after -> sudo reboot

At the time of this write up, we are on the latest. So we can move on to next task.


## Task 2: Install gitlab-ce version in the host
In Task 2, we will be installing gitlab-ce.

1. Update repository information -> sudo apt update
2. Install these applications -> sudo apt install -y ca-certificates curl openssh-server git
3. Add the gitlab CE repo for installing gitlab CE -> curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
4. Install gitlab CE -> sudo apt -y install gitlab-ce
5. Configure and start gitlab -> sudo gitlab-ctl reconfigure
6. Check the gitlab status -> sudo gitlab-ctl status
7. Configure the /etc/hosts -> sudo sed -i 's/localhost/localhost\ gitlab.example.com/g' /etc/hosts && cat /etc/hosts
8. Configure the namesaver -> sudo sed -i 's/127.0.1.1/8.8.8.8/g' /etc/resolv.conf && cat /etc/resolv.conf
10. Using Browser of your choice type in 127.0.0.1:8080 and press Enter
11. You will be prompted to type in a password, I used friend123 for this demo
12. Afterwards, you can login using user root and password friend123

Please keep this browser open for the next section


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
10. check box to initialize a README file.
11. Click on Create Project
12. scroll down and click on the blue button Copy HTTP clone URL
13. Now going back to mputty
14. create a directory -> mkdir ~/project
15. move into the directory -> cd ~/project
16. configure git with user -> git config --global user.name root
17. configure git with email -> git config --global user.email root@example.com
18. clone the new repo created ->  git clone http://gitlab.example.com/demo/go-web-hello-world.git
19. Download package to install golang -> wget https://golang.org/dl/go1.16.linux-amd64.tar.gz
20. Cleanup any old golang and extract golang -> sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.linux-amd64.tar.gz
21. Check golang -> go version
   1. output -> go version go1.16 linux/amd64
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
3. check the output using command line -> curl 127.0.0.1:8081
    1. Output -> Go Web Hello World!


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
7. add current user to docker group -> sudo usermod -aG docker osboxes
8. relog to have the group activated
9. check that you can run docker command line -> docker image ls
   1. output -> REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

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
10. Run docker image -> docker run -p 8085:8085 -tid sma88/go-web-hello-world:v0.1
11. Check your container -> docker ps
12. Test the docker webapp -> curl http://127.0.0.1:8085
    1. Output -> Go Web Hello World!
13. We can now check in our code, but let's first check -> cd ~/project/go-web-hello-world/ && git status
14. Add all for posting to repo -> git add --all
15. Write a message for commit -> git commit -m "Finished docker image of golang"
16. Push the code to the REPO -> git push origin master
    1. Type in user and press enter
	2. Type in password and press enter	
Great! Now we also have the webapp deploying through docker.

## Taks 7: : Push image to dockerhub
In task 7, we will be uploading our docker image to docker hub.
Please have a docker account created and with repository named go-web-hello-world

1. Login to Docker -> docker login
    1. Type in user and press Enter
	2. Type in password and press Enter
2. Push docker image to remote repo -> docker push <user>/<tag of image>:version
   1. my example: docker push sma88/go-web-hello-world:v0.1

 You can clear up the environment using the commands below.
for x in $(sudo docker ps |grep sma |awk '{ print $1 }'); do sudo docker rm -f $x; done
for x in $(sudo docker image ls |grep sma |awk '{print $3}'); do sudo docker rmi -f $x; done

Good job!

