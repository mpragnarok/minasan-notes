title:: CKAD/Linux LogRotate
public:: true

- date:: [[Sep 27th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Log rotation
	  background-color:: #49767b
		- The `Nautilus` DevOps team is ready to launch a new application, which they will deploy on app servers in `Stratos Datacenter`. They are expecting significant traffic/usage of `httpd` on app servers after that. This will generate massive logs, creating huge log files. To utilise the storage efficiently, they need to compress the log files and need to rotate old logs. Check the requirements shared below:
			- a. In all app servers install `httpd` package.
			- b. Using `logrotate` configure `httpd` logs rotation to monthly and keep only 3 rotated logs.
			- (If by default log rotation is set, then please update configuration as needed)
		-
		- #### SSH to the server
			- stapp01~03
		- #### Steps
			- Check `logrotate` is installed
				- ```
				  whereis logrotate
				  ```
				- if not, install with yum
					- ```
					  yum update && yum install logrotate
					  ```
			- Install `httpd`
				- ```
				  yum install httpd
				  ```
			- find `httpd.conf` and check where the log rotate files are
				- [[WONT]]Edit `httpd.conf`
				  collapsed:: true
					- ```
					  vi /etc/httpd/conf/httpd.conf
					  
					  ErrorLog "logs/error_log"
					  ```
						- > Configuration and logfile names: If the filenames you specify for many of the server's control files begin with "/" (or "drive:/" for Win32), the server will use that explicit path.  If the filenames do *not* begin with "/", the value of erverRoot is prepended -- so 'log/access_log' with ServerRoot set to '/www' will be interpreted by the server as '/www/log/access_log', where as '/log/access_log' will be interpreted as '/log/access_log'.
						- /var/log/httpd
					- log rotate config
						- ```
						  vi /etc/logrotate.conf  
						  ```
				- Edit log rotate file for httpd apache server
					- ```
					  
					  vi /etc/logrotate.d/httpd
					  ```
					- `logrotate` to configure `httpd` logs
						- monthly
						- 3 rotated logs
						- ```
						  /var/log/httpd/*log {
						      #...default config
						      monthly
						      rotate 3
						  }
						  
						  ```
			- Check the log
			  id:: 63322d9e-ec57-426d-918c-f28abef626f8
				- ```
				  logrotate -d /etc/logrotate.d/httpd
				  ```
		- #### Verify result
			- {{embed ((63322d9e-ec57-426d-918c-f28abef626f8))}}
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related