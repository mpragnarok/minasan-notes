title:: CKAD/Linux User Files
public:: true

- There was some users data copied on `Nautilus App Server 2` at `/home/usersdata` location by the `Nautilus` production support team in `Stratos DC`. Later they found that they mistakenly mixed up different user data there. Now they want to filter out some user data and copy it to another location. Find the details below:
- On `App Server 2` find all files (not directories) owned by user `kareem` inside `/home/usersdata` directory and copy them all `while keeping the folder structure` (preserve the directories path) to `/media` directory.
- ssh to server
	- ```
	  ssh steve@172.16.238.11
	  password: Am3ric@
	  ```
- copy the files which owned by  user `kareem`
	- `find . -user <username>`
- find and copy which preserve the folder structure
	- Syntax: `find <Path> <Conditions> | xargs cp --parents -t <copy file path>`
	- ```
	  find . -user kareem | xargs sudo cp --parents -t /media
	  ```
- remove all files here
	- `sudo rm -rf *`
	-
-