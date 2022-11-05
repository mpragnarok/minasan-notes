public:: true

- date:: [[Oct 21st, 2022]]
  type:: #task-note
  name:: Setup SSL for Nginx
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Setup SSL for Nginx
	  background-color:: #49767b
		- [reference](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7)
		- The system admins team of `xFusionCorp Industries` needs to deploy a new application on `App Server 3` in `Stratos Datacenter`. They have some pre-requites to get ready that server for application deployment. Prepare the server as per requirements shared below:
			- Install and configure `nginx` on `App Server 3`.
				- Adding EPEL Software repository
					- ```bash
					  sudo yum -y install epel-release
					  ```
				- Install Nginx
					- ```bash
					  sudo yum -y install nginx
					  ```
				- Start Nginx
					- ```
					  sudo systemctl start nginx
					  sudo systemctl status nginx
					  # enable on boot
					  sudo systemctl enable nginx
					  ```
					- ```
					  Output
					  ● nginx.service - The nginx HTTP and reverse proxy server
					     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
					     Active: active (running) since Mon 2022-01-24 20:14:24 UTC; 5s ago
					    Process: 1898 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
					    Process: 1896 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
					    Process: 1895 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
					   Main PID: 1900 (nginx)
					     CGroup: /system.slice/nginx.service
					             ├─1900 nginx: master process /usr/sbin/nginx
					             └─1901 nginx: worker process
					  
					  Jan 24 20:14:24 centos-updates systemd[1]: Starting The nginx HTTP and reverse proxy server...
					  Jan 24 20:14:24 centos-updates nginx[1896]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
					  Jan 24 20:14:24 centos-updates nginx[1896]: nginx: configuration file /etc/nginx/nginx.conf test is successful
					  Jan 24 20:14:24 centos-updates systemd[1]: Started The nginx HTTP and reverse proxy server.
					  ```
					- The service should be `active`
				- Configure Firewall to Allow Traffic
					- Allow HTTP and HTTPs traccic
						- ```bash
						  firewall-cmd --zone=public --permanent --add-service=http
						  firewall-cmd --zone=public --permanent --add-service=https
						  firewall-cmd --reloadCopied!
						  ```
				- check the page with public IP
					- get the public IP
						- ```bash
						  ip addr
						  #or
						  ip a
						  ```
						- ```bash
						  ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
						  ```
						-
			- On `App Server 3` there is a self signed SSL certificate and key present at location `/tmp/nautilus.crt` and `/tmp/nautilus.key`. Move them to some appropriate location and deploy the same in Nginx.
				- The `/etc/ssl/certs` directory, which can be used to hold the public certificate, should already exist on the server
				- Create a location to store private keys
					- ```
					  sudo mkdir /etc/ssl/private
					  sudo chmod 700 /etc/ssl/private
					  ```
				- Create self-signed key and certificate pair with Open SSL (optional if already created)
				  collapsed:: true
					- ```
					  sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
					  ```
					- ou will be asked a series of questions. Before going over that, let’s take a look at what is happening in the command:
					- **openssl**: This is the basic command line tool for creating and managing OpenSSL certificates, keys, and other files.
					- **req**: This subcommand specifies that you want to use X.509 certificate signing request (CSR) management. The “X.509” is a public key infrastructure standard that SSL and TLS adheres to for its key and certificate management. You want to create a new X.509 cert, so you are using this subcommand.
					- **-x509**: This further modifies the previous subcommand by telling the utility that you want to make a self-signed certificate instead of generating a certificate signing request, as would normally happen.
					- **-nodes**: This tells OpenSSL to skip the option to secure your certificate with a passphrase. You need Nginx to be able to read the file, without user intervention, when the server starts up. A passphrase would prevent this from happening because you would have to enter it after every restart.
					- **-days 365**: This option sets the length of time that the certificate will be considered valid. You set it for one year here.
					- **-newkey rsa:2048**: This specifies that you want to generate a new certificate and a new key at the same time. You did not create the key that is required to sign the certificate in a previous step, so you need to create it along with the certificate. The  `rsa:2048`  portion tells it to make an RSA key that is 2048 bits long.
					- **-keyout**: This line tells OpenSSL where to place the generated private key file that you are creating.
					- **-out**: This tells OpenSSL where to place the certificate that you are creating.
				- As you are using OpenSSL, you should also create a strong Diffie-Hellman group, which is used in negotiating [Perfect Forward Secrecy](https://en.wikipedia.org/wiki/Forward_secrecy) with clients. (❓Not sure if it's optional)
					- ```bash
					  sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
					  ```
					- This may take a few minutes, but when it’s done you will have a strong DH group at  `/etc/ssl/certs/dhparam.pem`  that you can use in your configuration.
				- Configure Nginx to use SSL
					- > Nginx will check for files ending in  `.conf`  in the  `/etc/nginx/conf.d`  directory for additional configuration.
					- Create the TLS/SSL Server Block
						- Create `ssl.conf` under `/etc/nginx/conf.d` directory
							- ```bash
							  sudo vi /etc/nginx/conf.d/ssl.conf
							  ```
						- `/etc/nginx/conf.d/ssl.conf`
						  id:: 6352addd-e260-4dfe-bdaa-2b30b9ffcb0f
							- ```
							  server {
							      listen 443 http2 ssl;
							      listen [::]:443 http2 ssl;
							  
							      server_name your_server_ip;
							  
							      ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
							      ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
							      ssl_dhparam /etc/ssl/certs/dhparam.pem;
							  }
							  
							     ########################################################################
							      # from [Cipherlist.eu - Strong Ciphers for Apache, nginx and Lighttpd](https://cipherlist.eu/)                                            #
							      ########################################################################
							      # disable using TLSv1.3 to avoid curl error
							  #   ssl_protocols TLSv1.3;# Requires nginx >= 1.13.0 else use TLSv1.2
							      ssl_prefer_server_ciphers on;
							      ssl_ciphers EECDH+AESGCM:EDH+AESGCM;
							      ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
							      ssl_session_timeout  10m;
							      ssl_session_cache shared:SSL:10m;
							      ssl_session_tickets off; # Requires nginx >= 1.5.9
							      ssl_stapling on; # Requires nginx >= 1.3.7
							      ssl_stapling_verify on; # Requires nginx => 1.3.7
							      resolver 8.8.8.8 8.8.4.4 valid=300s;
							      resolver_timeout 5s;
							      # Disable preloading HSTS for now.  You can use the commented out header line that includes
							      # the "preload" directive if you understand the implications.
							      #add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
							      add_header X-Frame-Options DENY;
							      add_header X-Content-Type-Options nosniff;
							      add_header X-XSS-Protection "1; mode=block";
							      ##################################
							      # END https://cipherlist.eu/ BLOCK #
							      ##################################
							  ```
			- Create an `index.html` file with content `Welcome!` under Nginx document root.
			- Enable the change in Nginx
				- ```bash
				  sudo nginx -t
				  Output
				  nginx: [warn] "ssl_stapling" ignored, issuer certificate not found
				  nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
				  nginx: configuration file /etc/nginx/nginx.conf test is successful
				  
				  sudo systemctl restart nginx
				  
				  ```
			- For final testing try to access the  `App Server 1`  link (either hostname or IP) from  `jump host`  using curl command. For example  `curl -Ik https://<app-server-ip>/` .
				- `curl -Ik https://172.16.238.10`
					- ```
					  curl: (35) Peer reports incompatible or unsupported protocol version.
					  ```
						- 👉 Disabled `ssl_protocols TLSv1.3;# Requires nginx >= 1.13.0 else use TLSv1.2` in ((6352addd-e260-4dfe-bdaa-2b30b9ffcb0f))
						- Failed install git and run `centminmod` command
							- `yum -y install git -q`
							- ```
							  git clone -b 123.09beta01 --depth=1 [GitHub - centminmod/centminmod: CentOS Shell menu based Nginx LEMP web stack auto installer (GPLv3 licensed)](https://github.com/centminmod/centminmod.git) centminmod
							  ```
							-
		- #### SSH to the server
			- stappxx
		- #### Steps
		- #### Verify result
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related