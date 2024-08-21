#!/bin/sh

last_run_file="/config/last_run"
probe_dir="/.miniooni"
seconds_between_tests=${seconds_between_tests:-21600}

log() {
  echo "[docker/miniooni]: $1"
}

while true; do
  if [ -f "$last_run_file" ]; then
    prev_time=$(cat $last_run_file)
    curr_time=$(date +%s)
    diff_time=$((curr_time - prev_time))

    log "Last run was $diff_time seconds ago."

    if [ $diff_time -lt $seconds_between_tests ]; then
      if [ "$sleep" = "true" ]; then
        sleep_time=$((seconds_between_tests - diff_time))
        
        log "Sleeping for $sleep_time seconds before next run..."
        sleep $sleep_time
      else
        log "Sleep is disabled. Exiting."
        exit 0
      fi
    fi
  fi

  for i in $(seq 1 99); do
    var_name="command$i"
    command=$(eval echo \$$var_name)

    if [ -n "$command" ]; then
      log "Running \"miniooni $command\"..."

      $probe_dir/miniooni $command
      exit_status=$?
      log "\"miniooni $command\" exited with status $exit_status"

      if [ $fail_fast == "true" && $exit_status -ne 0 ]; then
        log "Fail-fast is enabled. Breaking out of loop..."
        break;
      fi
    fi
  done

  date +%s > $last_run_file

  if [ "$sleep" = "true" ]; then
    log "Finished. Sleeping for $seconds_between_tests seconds before next run..."
    sleep $seconds_between_tests
  else
    log "Finished. Sleep is disabled. Exiting."
    exit 0
  fi
done
