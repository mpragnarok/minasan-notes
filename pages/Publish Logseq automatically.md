date:: [[Oct 22nd, 2022]]
type:: #task-note
name:: Publish Logseq automatically
tags::
related::

- ## TODOs
  collapsed:: true
	- {{query (and (todo todo doing later) (page [[publish logseq automatically]]))}}
	-
- ## ❓ Why am I doing this?
	- > Logseq is hard to share the pages, and I'm too lazy to copy-paste all the public notes to the graph all the time. Therefore, I spent an afternoon setting all this up 🥰
- ## Automate publish your local graph on the GitHub page with ((6354a051-5b5e-4a33-906f-e1cfb63221fa)) and command lines in OSX
  background-color:: green
	- ### Prerequisites
		- Create a new Logseq graph name `logseq-public` for publishing which locate next to your original Logseq graph
			- ```
			  .
			  ├── logseq-public # new Logseq graph for publishing
			  └── vaults # your original Logseq graph
			  ```
			- `All pages public when publishing` should be open in `logseq-public` graph
			- ![Logseq settings](../assets/Screen_Shot_2022-10-23_at_2.31.55_PM_1666506923711_0.png)
		- [Create GitHub repository](https://docs.github.com/en/get-started/quickstart/create-a-repo) for `logseq-public` graph with public visibility
			- Checkout ((6354f645-311f-4ccd-89dd-0f0b779d88c5))
		- Makefile: All the commands we need
			- ```
			  .
			  ├── logseq-public # new Logseq graph for publishing
			  └── vaults # Download Makefile here
			  ```
			- Download `Makefile` with curl below in your original Logseq graph directory
			  collapsed:: true
				- ```bash
				  curl https://raw.githubusercontent.com/mpragnarok/learning/main/common/Makefile/logseq-publish/Makefile -o Makefile
				  ```
	- ### Get shells with `make get-shells`
	  collapsed:: true
		- `logseq-publish.sh`
			- Run the commands which from Makefile
			- `clean-and-export-assets`
				- Remove all the files exported last time
				- Export all the assets referenced in public notes
			- `clean-and-grep-public`
				- Remove all the pages exported by `logseq-export`
				- Grep the files which have `public:: true` property and tar into `logseq-public/pages` directory
			- `find-and-remove-private-content`
				- Find all the files under `logseq/pages`
				- Remove all the contents which wrap with `- #+BEGIN_PRIVATE` and `-  #+END_PRIVATE`
		- `sync.sh`
			- auto-commit the files
	- ### Get GitHub workflow with `make get-workflow` for publish and deploy
	- ### [logseq-export](https://github.com/viktomas/logseq-export): For exporting assets
	  id:: 6354a051-5b5e-4a33-906f-e1cfb63221fa
		- Install: `make install-logseq-export`
		- The reason that I'm not using this package to export all public pages
			- ### The markdown files that I tried to export with `logseq-export` will result in the title of the page has additional double quotes`""`.
	- ### Publish Logseq graph with one line command
		- Run `pwd` to get the `SOURCE_VAULT` and `TARGET_VAULT` paths and fill in `Makefile` variables
			- ```
			  SOURCE_VAULT = /Users/minahuang/Documents/vaults
			  TARGET_VAULT = /Users/minahuang/Documents/logseq-public
			  ```
		- ```
		  make publish
		  ```
	- ### Reference
		- [My public Logseq notes](https://github.com/mpragnarok/minasan-notes)
		  id:: 6354f645-311f-4ccd-89dd-0f0b779d88c5