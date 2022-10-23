title:: CKAD/Create a Linux User with non-interactive shell
public:: true

- non-interactive shell
- TODO create a user named `jim` with a non-interactive shell on the `App Server 1`
	- ssh command to App Server 1
		- ```bash
		  ssh tony@172.16.238.10
		  Ir0nM@n
		  ```
	- Failed
	  collapsed:: true
		- create user
			- ```bash
			  sudo useradd jim
			  ```
		- List users
			- users list at `/etc/passwd`
			- ```bash
			  # display only user name 
			  # one way
			  $ awk -F: '{ print $1}' /etc/passwd
			  
			  # second way
			  $ cut -d: -f1 /etc/passwd
			  
			  ```
	- Answer: `non-interactive shell`
		- > ((62fa5e54-ea23-41ec-be30-f7a178a77f3d))
		- Therefore, create a user named `james` with a non-interactive shell on the `App Server 2`
			- ```bash
			  ssh steve@172.16.238.11
			  Am3ric@
			  ```
		- check user
		  id:: 63058ffd-03eb-406c-a753-d8f58528240a
			- ```bash
			  id james
			  ```
		- create a user with a non-interactive shell
			- ```
			  sudo adduser jim  -s /sbin/nologin
			  ```
		- grep user information
			- ```bash
			  [steve@stapp02 ~]$ cat /etc/passwd | grep james
			  james:x:1002:1002::/home/james:/sbin/nologin
			  ```
		- Delete user if you did it wrong
		  collapsed:: true
			- ```bash
			  sudo userdel -r username.
			  ```