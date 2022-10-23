title:: CKAD/Linux file permissions
public:: true

-
- ssh to App server 3
	- ```bash
	  ssh banner@172.16.238.12
	  
	  password: BigGr33n
	  ```
- TODO make `/tmp/xfusioncorp.sh` executable on one the app server by any user
	- check the chmod permission number with this [site](https://ss64.com/bash/chmod.html)
	- ```bash
	  sudo chmod +755 xfusioncorp.sh 
	  ```