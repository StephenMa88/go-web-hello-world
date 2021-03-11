# Troubleshooting

Problem: can't install using apt-get, because service is in use.
Solution: auto update is in progress. Go into system settings > Software & Updates > Updates > Set automatic Updates to Never. And then reboot VM

Problem: Git push not working for local Git
Error Message: XML error: not well-formed (invalid token)
Solution: add URL to the /etc/hosts file

Problem: can't ssh to the VM
Solution: Install ssh -> sudo apt install -y openssh-server

Problem: coredns status is crashloopbackoff
Solution: check logs
		- kubectl logs --namespace kube-system coredns-74ff55c5b-4d6mx
		- For my problem it was a loop
			§ [FATAL] plugin/loop: Loop (127.0.0.1:50822 -> :53) detected for zone ".", see https://coredns.io/plugins/loop#troubleshooting. Query: "HINFO 5927242106289494621.2950133814834156899."
		- changed nameserver from 127.0.1.1 to 8.8.8.8 entry in /etc/resolv.conf fixed it.

Problem: Can't push docker image to remote repo
Solution: 1) make sure your user has group "docker" added for the user.
a) sudo usermod -aG docker ${USER}
      2) Make sure you login to docker and tag your image
           a) https://stackoverflow.com/questions/36663742/docker-unauthorized-authentication-required-upon-push-with-successful-login/42300879#42300879

Problem: after reboot can't get pod info.
Solution: need to turn off swap, sudo swapoff -a

Problem: after deploying dashboard disk usage shoots to 100% and memory maxing out
Solution: increase VM memory to 6GB
