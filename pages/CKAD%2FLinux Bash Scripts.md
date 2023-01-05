title:: CKAD/Linux Bash Scripts
public:: true

- date:: [[Oct 7th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Linux Bash Scripts
	  background-color:: #49767b
		- The production support team of `xFusionCorp Industries` is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on `App Server 1` in `Stratos Datacenter`, and they need to create a bash script named `beta_backup.sh` which should accomplish the following tasks. (Also remember to place the script under `/scripts` directory on `App Server 1`)
			- a. Create a zip archive 
			   named `xfusioncorp_beta.zip` of `/var/www/html/beta` directory.
			- b. Save the archive in `/backup/` on `App Server 1`. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on `Nautilus Backup Server`.
			- c. Copy the created archive to `Nautilus Backup Server` server in `/backup/` location.
			- d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, `tony` in case of `App Server 1`) must be able to run it.
		- #### SSH to the server
			- stappx1
		- #### Steps
			- Setup login permission without ask password
				- ```
				  # setup login permission without ask password
				  ssh-keygen -t rsa -b 4096 -C "backup"
				  ssh-copy-id clint@stbkp01
				  ```
			- sh
				- ```bash
				  #!/bin/bash
				  # Create a zip archive 
				  zip /backup/xfusioncorp_beta.zip -r /var/www/html/beta
				  
				  # Copy to backup server
				  scp /backup/xfusioncorp_beta.zip  clint@stbkp01:/backup/ 
				  ```
		- #### Verify result
			- ```
			  ssh clint@stbkp01
			  ll /backup
			  total 4
			  -rw-rw-r-- 1 clint clint 588 Oct 16 12:00 xfusioncorp_beta.zip
			  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related