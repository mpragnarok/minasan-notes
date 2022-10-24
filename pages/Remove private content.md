public:: true

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