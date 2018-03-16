# LimeSurvey Installation Script

This is an experimental script, do not use it.

## How to use it?

Before I convert this script to be suitable for root user only, you have to do `sudo` **before** the script in order to run the script. This is because the "_script_" as it is now, is just a series of command you would normally type in the terminal.

```
sudo pwd
```

```
CUSER="$USER" \
DBUSER='root' \
DBPASSWORD='<password_for_mysql_db>' \
NEWUSER='<mysql_db_user_for_limesurvey>' \
NEWPASSWORD='<mysql_pass_for_new_user>' \
SNAME=<domain_name> \
SALIAS=<domain_alias> \
SADMIN=<server_admin> ./lime.sh
```
