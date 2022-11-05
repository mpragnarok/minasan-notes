title:: CKAD/Linux User Expiry
public:: true

- date:: [[Aug 24th, 2022]]
  type:: #task-note
  name:: kodekloud-engineer/Linux User Expiry
  tags::
- ## TODOs
  collapsed:: true
	- {{query (and (todo todo doing later) (page [[kodekloud-engineer/linux user expiry]]))}}
	-
- ## 下一步行動
	- ### basic linux command
	  background-color:: #787f97
		- ### ssh to app
		  collapsed:: true
			- stapp01
				- ```
				  ssh tony@stapp01
				  Ir0nM@n
				  ```
			- stapp02
			  id:: 68d22818-cc61-4107-9a2a-7cddd0c5bdfd
				- ```
				  ssh steve@stapp02
				  Am3ric@
				  ```
			- stapp03
				- ```
				  ssh banner@stapp03
				  BigGr33n
				  ```
		- ### Switch to root
		  collapsed:: true
			- ```bash
			  sudo su -
			  ```
		- ### check the service
		  collapsed:: true
			- ```bash
			  # systemctl list-units --type=service
			  OR
			  # systemctl --type=service
			  ```
		- ### user operation
		  collapsed:: true
			- add user
				- ```bash
				  sudo useradd username
				  ```
				- related
					- [[CKAD/Create a Linux User with non-interactive shell]]
					- [[CKAD/Linux User Expiry]]
			- check user
				- ```bash
				  id username
				  ```
			- grep user information
				- ```bash
				  cat /etc/passwd | grep username
				  james:x:1002:1002::/home/james:/sbin/nologin
				  ```
			- Delete user if you did it wrong
				- ```bash
				  sudo userdel -r username.
				  ```
			- {{embed ((63062c7c-7881-47f1-b544-902cd773c1b7))}}
	- ### Finish Task target
	  background-color:: #978626
		- A developer jim has been assigned `Nautilus` project temporarily as a backup resource. As a temporary resource for this project, we need a temporary user for jim. It’s a good idea to create a user with a set expiration date so that the user won't be able to access servers beyond that point.
		- Therefore, create a user named `jim` on the `App Server 2`. Set `expiry date` to `2021-02-17` in `Stratos Datacenter`. Make sure the user is created as per standard and is in lowercase.
			- ssh to the server
			  collapsed:: true
				- {{embed ((68d22818-cc61-4107-9a2a-7cddd0c5bdfd))}}
			- Create user with **expiry date**
			  id:: 63062a8c-0652-4b47-bc6b-3e387501f5ec
				- ```bash
				  sudo useradd -e YYYY-MM-DD username
				  ```
				- `useradd -e 2021-02-17 jim`
			- verify user account expiration details
			  id:: 63062c7c-7881-47f1-b544-902cd773c1b7
			  collapsed:: true
				- ```bash
				  sudo chage -l username
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((62dc80f5-6f36-43e2-a9f5-e14ef7b7d182))
	- ((62dc8108-1c85-4a6e-b57b-ef03acfe4d9e))
- ## 有何阻礙限制？
- ## Related
	- [[CKAD/Create a Linux User with non-interactive shell]]