title:: CKAD/linux timezones setting
public:: true

-
- DONE ssh to `Nautilus Application Servers` in `Stratos Datacenter`  and set the timezone to the local timezone which is `America/Indiana/Winamac`
	- ssh command
		- ```
		  ssh clint@172.16.238.16
		  Bl@kW
		  ```
	- set timezone command
		- check current timezone with `timedatectl`
		- list timezone `timedatectl  list-timezones`
		- set timezone with `sudo timedatectl set-timezone America/Indiana/Winamac`
	- DONE stapp01
	  :LOGBOOK:
	  CLOCK: [2022-08-14 Sun 16:44:15]--[2022-08-14 Sun 16:48:02] =>  00:03:47
	  :END:
	- DONE stapp02
	  :LOGBOOK:
	  CLOCK: [2022-08-14 Sun 16:48:10]--[2022-08-14 Sun 16:49:45] =>  00:01:35
	  :END:
	- DONE stapp03
	  :LOGBOOK:
	  CLOCK: [2022-08-14 Sun 16:49:47]--[2022-08-14 Sun 16:50:42] =>  00:00:55
	  :END:
	- no route to host
		- DONE stdb01
		  :LOGBOOK:
		  CLOCK: [2022-08-14 Sun 16:44:05]--[2022-08-14 Sun 16:44:14] =>  00:00:09
		  CLOCK: [2022-08-14 Sun 16:52:04]--[2022-08-14 Sun 16:53:48] =>  00:01:44
		  :END:
		- DONE ststor01
		- DONE stbkp01
		  :LOGBOOK:
		  CLOCK: [2022-08-14 Sun 16:55:01]--[2022-08-14 Sun 16:55:02] =>  00:00:01
		  :END:
	- DONE work stations? no need
-
-