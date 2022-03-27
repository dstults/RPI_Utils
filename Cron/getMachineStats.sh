#!/bin/bash
# logs computer stats to sql database

# Configuration:
# 1) Replace user with actual user
sqluser="statlogger"
# 2) Replace password with actual password
sqlpassword="password123"

# Main Script:

# 1) Get Stats
cpu_temp=$(</sys/class/thermal/thermal_zone0/temp)
cpu_temp=$(echo "scale=1; $cpu_temp / 1000" | bc -l)
#echo "CPU Temp: $cpu_temp deg C"
gpu_temp=$(vcgencmd measure_temp | sed 's/[^0-9.]//g')
#echo "GPU Temp: $gpu_temp deg C"
cpu_use=$(iostat -c 1 2 | grep '\.' | tr -s ' ' | sed -n '3 p' | cut -d' ' -f7)
cpu_use=$(echo "scale=1; (100 - $cpu_use) * 10 / 10" | bc -l)
#echo "CPU Use: $cpu_use %"
ram_use=$(free | sed -n '2 p' | tr -s ' ' | cut -d' ' -f3)
ram_total=$(free | sed -n '2 p' | tr -s ' ' | cut -d' ' -f2)
ram_use=$(echo "scale=1; 100 * $ram_use / $ram_total" | bc -l)
#echo "Ram Use: $ram_use %"
disk_use=$(df --output=target,source,fstype,used,size,pcent -x tmpfs -x devtmpfs | grep /dev | sed -n '1 p' | tr -s ' ' | cut -d' ' -f4)
disk_total=$(df --output=target,source,fstype,used,size,pcent -x tmpfs -x devtmpfs | grep /dev | sed -n '1 p' | tr -s ' ' | cut -d' ' -f5)
disk_use=$(echo "scale=1; 100 * $disk_use / $disk_total" | bc -l)
#echo "Disk Use: $disk_use %"

# 2) Log to database
mysql -u $sqluser -p$sqlpassword -e "INSERT INTO sysmon.stats (date_time, cpu_temp, gpu_temp, cpu_use, ram_use, disk_use) VALUE (NOW(), $cpu_temp, $gpu_temp, $cpu_use, $ram_use, $disk_use);"
