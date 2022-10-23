---
public: true
title: "CKAD/Linux Remote Copy"
---

One of the `Nautilus` developers has copied confidential data on the jump host in `Stratos DC`. That data must be copied to one of the app servers. Because developers do not have access to app servers, they asked the system admins team to accomplish the task for them.

- > Copy `/tmp/nautilus.txt.gpg` file from jump server to `App Server 2` at location `/home/web`.
	- `scp` copy though ssh
		- ```
			  scp <source> <destination>
			  ```
		- To copy a file from `B` to `A` while logged into `B`:
			- ```
				  scp /path/to/file username@a:/path/to/destination
				  ```
		- To copy a file from `B` to `A` while logged into `A`:
			- ```
				  scp username@b:/path/to/file /path/to/destination
				  ```
	- copy file from jump server  to App server 2
		- ```
			  scp /tmp/nautilus.txt.gpg steve@172.16.238.11:/home/web
			  
			  Am3ric@
			  ```
	- ssh and check the file is copied successfully
		- ```
			  ssh steve@172.16.238.11
			  Am3ric@
			  ```