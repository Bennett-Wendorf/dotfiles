The backup.service, backup.timer, backup.env, and backup.sh get hard linked to /etc/systemd/system for execution.

In addition, a copy of the backup.env.template must be made called backup.env. The 
API key value should be filled in in the new file.
