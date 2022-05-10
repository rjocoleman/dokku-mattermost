# Mattermost Dokku

This repo provides a `Dockerfile` alternative to the `docker-compose.yml` in https://github.com/mattermost/docker

It runs `mattermost-enterprise-edition`. This is for use on a Dokku host with Dokerfile deployment, using Dokku for SSL termination and Dokku Postgres for data store.

It includes an alternative `ENTRYPOINT` file to automatically map ENV variables names from Dokku to Mattermost's desired naming/format. This is run through the `.env` file for easier maintenance - any ENV set via Dokku will take precedence.


### Preparing Dokku

To prepare Dokku.

1. Clone this repo, and work in it:

```shell
git clone https://github.com/rjocoleman/dokku-mattermost && cd dokku-mattermost
```

2. An app must be created and domain linked then set as ENV.

```shell
# app
dokku apps:create mattermost
dokku domains:set mattermost mattermost.yourdomain.com
dokku config:set mattermost DOMAIN=mattermost.yourdomain.com
```

3. Postgres must be installed and a database created and linked:

```shell
# database
dokku postgres:create mattermost
dokku postgres:link mattermost mattermost
```

4. Persistent storage must be created and added to the app:

```shell
# storage (on dokku server)
dokku storage:ensure-directory mattermost --chown false
sudo mkdir -p /var/lib/dokku/data/storage/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
sudo chown -R 2000:2000 /var/lib/dokku/data/storage/mattermost
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/config:/mattermost/config
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/data:/mattermost/data
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/logs:/mattermost/logs
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/plugins:/mattermost/plugins
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/client/plugins:/mattermost/client/plugins
dokku storage:mount mattermost /var/lib/dokku/data/storage/mattermost/bleve-indexes:/mattermost/bleve-indexes
```

5. The app must be deployed from this repo.

```shell
git remote add dokku dokku@dokkuinstance.com:mattermost
git push dokku main
```

6. Map the port.

```shell
# port
dokku proxy:ports-set mattermost http:80:8065
```
