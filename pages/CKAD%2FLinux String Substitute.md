title:: CKAD/Linux String Substitute
public:: true

- date:: [[Sep 7th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Replace string substitute
	  background-color:: #49767b
		- The backup server in the `Stratos DC` contains several template XML files used by the Nautilus application. However, these template XML files must be populated with valid data before they can be used. One of the daily tasks of a system admin working in the xFusionCorp industries is to apply string and file manipulation commands!
		- Replace all occurrences of the string `About` with `LUSV` on the XML file `/root/nautilus.xml` located in the backup server.
		- #### SSH to the server
			- stbkp01
		- #### Steps
			- ❌ replace string  in **vi** with `:s`
			  collapsed:: true
				- ```vi
				  :[range]s/{pattern}/{string}/[flags] [count]
				  ```
				- Replace `Text` with `Architecture`
					- `g` to search in global
					- f you want to search and replace the pattern in the entire file, use the percentage character `%` as a range.
					- ```vi
					  :%s/Text/Architecture/g
					  ```
					- ```vi
					  :%s/text/architecture/g
					  ```
			- wordcount
				- ```bash
				  cat /root/nautilus.xml  |grep About  | wc -l
				  ```
			- grep
				- ```bash
				  cat /root/nautilus.xml  |grep About
				  ```
			- sed -i
				- `-i`  ：直接修改讀取的檔案內容，而不是由螢幕輸出。
				- ```bash
				  sed -i 's/About/LUSV/g' /root/nautilus.xml
				  ```
		- #### Verify result
			- check result with grep
				- ```bash
				  cat /root/nautilus.xml  |grep LUSV
				  ```
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((badf280f-4ecb-4c5d-ae97-1ecea02dd1a0))
	-
- ## 有何阻礙限制？
- ## Related