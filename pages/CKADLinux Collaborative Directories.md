title:: CKAD/Linux Collaborative Directories
public:: true

- date:: [[Sep 5th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Group Permission
	  background-color:: #49767b
		- The Nautilus team doesn't want its data to be accessed by any of the other groups/teams due to security reasons and want their data to be strictly accessed by the `sysops` group of the team.
		- Setup a collaborative directory `/devops/data` on `Nautilus App 3` server in `Stratos Datacenter`.
		- The directory should be group owned by the group `devops` and the group should own the files inside the directory. The directory should be `read/write/execute` to the group owners, and `others` should not have any access.
		- #### SSH to the server
			- stapp02
		- #### Steps
			- Set permission with group
			  collapsed:: true
				- create folder
					- ```bash
					  mkdir -p /devops/data
					  ```
				- set group
					- ```bash
					  chgrp -R devops /devops/data
					  ```
				- Set owner
					- special bits
						- In the former case the `setuid`, `setgid`, and `sticky` bits are represented respectively by a value of 4, 2 and 1.
					- ```bash
					  chmod -R 2770 /devops/data
					  ```
			- ❌ Setup `sysops/data` with group `sysops` as owner
			  collapsed:: true
				- create directory
					- ```bash
					  [root@stapp02 ~]# mkdir -p /sysops/data
					  ```
				- get group id
					- ```bash
					  [root@stapp02 /]# getent group sysops
					  sysops:x:1002:ammar
					  ```
				- change group
					- ```bash
					  chgrp sysops --recursive /sysops
					  # or
					  chown :sysops -=recursive /sysops
					  ```
				- `read/write/execute` owner
					- check the `chmod` [owner mode](https://ss64.com/bash/chmod.html) to get the number
					- ```bash
					  chmod 070 -R /sysops
					  ```
		- #### Verify result
			- And then you can use **getfacl** to see who can write or read the file or directory!
				- ```bash
				  getfacl /devops/data
				  ```
			- or `ll -lsd <dir>`
				- ```bash
				  ll -lsd <dir>
				  ```
				- ```bash
				  # result
				  4 drwxrws--- 2 root devops 4096 Sep  5 08:37 /devops/data/
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related