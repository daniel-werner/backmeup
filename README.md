# Back Me Up
Collection of scripts for creating file and database backups on linux servers.

## Create a dropbox user
```
sudo adduser --disabled-password dropbox
```

## Install Dropbox

```
sudo su dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
```

### Add dropbox daemon to crontab to start automatically

```
crontab -e
```

```
@reboot ~/.dropbox-dist/dropboxd
```

### Add the backup script to run every day at 1:00 AM
```
0 1 * * * sh /home/dropbox/backmeup/bin/backup.sh -i /var/www/vhosts -o /home/dropbox/Dropbox/backup -u backup -p secret
```
