title:: CKAD/Linux Find Command
public:: true

- date:: [[Sep 23rd, 2022]]
  type:: #task-note
  name:: Linux Find Command
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Linux find command
	  background-color:: gray
		- During a routine security audit, the team identified an issue on the Nautilus App Server. Some malicious content was identified within the website code. After digging into the issue they found that there might be more infected files. Before doing a cleanup they would like to find all similar files and copy them to a safe location for further investigation. Accomplish the task as per the following requirements:
			- a. On `App Server 3` at location `/var/www/html/ecommerce` find out all files (not directories) having `.js` extension.
			- b. Copy all those files along with their `parent directory structure` to location `/ecommerce` on same server.
			- c. Please make sure not to copy the entire `/var/www/html/ecommerce` directory content.
		- #### SSH to the server
			- stapp03
		- #### Steps
			- find out all files (not directories) having `.js` extension.
				- location `/var/www/html/ecommerce`
				- id:: 632dba7a-5cf9-4129-9260-8563ce82cb54
				  ```bash
				  find . -type f -name "*.js"
				  ```
			- Copy all files with the `parent directory structure`
				- to `/ecommerce`
				- Don't copy entire `/var/www/html/ecommerce` directory
				- find and copy
					- ```bash
					  find . -type f -name "*.js" -exec cp --parents "{}" /ecommerce  \;
					  ```
		- #### Verify result
			- {{embed ((632dba7a-5cf9-4129-9260-8563ce82cb54))}}
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related