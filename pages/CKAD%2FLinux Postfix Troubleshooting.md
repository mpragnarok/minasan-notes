title:: CKAD/Linux Postfix Troubleshooting
public:: true

- date:: [[Sep 15th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Linux Postfix Troubleshooting
	  background-color:: #49767b
		- Some users of the monitoring app have reported issues with `xFusionCorp Industries` mail server. They have a mail server in `Stork DC` where they are using `postfix` mail transfer agent. `Postfix` service seems to fail. Try to identify the root cause and fix it.
		- #### SSH to the server
			- stmail01
		- #### Steps
			- check postfix service
			  id:: 63225ad0-6c74-4337-b4ea-dfa059213c84
				- ```
				  [root@stmail01 ~]# systemctl status postfix
				  ```
				- `fatal: parameter inet_interfaces: no local interface found for ::1`
					- resulted by IPv6 is closed
			- postfix config
				- ```
				  # vi /etc/postfix/main.cf
				  ```
				- > /etc/postfix/main.cf
					- ```
					  -inet_interfaces = localhost
					  +inet_interfaces = all
					  ```
			- Restart postfix
		- #### Verify result
			- check service
				- ```
				  systemctl status postfix
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	-
	-
- ## 有何阻礙限制？
- ## Related