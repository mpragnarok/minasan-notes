public:: true
title:: How to find the port and kill it in MacOS?

- id:: 83e55a1f-ff6b-49ab-8944-ea7d4cc596d6
  type:: [[snippets]]
  tags:: MacOS
  date:: [[Apr 18th, 2022]] 
  usage:: List the port and kill the process
	- ```zsh
	  lsof -t -i tcp:1234 | xargs kill
	  ```