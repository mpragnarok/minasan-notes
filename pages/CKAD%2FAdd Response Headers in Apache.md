title:: CKAD/Add Response Headers in Apache
public:: true

- date:: [[Oct 3rd, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Add Response Headers in Apache
	  background-color:: #49767b
		- We are working on hardening Apache web server on all app servers. As a part of this process we want to add some of the Apache response headers for security purpose. We are testing the settings one by one on all app servers. As per details mentioned below enable these headers for Apache:
		- #### SSH to the server
			- stapp02
		- #### Steps
			- Install `httpd` package on `App Server 1` using yum and configure it to run on `8088` port, make sure to start its service.
				- Install httpd
					- `yum install httpd`
				- configure port
					- `[root@stapp01 ~]# vi /etc/httpd/conf/httpd.conf`
					  id:: 633ae004-b033-46de-9ac8-5be7fda815ac
					- ```
					  Listen 8088
					  ```
				- Start service
					- ```bash
					  [root@stapp01 ~]# systemctl start httpd
					  ```
				- Check service status
					- ```bash
					  [root@stapp01 ~]# systemctl status httpd
					  ● httpd.service - The Apache HTTP Server
					     Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
					     Active: active (running) since Mon 2022-10-03 13:16:43 UTC; 41s ago
					       Docs: man:httpd(8)
					             man:apachectl(8)
					   Main PID: 784 (httpd)
					     Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
					     CGroup: /docker/e7d14fb17878325948478995bd9355f9c192938871c2965048ae7b517c498063/system.slice/httpd.service
					             ├─784 /usr/sbin/httpd -DFOREGROUND
					             ├─785 /usr/sbin/httpd -DFOREGROUND
					             ├─786 /usr/sbin/httpd -DFOREGROUND
					             ├─787 /usr/sbin/httpd -DFOREGROUND
					             ├─788 /usr/sbin/httpd -DFOREGROUND
					             └─789 /usr/sbin/httpd -DFOREGROUND
					  
					  Oct 03 13:17:02 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
					  Oct 03 13:17:02 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current r.../sec
					  Oct 03 13:17:12 stapp01.stratos.xfusioncorp.com systemd[1]: Got notification message for unit httpd.service
					  Oct 03 13:17:12 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 784 (...sec)
					  Oct 03 13:17:12 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
					  Oct 03 13:17:12 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current r.../sec
					  Oct 03 13:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: Got notification message for unit httpd.service
					  Oct 03 13:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 784 (...sec)
					  Oct 03 13:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got READY=1
					  Oct 03 13:17:22 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: got STATUS=Total requests: 0; Current r.../sec
					  Hint: Some lines were ellipsized, use -l to show in full.
					  ```
			- Create an `index.html` file under Apache's default document root i.e `/var/www/html` and add below given content in it.
				- `vi /var/www/html/index.html`
				- `Welcome to the xFusionCorp Industries!`
			- Configure Apache to enable below mentioned headers:
				- ((633ae004-b033-46de-9ac8-5be7fda815ac))
				- ```
				  #
				  # Deny access to the entirety of your server's filesystem. You must
				  # explicitly permit access to web content directories in other
				  # <Directory> blocks below.
				  #
				  <Directory />
				      AllowOverride none
				      Require all denied
				  +   Header set X-XSS-Protection "1; mode=block"
				  +	Header set X-Frame-Options "SAMEORIGIN"
				  +   Header set X-Content-Type-Options "nosniff"
				  </Directory>
				  
				  ```
				- `X-XSS-Protection` header with value `1; mode=block`
				  collapsed:: true
					- ```
					  Header set X-XSS-Protection "1; mode=block"
					  ```
				- `X-Frame-Options` header with value `SAMEORIGIN`
				  id:: 633adf60-c40d-47cf-aa2b-75dcb9908541
					- ```
					  Header set X-Frame-Options "SAMEORIGIN"
					  ```
				- `X-Content-Type-Options` header with value `nosniff`
				  collapsed:: true
					- ```
					  Header set X-Content-Type-Options "nosniff"
					  ```
				- restart service
					- ```bash
					  [root@stapp01 ~]# systemctl restart httpd
					  ```
			- `Note:` You can test using curl on the given app server as LBR URL will not work for this task.
		- #### Verify result
			- ```bash
			  [root@stapp01 ~]# curl localhost:8088 -v
			  About to connect() to localhost port 8088 (#0)
			  *   Trying 127.0.0.1...
			  * Connected to localhost (127.0.0.1) port 8088 (#0)
			  > GET / HTTP/1.1
			  > User-Agent: curl/7.29.0
			  > Host: localhost:8088
			  > Accept: */*
			  > 
			  < HTTP/1.1 200 OK
			  < Date: Mon, 03 Oct 2022 13:49:14 GMT
			  < Server: Apache/2.4.6 (CentOS)
			  < Last-Modified: Mon, 03 Oct 2022 13:48:53 GMT
			  < ETag: "27-5ea219ab204f3"
			  < Accept-Ranges: bytes
			  < Content-Length: 39
			  < X-XSS-Protection: 1; mode=block
			  < X-Frame-Options: SAMEORIGIN
			  < X-Content-Type-Options: nosniff
			  < Content-Type: text/html; charset=UTF-8
			  < 
			  Welcome to the xFusionCorp Industries!
			  * Connection #0 to host localhost left intact
			  ```
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related