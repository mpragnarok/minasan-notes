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