title:: CKAD/Application Security
public:: true

- date:: [[Sep 19th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Application Security
	  background-color:: #49767b
		- We have a backup management application UI hosted on `Nautilus's` backup server in `Stratos DC`. That backup management application code is deployed under Apache on the backup server itself, and Nginx is running as a reverse proxy on the same server. Apache and Nginx ports are `6400` and `8093`, respectively. We have iptables firewall installed on this server. Make the appropriate changes to fulfill the requirements mentioned below:
			- We want to open all incoming connections to Nginx's port and block all incoming connections to Apache's port. Also make sure rules are permanent.
		- #### SSH to the server
			- stbkp01
		- #### Steps
			- Open a port in IPtables
				- ```
				  iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
				  
				  
				  service iptables save
				  
				  ```
			- Close a port in IPtables
				- ```
				  iptables -I INPUT -p tcp -m tcp --dport 6400 -j REJECT
				  service iptables save
				  
				  ```
				-
		- #### Verify result
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related