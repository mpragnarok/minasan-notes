title:: CKAD/Linux String Substitute (sed)
public:: true

- date:: [[Sep 18th, 2022]]
  type:: #task-note
  name:: Linux String Substitute (sed)
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### sed
	  background-color:: #49767b
		- There is some data on `Nautilus App Server 3` in `Stratos DC`. Data needs to be altered in several of the files. On `Nautilus App Server 3`, alter the `/home/BSD.txt` file as per details given below:
			- a. Delete all lines containing word `software` and save results in `/home/BSD_DELETE.txt` file. (Please be aware of case sensitivity)
			- b. Replace all occurrence of word `the` to `is` and save results in `/home/BSD_REPLACE.txt` file.
			- `Note:` Let's say you are asked to replace word `to` with `from`. In that case, make sure not to alter any words containing this string; for example up`to`, contribu`to`r etc.
		- #### SSH to the server
			- stapp03
		- #### Steps
			- delete all lines
			  collapsed:: true
				- <word1>: match the word
				- -d: delete pattern matching line
				- ```
				  sed '/\<code\>/d' /home/BSD.txt > /home/BSD_DELETE.txt
				  ```
			- replace all occurrences
				- ```
				  sed 's/\band\b/for/g' /home/BSD.txt > /home/BSD_REPLACE.txt
				  ```
				- `\b`: The match must occur on a boundary between a \w (alphanumeric) and a \W (nonalphanumeric) character.
					- pattern: `\b\w+\s\w+\b`
					- Matches: ``"them theme"`, `"them them"` in `"them theme them them"``
			- failed: I didn't delete all lines
				- sed : delete **all lines** case insensitive and save to new file
					- `sed -e /software/Id /home/BSD.txt > /home/BSD_DELETE.txt`
					- -e  ：直接在指令列模式上進行 sed 的動作編輯；
					- ```
					  sed -e "/pattern/Id" filepath > newfilepath
					  ```
				- sed : repace and save to new file
					- `sed -e 's/the/is/g' /home/BSD.txt > /home/BSD_REPLACE.txt`
		- #### Verify result
			-
			-
- ## 為誰為何而做?
- ## 如何量化成果？
	- 30 分鐘內完成
	-
- ## 有何阻礙限制？
- ## Related