title:: CKAD/Linux Banner-MOTD
public:: true

- date:: [[Aug 28th, 2022]]
  type:: #task-note
  name:: CKAD/Linux Banner-MOTD
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Update linux banner which shows after login- message of the day
	  background-color:: #49767b
	  id:: 75ee952d-54e2-463d-a39d-029eaff4239c
		- #### Resources
			- [architecture](https://lucid.app/lucidchart/58e22de2-c446-4b49-ae0f-db79a3318e97/view?page=0_0#)
			- [wiki](https://kodekloudhub.github.io/kodekloud-engineer/docs/projects/nautilus)
			  id:: 630b37ae-dc47-432f-bc74-6d684b35d5f2
		- During the monthly compliance meeting, it was pointed out that several servers in the `Stratos DC` do not have a valid banner. The security team has provided serveral approved templates which should be applied to the servers to maintain compliance. **These will be displayed to the user upon a successful login.**
		- Update the `message of the day` on all application and db servers for `Nautilus`. Make use of the approved template located at `/home/thor/nautilus_banner` on jump host
		- #### SSH to the server for `Nautilus`
			- DONE all application
				- DONE stapp01
				  :LOGBOOK:
				  CLOCK: [2022-08-28 Sun 17:56:50]--[2022-08-28 Sun 18:12:45] =>  00:15:55
				  :END:
				- stapp02
				- stapp03
			- DONE db server-stdb01
		- #### Steps
			- update linux banner with the template
			- copy the template located at  `/home/thor/nautilus_banner` on jump host
				- ```
				  ################################################################################################
				    .__   __.      ___      __    __  .___________. __   __       __    __       _______.        # 
				         |  \ |  |     /   \    |  |  |  | |           ||  | |  |     |  |  |  |     /       |   #
				         |   \|  |    /  ^  \   |  |  |  | `---|  |----`|  | |  |     |  |  |  |    |   (----`   #
				         |  . `  |   /  /_\  \  |  |  |  |     |  |     |  | |  |     |  |  |  |     \   \       #
				         |  |\   |  /  _____  \ |  `--'  |     |  |     |  | |  `----.|  `--'  | .----)   |      #
				         |__| \__| /__/     \__\ \______/      |__|     |__| |_______| \______/  |_______/       #
				                                                                                                 #
				                                                                                                 #
				                                                                                                 # 
				                                                                                                 #
				                                   # #  ( )                                                      #
				                                    ___#_#___|__                                                 #
				                                _  |____________|  _                                             #
				                         _=====| | |            | | |==== _                                      #
				                   =====| |.---------------------------. | |====                                 #
				     <--------------------'   .  .  .  .  .  .  .  .   '--------------/                          #
				       \                                                             /                           #
				        \_______________________________________________WWS_________/                            #
				    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                        #
				  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                       # 
				     wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww                         #
				                                                                                                 #
				                                                                                                 #
				  ################################################################################################
				  Warning! All Nautilus systems are monitored and audited. Logoff immediately if you are not authorized!
				  ```
			- Update **MOTD** (**Message Of The Day**) Banner
				- The MOTD is displayed right after you log in as illustrated below.
				- set banner
					- ```bash
					  $ sudo vi /etc/motd
					  ```
					- Press `i` for edit mode and `Ctrl +  v` to paste the whole message
				- restart SSH service
					- ```bash
					  $ sudo systemctl restart sshd
					  ```
		- #### Verify result
			- ssh to the servers
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((75ee952d-54e2-463d-a39d-029eaff4239c))
	-
- ## 有何阻礙限制？
- ## Related