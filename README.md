# Telegram Bot with GCP

## Setup local

.env  

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
![file structure](README_picture/gae_file_structure.PNG)  

## Use bot

When user join your bot  
![join bot](README_picture/join_bot.PNG)  

You will see new user insert you firestore  
![firestore join user](README_picture/firestore_join_user.PNG)  

After user leave your bot  
![leave bot](README_picture/leave_bot.PNG)  

You will see user remove from you firestore  
![firestore leave user](README_picture/firestore_leave_user.PNG)  
