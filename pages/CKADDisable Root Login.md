title:: CKAD/Disable Root Login
public:: true

- date:: [[Sep 8th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Disable Root Login
	  background-color:: #49767b
	  id:: 318a450e-ed9b-41a2-9f85-a8bafc551cd3
		- #+BEGIN_IMPORTANT
		  default in Linux is `no`
		  #+END_IMPORTANT
		- After doing some security audits of servers, `xFusionCorp Industries` security team has implemented some new security policies. One of them is to disable direct root login through SSH.
		- Disable direct SSH root login on all app servers in `Stratos Datacenter`.
		- #### SSH to the server
			- stapp01~03
		- #### Steps
			- edit `/etc/ssh/sshd_config`
				- ```
				  PermitRootLogin no
				  ```
			- restart sshd
				- ```bash
				  systemctl restart sshd
				  ```
		- #### Verify result
			- ssh to any one of stapp, but I don't know the passwd of root
				- modify root password
				  collapsed:: true
					- ```bash
					  sudo passwd root
					  ```
				- login with root
					- ```bash
					  ssh root@stapp01
					  > enter your new password
					  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((318a450e-ed9b-41a2-9f85-a8bafc551cd3))
	-
- ## 有何阻礙限制？
- ## Related