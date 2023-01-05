title:: CKAD/Linux SSH Authentication
public:: true

- date:: [[Aug 30th, 2022]]
  type:: #task-note
  name:: CKAD/Linux SSH Authentication
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Set up a password-less authentication as sudo users
	  background-color:: #49767b
	  id:: 28059091-ebca-420f-b990-43b9e098c17c
		- The system admins team of `xFusionCorp Industries` has set up some scripts on `jump host` that run on regular intervals and perform operations on all app servers in `Stratos Datacenter`. To make these scripts work properly we need to make sure the `thor` user on jump host has password-less SSH access to all app servers through their respective sudo users (i.e `tony` for app server 1). Based on the requirements, perform the following:
		- Set up a password-less authentication from user `thor` on jump host to all app servers through their respective sudo users.
		- #### Steps for ((28059091-ebca-420f-b990-43b9e098c17c)) #card
		  card-last-interval:: 4
		  card-repeats:: 1
		  card-ease-factor:: 2.6
		  card-next-schedule:: 2022-10-24T23:27:47.051Z
		  card-last-reviewed:: 2022-10-20T23:27:47.052Z
		  card-last-score:: 5
			- Create SSH key pair
				- ```bash
				  ssh-keygen -t rsa -b 4096 -C "your_email@domain.com"
				  ```
			- Verify you've created key successfully
				- ```bash
				  ls -al ~/.ssh/id_*.pub
				  ```
			- Upload the key to remote server
				- DONE `ssh-copy-id` to upload public key
					- ```bash
					  ssh-copy-id tony@stapp01
					  Ir0nM@n
					  
					  ssh-copy-id steve@stapp02
					  Am3ric@
					  
					  ssh-copy-id banner@stapp03
					  BigGr33n
					  ```
		- #### Verify result
			- DONE ssh to the server password-less
			  :LOGBOOK:
			  CLOCK: [2022-08-30 Tue 10:24:31]--[2022-08-30 Tue 10:24:31] =>  00:00:00
			  :END:
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((28059091-ebca-420f-b990-43b9e098c17c))
	-
- ## 有何阻礙限制？
- ## Related