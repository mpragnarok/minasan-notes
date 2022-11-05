title:: CKAD/Selinux Installation
public:: true

- date:: [[Sep 13th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Install required packages of SElinux and disabled it
	  background-color:: #49767b
	  id:: fe12e6d2-5107-4c7a-8a33-bdbfbbe1ae56
		- The xFusionCorp Industries security team recently did a security audit of their infrastructure and came up with ideas to improve the application and server security. They decided to use SElinux for an additional security layer. They are still planning how they will implement it; however, they have decided to start testing with app servers, so based on the recommendations they have the following requirements:
			- ==Install the required packages of SElinux on `App server 3` in `Stratos Datacenter` and disable it permanently for now;== it will be enabled after making some required configuration changes on this host. Don't worry about rebooting the server as there is already a reboot scheduled for tonight's maintenance window. Also ignore the status of SElinux command line right now; the final status after reboot should be `disabled`.
		- #### Security-Enhanced Linux (SELinux)
		  collapsed:: true
			- Security-Enhanced Linux is a Linux kernel security module that provides a mechanism for supporting access control security policies, including mandatory access controls.
		- #### SSH to the server
			- stapp03
		- #### Steps
			- [reference](https://www.linode.com/docs/guides/a-beginners-guide-to-selinux-on-centos-7/)
			- update system
				- ```
				  sudo yum update
				  ```
				-
			- Verify which SELinux packages are installed on your system
				- ```
				   sudo rpm -aq | grep selinux
				  ```
				- A newly deployed CentOS 7 Linode should have the following packages installed:
					- ```
					  libselinux-2.5-14.1.el7.x86_64
					  selinux-policy-3.13.1-252.el7_7.6.noarch
					  selinux-policy-targeted-3.13.1-252.el7_7.6.noarch
					  libselinux-utils-2.5-14.1.el7.x86_64
					  libselinux-python-2.5-14.1.el7.x86_64
					  ```
			- Install the following packages and their associated dependencies
				- ```
				  sudo yum install policycoreutils policycoreutils-python setools setools-console setroubleshoot
				  ```
				- `policycoreuitls` and `policyoreutils-python` contain several management tools to administer your SELinux environment and policies.
				- `setools` provides command line tools for working with SELinux policies. Some of these tools include, `sediff` which you can use to view differences between policies, `seinfo` a tool to view information about the components that make up SELinux policies, and `sesearch` used to search through your SELinux policies. `setools-console` consists of `sediff`, `seinfo`, and `sesearch`. You can issue the `--help` option after any of the listed tools in order to view more information about each one.
				- `setroubleshoot` suite of tools help you determine why a script or file may be blocked by SELinux.
			- Get selinux config
				- ```
				  sudo yum provides /etc/selinux/config
				  
				  
				  
				  Loaded plugins: fastestmirror, ovl
				  Loading mirror speeds from cached hostfile
				   * base: mirrors.usinternet.com
				   * extras: mirrors.lug.mtu.edu
				   * updates: mirror.vacares.com
				  selinux-policy-3.13.1-268.el7.noarch : SELinux policy configuration
				  Repo        : base
				  Matched from:
				  Filename    : /etc/selinux/config
				  
				  
				  
				  selinux-policy-3.13.1-268.el7_9.2.noarch : SELinux policy configuration
				  Repo        : updates
				  Matched from:
				  Filename    : /etc/selinux/config
				  
				  
				  
				  ```
					- which package does the file belong to and whether the package has been installed, and here it list `selinux-policy`
				- so we need to install `selinux-polic`
					- ```
					  sudo yum install selinux-policy
					  ```
				-
			- Disable SELinux
				- ```
				  sudo setenforce 0
				  ```
				- To disable SELinux, update your SELinux configuration file using the text editor of your choice. Set the `SELINUX` directive to `disabled` as shown in the example.
				- >    File: /etc/selinux/config
				- ```
				  
				  # This file controls the state of SELinux on the system.
				  # SELINUX= can take one of these three values:
				  #     enforcing - SELinux security policy is enforced.
				  #     permissive - SELinux prints warnings instead of enforcing.
				  #     disabled - No SELinux policy is loaded.
				  SELINUX=disabled
				  # SELINUXTYPE= can take one of three values:
				  #     targeted - Targeted processes are protected,
				  #     minimum - Modification of targeted policy. Only selected processes are protected.
				  #     mls - Multi Level Security protection.
				  SELINUXTYPE=targeted
				        
				  ```
		- #### Verify result
			- `sestatus` or `getenforce`
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((fe12e6d2-5107-4c7a-8a33-bdbfbbe1ae56))
	-
- ## 有何阻礙限制？
- ## Related