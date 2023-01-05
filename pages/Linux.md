public:: true
date:: [[Aug 27th, 2022]]
type:: #task-note
name:: Linux
tags::

- ## TODOs
  collapsed:: true
	- {{query (and (todo todo doing later) (page [[kodekloud-engineer/linux user without home]]))}}
	-
- ## 下一步行動
	- ### basic linux command
	  background-color:: pink
	  id:: 0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1
		- Basic
			- file systems
				- count files
					- ```bash
					  $ ls | wc -l
					  ```
			- Check the command history
				- ```bash
				  $ history
				      1  cd /var/www/html/ecommerce/
				      2  ll
				      3  find . -type f -name "*.js"
				      4  ll /ecommerce
				      5  find . -type f -name "*.js" -exec cp --parents "{}" /ecommerce  \;
				      6  ll /ecommerce
				      7  cd /ecommerce
				      8  history
				      9  find . -type f -name "*.js"
				     10  history
				  ```
				- execute the history command with number
					- ```
					  !3
					  ```
		- ### ssh to app
			- stapp01
				- ```bash
				  ssh tony@stapp01
				  Ir0nM@n
				  ```
			- stapp02
				- ```bash
				  ssh steve@stapp02
				  Am3ric@
				  ```
			- stapp03
				- ```bash
				  ssh banner@stapp03
				  BigGr33n
				  ```
			- stdb01
				- ```bash
				  ssh peter@stdb01
				  Sp!dy
				  ```
			- stbkp01
				- ```bash
				  ssh clint@stbkp01
				  H@wk3y3
				  ```
			- stmail01
				- ```bash
				  ssh groot@stmail01
				  Gr00T123
				  ```
		- ### Switch to root
		  collapsed:: true
			- ```
			  sudo su -
			  ```
		- ### systemctl (centos v7.x~8.x)
			- service(centOS v4.x~6.x)
			- check the service
				- ```
				  # systemctl list-units --type=service
				  OR
				  # systemctl --type=service
				  ```
		- ### OS information
			- get name and version
				- ```bash
				  cat /etc/os-release
				  lsb_release -a
				  hostnamectl
				  ```
			- find linux kernel version
				- ```bash
				  uname -r
				  ```
		- ### user operation
		  collapsed:: true
			- add user
				- ```
				  sudo useradd username
				  ```
				- related
					- [[CKAD/Create a Linux User with non-interactive shell]]
					- [[CKAD/Linux User Expiry]]
					- [[CKAD/Linux User Without Home]]
			- check user
				- ```
				  id username
				  ```
			- grep user information
				- ```
				  cat /etc/passwd | grep username
				  james:x:1002:1002::/home/james:/sbin/nologin
				  ```
			- Delete user if you did it wrong
				- ```
				  sudo userdel -r username.
				  ```
			- verify user account expiration details
				- ```
				  sudo chage -l username
				  ```
			- Permission
				- chmod
					- modifying permission
					- check permission owner/group/other [here](https://ss64.com/bash/chmod.html)
					- Special bits permission
						- `setuid`, `setgid`, and `sticky` bits are represented respectively by a value of 4, 2 and 1.
					- normally we don't use special bit
						- ```bash
						  chmod <permision> <dir>
						  ```
					- With special bits
						- `-R` =  recursive
						- ```bash
						  chmod -R 2xxx <dir>
						  ```
				- chgrp
					- change group of  directory
					- `-R` =  recursive
					- ```bash
					  chgrp -R <group> <directory>
					  ```
				- related
					- [[CKAD/Linux Collaborative Directories]]
		- ### `SCP` copy file or folder
			- local to remote
			  id:: 630b3942-d085-41f1-a3f3-81ca7cb71744
				- ```bash
				  scp /path/file1 myuser@192.168.0.1:/path/file2
				  ```
			- remote to local
				- ```bash
				  scp myuser@192.168.0.1:/path/file2 /path/file1
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))
- ## 有何阻礙限制？