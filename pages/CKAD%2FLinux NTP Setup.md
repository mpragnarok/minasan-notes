title:: CKAD/Linux NTP Setup
public:: true

- date:: [[Sep 10th, 2022]]
  type:: #task-note
  name:: CKAD/Linux NTP Setup
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### NTP setup
	  background-color:: #49767b
	  id:: a9faf87c-dc1d-40ff-82fe-6b3f87d1dc17
		- The system admin team of `xFusionCorp Industries` has noticed an issue with some servers in `Stratos Datacenter` where some of the servers are not in sync w.r.t time. Because of this, several application functionalities have been impacted. To fix this issue the team has started using common/standard NTP servers. They are finished with most of the servers except `App Server 3`. Therefore, perform the following tasks on this server:
		- 1.  Install and configure NTP server on `App Server 3`.
		  2. 1.  Add NTP server `2.north-america.pool.ntp.org` in NTP configuration on `App Server 3`.
		  3.  Please do not try to start/restart/stop `ntp` service, as we already have a restart for this service scheduled for tonight and we don't want these changes to be applied right now.
		- NTP
			- If you need to keep the system time on your Linux computer accurate, NTP is the solution
		- #### SSH to the server
			- stappxx
		- #### Steps
			- Check NTP is installed
				- ```bash
				  rpm -qa |grep ntp
				  ```
			- Install NTP in CentOS
				- ```bash
				  yum install ntp -y
				  ```
			- NTP config
				- ```bash
				  vi /etc/ntp.conf
				  ```
			- Add NTP server
				- ```
				  server 2.north-america.pool.ntp.org        
				  ```
			- NTP service status
				- ```bash
				  $ stpstat
				  Unable to talk to NTP daemon. Is it running?
				  systemctl status ntpd
				  ```
		- #### Verify result
			- Cause the task is not to start service, I don't have the tool to test of it
			- ❓ The command provides a list of configured peers and their associated synchronization performance characteristics.
			  collapsed:: true
				- ```bash
				  ntpq -p
				  ntpq: read: Connection refused
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((a9faf87c-dc1d-40ff-82fe-6b3f87d1dc17))
	-
- ## 有何阻礙限制？
- ## Related