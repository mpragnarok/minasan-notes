title:: CKAD/DNS Troubleshooting
public:: true

- date:: [[Sep 3rd, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Add additional DNS nameservers
	  background-color:: #49767b
		- The system admins team of xFusionCorp Industries has noticed intermittent issues with DNS resolution in several apps . `App Server 3` in `Stratos Datacenter` is having some DNS resolution issues, so we want to add some additional DNS nameservers on this server.
		- As a temporary fix we have decided to go with **Google public DNS (ipv4).** Please make appropriate changes on this server.
		- #### SSH to the server
			- stapp03
		- #### Steps
			- Search Google public DNS ipv4
				- ```
				  8.8.8.8
				  8.8.4.4
				  ```
			- Add additional DNS nameservers
				- in Debiean
				  collapsed:: true
					- Edit `/etc/resolv.conf`:
						- ```bash
						  sudo vi /etc/resolv.conf
						  ```
					- Replace or add following lines:
						- IPv4
							- ```bash
							  nameserver 8.8.8.8
							  nameserver 8.8.4.4
							  ```
				- In CentOS
					- Add lines
						- DONE network configuration + resolv.conf
						  collapsed:: true
							- network configuration: Edit `/etc/sysconfig/network-scripts/`
							  collapsed:: true
								- ```bash
								  vi /etc/sysconfig/network-scripts/ifcfg-***
								  ```
								- ```
								  # /etc/sysconfig/network-scripts/ifcfg-***
								  
								  PEERDNS=no  (then add DNS to /etc/resolv.conf)
								  
								  ```
							- `/etc/resolv.conf`
								- ```
								  $ sudo vi /etc/resolv.conf
								  ```
								- ```
								  nameserver 8.8.8.8
								  nameserver 8.8.4.4
								  ```
						- ❌ OR network configuration only: failed
						  collapsed:: true
							- ```bash
							  sudo vi /etc/sysconfig/network-scripts/ifcfg-***
							  ```
							- ```
							  # /etc/sysconfig/network-scripts/ifcfg-eth0
							  ...
							  DNS1=8.8.8.8
							  DNS2=8.8.4.4
							  ```
				- Test new settings
					- [http://ipv4.google.com](http://ipv4.google.com)
		- #### Verify result
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related