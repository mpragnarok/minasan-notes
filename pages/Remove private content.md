public:: true

- DONE Implement to match the tags with indentation
  :LOGBOOK:
  CLOCK: [2022-10-24 Mon 09:58:52]--[2022-10-31 Mon 22:44:06] =>  180:45:14
  :END:
	- DONE Remove the hyphen indentation when matches the pattern
		- ```makefile
		  
		  find-and-remove-private-content:
		  	LC_ALL=C find ./test -type f | xargs -I@ sed -i '' '/^[ \t]*- #+BEGIN_PRIVATE/,/^[ \t]*- #+END_PRIVATE/d' @
		  ```
		- Input
			- ```md
			  - #+BEGIN_PRIVATE
			    - aaa
			    - bbb
			  - #+END_PRIVATE
			  - 1111
			  - 2222
			    - 333
			    - 444
			      - 555
			    - #+BEGIN_PRIVATE
			      - ccc
			    - #+END_PRIVATE
			      - #+BEGIN_PRIVATE
			        - ddd
			        - eee
			      - #+END_PRIVATE
			  - a666
			    - 777
			  
			  ```
		- Output
			- ```md
			  - 1111
			  - 2222
			    - 333
			    - 444
			      - 555
			  - a666
			    - 777
			  
			  ```
		- [Match Tag with indentation](regexr.com/70okj)
	- DONE Delete the content in between `- #+BEGIN_PRIVATE` and `- #+END_PRIVATE`
- Remove the single block
	- ```md
	  - #+BEGIN_PRIVATE
	  - the blocks to remove
	  - #+END_PRIVATE
	  ```
- Remove all the content wrapped inside
	- ```
	  - #+BEGIN_PRIVATE
	    - the nested blocks to remove  
	    - aaa  
	    	- bbb  
	    	- ccc  
	    		- ![IMG_7495_1663490493216_0.PNG](../assets/IMG_7495_1663490493216_0_1666492811683_0.PNG){:width 300, :height 300}  
	  - #+END_PRIVATE
	  ```