title:: CKAD/Configure Local Yum repos
public:: true

- date:: [[Sep 29th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Configure Local Yum repos
	  background-color:: #49767b
		- The `Nautilus` production support team and security team had a meeting last month in which they decided to use local yum repositories for maintaing packages needed for their servers. For now they have decided to configure a local yum repo on `Nautilus Backup Server`. This is one of the pending items from last month, so please configure a local yum repository on `Nautilus Backup Server` as per details given below.
			- a. We have some packages already present at location `/packages/downloaded_rpms/` on `Nautilus Backup Server`.
			- b. Create a yum repo named `localyum` and make sure to set `Repository ID` to `localyum`. Configure it to use package's location `/packages/downloaded_rpms/`.
			- c. Install package `samba` from this newly created repo.
		- #### SSH to the server
			- stbkp01
		- #### Steps
			- list yum repo
			  id:: ca2b7ed4-b0fc-4afb-b8a6-1df3527c6f5f
				- `repolist: 0` means no repo, we should create a new repo
				- ```
				  [root@stbkp01 ~]# yum repolist
				  Loaded plugins: fastestmirror, ovl
				  Determining fastest mirrors
				  repolist: 0
				  ```
			- create local repo
				- ```
				  [root@stbkp01 ~]# vi /etc/yum.repos.d/yum_local.repo
				  [root@stbkp01 ~]# cat /etc/yum.repos.d/yum_local.repo
				  
				  [yum_local]
				  
				  name=yum_local
				  
				  baseurl=file:///packages/downloaded_rpms/
				  
				  enabled = 1
				  
				  gpgcheck = 0
				  ```
			- ((ca2b7ed4-b0fc-4afb-b8a6-1df3527c6f5f))
			- `yum install wget`
		- #### Verify result
			- `yum list wget`
				- validate task
		- #### Fail Steps
		  collapsed:: true
			- follow tutorials,  not sure which one is correct, firstly I'll follow first one
				- https://phoenixnap.com/kb/create-local-yum-repository-centos
				- https://www.cyberithub.com/how-to-setup-local-yum-repository-on-centos/
			- Access to a user account with **root** or **sudo** privileges
				- `sudo su -`
			- configure local yum repository
			  collapsed:: true
				- Configure network access
					- Configure with HTTP server, install Apache web services
						- check is installed
						- ````
						  `sudo yum install httpd`
						  ````
					- If you want FTP server, install [vsftpd](https://phoenixnap.com/kb/install-ftp-server-on-ubuntu-vsftpd)
						- we're going to use HTTP server, follow the FTP steps [here](https://phoenixnap.com/kb/create-local-yum-repository-centos)
						- ```
						  sudo yum install vsftpd
						  ```
				- Create local repository
					- Install package
						- ```
						  sudo yum install createrepo
						  ```
					- Install toolbox for managing repositories
						- ```
						  sudo yum install yum-utils
						  
						  
						  ```
				- Synchronize HTTP repositories(optional)
					- > Download a local copy of the official **CentOS repositories** to your server. This allows systems on the same network to install updates more efficiently.
					- ```
					  sudo reposync -g -l -d -m --repoid=localyum --newest-only --download-metadata --download_path=/packages/downloaded_rpms/
					  
					  ```
					- options
						- **–g** – lets you [remove or uninstall packages on CentOS](https://phoenixnap.com/kb/centos-uninstall-remove-package) that fail a GPG check
						- **–l** – yum plugin support
						- **–d** – lets you delete local packages that no longer exist in the repository
						- **–m** – lets you download comps.xml files, useful for bundling groups of packages by function
						- **––repoid** – specify repository ID
						- **––newest-only** – only download the latest package version, helps manage the size of the repository
						- **––download-metadata** – download non-default metadata
						- **––download-path** – specifies the location to save the packages
				- Create a new repository
					- ```
					  sudo createrepo /var/www/html
					  ```
				- repository name `localyum`
				- `Repository ID` to `localyum`
				- use package's location `/packages/downloaded_rpms/`
				- Install package `vim-enhanced`
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related