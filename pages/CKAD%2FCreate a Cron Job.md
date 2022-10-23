title:: CKAD/Create a Cron Job
public:: true

- date:: [[Sep 11th, 2022]]
  type:: #task-note
  name::
  tags::
- ## TODOs
- ## 下一步行動
	- {{embed ((0d87cbaf-0e4a-4cde-8a74-d2e1b549caa1))}}
	- ### Create a Cron job
	  background-color:: #49767b
	  id:: 1cfe2da9-3c76-43d9-8a34-440807ae52ef
		- The `Nautilus` system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in `Stratos DC` on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:
		- #### SSH to the server
			- stapp01~03
		- #### Steps
			- a. Install `cronie` package on all `Nautilus` app servers and start `crond` service.
				- Install `cronie`
					- ```bash
					  yum install cronie
					  ```
				- Start `crond` service
					- ```bash
					  systemctl start crond
					  ```
				- check the `crond` service
					- ```bash
					  systemctl status crond
					  ```
			- b. Add a cron `*/5 * * * * echo hello > /tmp/cron_text` for `root` user.
				- Edit cron jobs with `root` user account
					- ```bash
					  sudo su -
					  ```
					- ```bash
					  crontab -e
					  ```
				- restart service
					- ```bash
					  systemctl restart crond
					  ```
		- #### Verify result
			- `cat /tmp/cron_text` after 5 min
- ## 為誰為何而做?
- ## 如何量化成果？
	- ((1cfe2da9-3c76-43d9-8a34-440807ae52ef))
	-
- ## 有何阻礙限制？
- ## Related