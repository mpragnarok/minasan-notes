title:: CKAD/Linux User Without Home
public:: true

- date:: [[Aug 27th, 2022]]
  type:: #task-note
  name:: kodekloud-engineer/Linux User Without Home
  tags::
- ## TODOs
  collapsed:: true
	- {{query (and (todo todo doing later) (page [[kodekloud-engineer/linux user without home]]))}}
	-
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Finish Task target
	  background-color:: #264c9b
		- he system admins team of `xFusionCorp Industries` has set up a new tool on all app servers, as they have a requirement to create a service user account that will be used by that tool. They are finished with all apps except for `App Server 1` in `Stratos Datacenter`.
		- Create a user named `anitjim` in `App Server 2` without a home directory.
			- ssh to the server
				- stapp01
					- ```
					  ssh steve@stapp02
					  Am3ric@
					  ```
			- Create user with **expiry date**
				- ```
				  $useradd --no-create-home <username>
				  $ useradd -M <username>
				  
				  ```
				- `useradd -e 2021-02-17 jim`
			- verify user is created
				- ```
				  id anita
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
- ## 有何阻礙限制？
- ## Related
	- [[CKAD/Linux User Expiry]]
	- [[CKAD/Create a Linux User with non-interactive shell]]
	-