title:: CKAD/MariaDB Troubleshooting
public:: true

- There is a critical issue going on with the `Nautilus` application in `Stratos DC`. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server.
- Look into the issue and fix the same.
- stdb01
	- ```
	  ssh peter@172.16.239.10
	  Sp!dy
	  ```
- mariadb service
	- Correct: [reference](https://www.nbtechsupport.co.in/2021/01/mariadb-troubleshooting-kodekloud.html?showComment=1619604587017)
	  collapsed:: true
		- checkout [MariaDB doc](https://mariadb.com/kb/en/systemd/)
		- Switch to root
			- ```bash
			  sudo su -
			  ```
		- start mariaDB
			- ```bash
			  systemctl start mariadb.service
			  
			  ```
		- \Check the status
			- ```bash
			  systemctl status mariadb.service -l
			  ```
			- ```
			  [peter@stdb01 ~]$ systemctl status mariadb.service -l
			  
			  ```
			- Error
				- ```bash
				  Aug 21 09:49:41 stdb01.stratos.xfusioncorp.com mariadb-prepare-db-dir[485]: Database MariaDB is not initialized, but the directory /var/lib/mysql is not empty, so initialization cannot be done.
				  ```
		- rename the `/var/lib/mysqld`
			- ```bash
			  [root@stdb01 ~]# ll /var/lib/
			  total 52
			  drwxr-xr-x 1 root  root  4096 Mar 27  2021 alternatives
			  drwxr-xr-x 1 root  root  4096 Mar 14  2019 dbus
			  drwxr-xr-x 1 root  root  4096 Apr 11  2018 games
			  drwxr-xr-x 1 root  root  4096 Nov  2  2018 initramfs
			  drwx------ 1 root  root  4096 Aug  1  2019 machines
			  drwxr-xr-x 1 root  root  4096 Apr 11  2018 misc
			  drwxr-xr-x 2 mysql mysql 4096 Oct  1  2020 mysqld
			  drwxr-xr-x 1 root  root  4096 Aug 21 09:47 rpm
			  drwxr-xr-x 1 root  root  4096 Apr 11  2018 rpm-state
			  drwxr-xr-x 1 root  root  4096 Oct 15  2019 stateless
			  drwxr-xr-x 1 root  root  4096 Aug  1  2019 systemd
			  drwxr-xr-x 1 root  root  4096 Mar 27  2021 yum
			  [root@stdb01 ~]# mv /var/lib/mysqld /var/lib/mysql
			  ```
		- restart and check the status
			- ```bash
			  [root@stdb01 ~]# systemctl start mariadb && systemctl status mariadb
			  ● mariadb.service - MariaDB database server
			     Loaded: loaded (/usr/lib/systemd/system/mariadb.service; disabled; vendor preset: disabled)
			     Active: active (running) since Sun 2022-08-21 09:53:48 UTC; 4ms ago
			    Process: 631 ExecStartPost=/usr/libexec/mariadb-wait-ready $MAINPID (code=exited, status=0/SUCCESS)
			    Process: 549 ExecStartPre=/usr/libexec/mariadb-prepare-db-dir %n (code=exited, status=0/SUCCESS)
			   Main PID: 630 (mysqld_safe)
			     CGroup: /docker/6c6bb1d7f425783b2ed581729e9a803ec04206228901c8cf94f4572027a24d90/system.slice/mariadb.service
			             ├─630 /bin/sh /usr/bin/mysqld_safe --basedir=/usr
			             └─794 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64...
			  
			  Aug 21 09:53:46 stdb01.stratos.xfusioncorp.com systemd[630]: Executing: /usr/bin/mysqld_safe --bas...sr
			  Aug 21 09:53:46 stdb01.stratos.xfusioncorp.com systemd[631]: Executing: /usr/libexec/mariadb-wait-...30
			  Aug 21 09:53:46 stdb01.stratos.xfusioncorp.com mysqld_safe[630]: 220821 09:53:46 mysqld_safe Loggin....
			  Aug 21 09:53:46 stdb01.stratos.xfusioncorp.com mysqld_safe[630]: 220821 09:53:46 mysqld_safe Starti...l
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: Child 631 belongs to mariadb.service
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service: control process exited...=0
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service got final SIGCHLD for s...st
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: mariadb.service changed start-post -> r...ng
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: Job mariadb.service/start finished, res...ne
			  Aug 21 09:53:48 stdb01.stratos.xfusioncorp.com systemd[1]: Started MariaDB database server.
			  Hint: Some lines were ellipsized, use -l to show in full.
			  ```
		- (Optional ) Start at boot
			- ```bash
			  sudo systemctl enable mariadb.service
			  ```
		-
	- WRONG
		- list services
		  collapsed:: true
			- ```bash
			  # systemctl list-units --type=service
			  OR
			  # systemctl --type=service
			  ```
		- shown that
		  collapsed:: true
			- ```
			  ...
			  ● network.service                        loaded failed failed  LSB: Bring up/down networking
			  ● systemd-sysctl.service                 loaded failed failed  Apply Kernel Variables
			  ...
			  ```
		- look into network service with `systemctl status network.service -l`
		  collapsed:: true
			- ```
			  [peter@stdb01 ~]$ systemctl status network.service -l
			  ● network.service - LSB: Bring up/down networking
			     Loaded: loaded (/etc/rc.d/init.d/network; bad; vendor preset: disabled)
			     Active: failed (Result: exit-code) since Sun 2022-08-21 07:50:03 UTC; 8min ago
			       Docs: man:systemd-sysv-generator(8)
			    Process: 419 ExecStart=/etc/rc.d/init.d/network start (code=exited, status=6)
			  
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[419]: Executing: /etc/rc.d/init.d/network start
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: Child 419 belongs to network.service
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: network.service: control process exited, code=exited status=6
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: network.service got final SIGCHLD for state start
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: network.service changed start -> failed
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: Job network.service/start finished, result=failed
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: Failed to start LSB: Bring up/down networking.
			  Aug 21 07:50:03 stdb01.stratos.xfusioncorp.com systemd[1]: Unit network.service entered failed state.
			  ```
		- create empty network config
		  collapsed:: true
			- ```bash
			  sudo touch /etc/sysconfig/network
			  ```
		- restart network service
		  collapsed:: true
			- ```bash
			  [peter@stdb01 sysconfig]$ sudo systemctl restart network.service
			  ```