# Fun with Cron Jobs

Quick demo of adding a cronjob 

## Add Script to local FS

Sample script: 

See [getMachineStats.sh](getMachineStats.sh)

Thanks to: https://raspberrypi.stackexchange.com/questions/90352/schedule-a-cron-job-to-send-temperature-via-e-mail

## Add Item and Ensure No Duplicates

### Do it Manually

```
crontab -e
```

### Do it Programmatically

Thanks to: https://stackoverflow.com/questions/610839/how-can-i-programmatically-create-a-new-cron-job

```
(crontab -l; echo "0 * * * * your_command") | sort - | uniq - | crontab -

# Example:
(crontab -l; echo "0 * * * * bash /var/www/shared/shell/get_machine_stats.sh") | sort - | uniq - | crontab -
```
