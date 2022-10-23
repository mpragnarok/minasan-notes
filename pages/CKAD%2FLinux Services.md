title:: CKAD/Linux Services
public:: true

-
- > As per details shared by the development team, the new application release has some dependencies on the back end. There are some packages/services that need to be installed on all app servers under  `Stratos Datacenter` . As per requirements please perform the following steps:
	- a. Install  `httpd`  package on all the application servers.
		- Check os distribution
			- ```bash
			  cat /etc/os-release
			  ```
			- `NAME="CentOS Linux"`
		- ssh to app
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
		- Switch to root
			- ```bash
			  sudo su -
			  ```
		- Install `httpd`, [reference](https://httpd.apache.org/docs/2.4/install.html)
			- ```bash
			  
			  yum install httpd
			  ```
	- b. Once installed, make sure it is enabled to start during boot.
		- ```bash
		  systemctl enable httpd && systemctl start httpd
		  ```
	- check the service is up
		- list services
		  collapsed:: true
			- ```bash
			  # systemctl list-units --type=service
			  OR
			  # systemctl --type=service
			  ```