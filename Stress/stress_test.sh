#!/bin/bash
# Raspberry Pi stress CPU temperature measurement script.
#
# Download this script (e.g. with wget) and give it execute permissions (chmod +x).
# Then run it with ./pi-cpu-stress.sh

# Variables.
test_run=1
test_results_file="/home/${USER}/cpu_temp_$test_run.log"
stress_length="10m"

# Verify stress-ng is installed.
if ! [ -x "$(command -v stress-ng)" ]; then
  printf "Error: stress-ng not installed.\n"
  printf "To install: sudo apt install -y stress-ng\n" >&2
  exit 1
fi

printf "Logging temperature and throttling data to: $test_results_file\n"

# Start logging temperature data in the background.
while /bin/true; do
  # Print the date (e.g. "Wed 13 Nov 18:24:45 GMT 2019") and a tab.
  date | tr '\n' '\t' >> $test_results_file;

  # Print the temperature (e.g. "39.0") and a tab.
  vcgencmd measure_temp | tr -d "temp=" | tr -d "'C" | tr '\n' '\t' >> $test_results_file;

  # Print the throttle status (e.g. "0x0") and a tab.
  vcgencmd get_throttled | tr -d "throttled=" | tr '\n' '\t' >> $test_results_file;

  # Print the current CPU frequency.
  vcgencmd measure_clock arm | sed 's/^.*=//' >> $test_results_file;
  sleep 5;
done &

# Store the logging pid.
PROC_ID=$!

# After 5 minutes, run stress.
printf "Waiting 5 minutes for stable idle temperature...\n"
sleep 300
printf "Beginning $stress_length stress test...\n"
stress-ng -c 4 --timeout $stress_length

# Keep logging for 5 more minutes.
printf "Waiting 5 minutes to return to idle temperature...\n"
sleep 300

# Kill the logging pid.
kill $PROC_ID

printf "Test complete.\n"