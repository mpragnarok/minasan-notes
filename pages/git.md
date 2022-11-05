public:: true
date:: [[Nov 1st, 2022]]
type:: #task-note
name:: git
tags::
related::

## TODOs
collapsed:: true
	- {{query (and (todo todo doing later) (page [[git]]))}}
	-
## Next actions
	- ### upgrade git in macOS with Homebrew
	  background-color:: gray
	  collapsed:: true
		- ```bash
		  
		  brew install git
		  git version
		  brew link --overwrite git
		  # in new termial
		  git version
		  ```
	- ### Auto setup remote config
	  background-color:: yellow
	  collapsed:: true
		- ```bash
		   git config --global push.autoSetupRemote true   
		  ```
	- ### stash
	  background-color:: pink
	  id:: 6364c3a7-76eb-4e11-a250-cccbefd7911d
		- save
			- ```bash
			  git stash save "message optional"
			  ```
		- pop
			- ```bash
			  # pop latest
			  git stash pop
			  # pop stash@{2}
			  git stash pop stash@{2}
			  ```
		- drop, clear
			- ```bash
			  $ git stash drop stash@{1}
			  Dropped stash@{1} (17e2697fd8251df6163117cb3d58c1f62a5e7cdb)
			  $ git stash clear
			  
			  ```
		- list
			- ```bash
			  git stash list
			  ```
		-
	-
## For whom and why?
	- Who need it?
	- Targets
## Measure the result
	- Time
	- Amount
	- Special
## Restrictions and obstacles
	- Preparation
	- Doing
	- Finished