public:: true

- #+BEGIN_IMPORTANT
  The function only matches the tags without indentation
  #+END_IMPORTANT
	- DOING Implement to match the tags with indentation
	  :LOGBOOK:
	  CLOCK: [2022-10-24 Mon 09:58:52]
	  :END:
		- TODO Remove the hyphen indentation when matches the pattern
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