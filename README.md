# Telegram Bot with GCP

## Setup local

.env  

```text
BOT_TOKEN={bot token}
```

.local.env  

```text
GOOGLE_APPLICATION_CREDENTIALS={key path}
```

init  

```shell
$ pipenv install
```

## Set up GCP

### Create firestore

Create native mode firestore, gcp path: `/STORAGE/Firestore/Select native mode`  

### Set up authentication

Create Service account that role is owner, and create json type key about this account  

### Deploy GAE

Create requirements.txt  

```shell
$ pipenv lock -r > requirements.txt
```

Create .env file and move key in the project root directory.  

```shell
$ gcloud components install app-engine-go
$ gcloud init # set your project
$ gcloud app deploy
```

and set webhook of Telegram bot:  
`https://api.telegram.org/bot{bot token}/setWebhook?url={target url}/hook`  

PS:  

* bot token is when you create telegram bot, bot father will give you.
* you will see target url when you execute `gcloud app deploy`.

Check remote GAE file structure:  
![file structure](README_picture/gae_file_structure.png)  

## Use bot

When user join your bot  
![join bot](README_picture/join_bot.PNG)  

You will see new user insert you firestore  
![firestore join user](README_picture/firestore_join_user.PNG)  

After user leave your bot  
![leave bot](README_picture/leave_bot.PNG)  

You will see user remove from you firestore  
![firestore leave user](README_picture/firestore_leave_user.PNG)  


## Hitcon zeroday crawler notification

### Start

Try connect http://127.0.0.1:8080/hitcon_zeroday_crawler  
You will see bot notify zeroday info what last update is yesterday  
![local try hitcon zeroday](README_picture/local_try_hitcon_zeroday.PNG)  

### Set cloud scheduler on GCP

Open GCP web dashboard  
/ TOOLS / Cloud Scheduler / Create Job  

In this example, I set every 2:06 am, it will connect /hitcon_zeroday_crawler of app engine, when connect this, it will trigger crawler and notify zeroday info to all user who join this bot.  
![create cloud scheduler](README_picture/create_cloud_scheduler.png)  
![trigger success](README_picture/trigger_success.png)  
![gcp nitcon zeroday notify](README_picture/gcp_hitcon_zeroday_notify.PNG)  

