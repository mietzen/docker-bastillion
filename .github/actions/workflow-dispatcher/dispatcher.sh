#!/bin/bash
# Triggers a GitHub Action Workflow using the dispatches API, then waits for the Workflow to complete. All values are read from environment variables.

function trigger_workflow {
  echo "Triggering ${INPUT_EVENT_TYPE} in ${INPUT_REPO}"
  resp=$(curl -X POST -s "https://api.github.com/repos/${INPUT_REPO}/dispatches" \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${INPUT_TOKEN}" \
    -d "{\"event_type\": \"${INPUT_EVENT_TYPE}\", \"client_payload\": ${INPUT_CLIENT_PAYLOAD} }")
  # If the response from the GitHub API is null, i.e., HTTP 204, then the request was successful. Wait for 2 seconds and proceed.
  if [ -z "$resp" ]
  then
    sleep 2
  else
    echo "Workflow failed to trigger"
    echo "$resp"
    exit 1
  fi
}

function find_workflow {
  # 10 attempts will be made to find the triggered workflow in the GitHub API response.
  counter=0
  while true
  do
    counter=$(( counter + 1 ))
    # The GitHub API returns an ordered list of triggered workflows by time, newest first. Get the first object from the list.
    workflow=$(curl -s "https://api.github.com/repos/${INPUT_REPO}/actions/workflows/${INPUT_WORKFLOW_FILE_NAME}/runs?event=repository_dispatch" \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: Bearer ${INPUT_TOKEN}" | jq '.workflow_runs[0]')
    # Get the created_at value from the first workflow in the list.
    created_at=$(echo "$workflow" | jq -r '.created_at')
    # Extract only the time from the date time value.
    created_at_time=${created_at:11:9}
    # Check the difference between the current time and the time the workflow was triggered.
    time_diff=$(( $(date +"%s") - $(date -d "$created_at_time" +"%s") ))

    # If the time difference is more than 30 seconds, then this is not the workflow that was just triggered. Wait for 2 seconds and try again.
    if [[ "$time_diff" -gt "30" ]]
    then
      if [[ "$counter" -gt "10" ]]
      then
        echo "Workflow not found"
        exit 1
      else
        sleep 0.5
      fi
    else
      break
    fi
  done

  workflow_id=$(echo "$workflow" | jq '.id')
  conclusion=$(echo "$workflow" | jq '.conclusion')
  html_url=$(echo "$workflow" | jq -r '.html_url')
  last_commit_author=$(echo "$workflow" | jq -r '.head_commit.author.email')
  last_commit_date=$(echo "$workflow" | jq -r '.head_commit.timestamp')

  echo "::set-output name=workflow-id::${workflow_id}"
  echo "Workflow started. Workflow id is ${workflow_id}. Last commit was by ${last_commit_author} on ${last_commit_date::10}."
  echo "Check the status at: ${html_url}"
}

function wait_on_workflow {
  counter=0
  # The value of the conclusion field in the workflow object in the GitHub API response remains null until it succeeds or fails.
  while [[ $conclusion == "null" ]]
  do
    if [[ "$counter" -gt 0 ]]
    then
      echo -ne "${counter} seconds elapsed..\r"
    fi
    if [[ "$counter" -ge "$INPUT_MAX_TIME" ]]
    then
      echo "Time limit exceeded"
      exit 1
    fi
    sleep "$INPUT_WAIT_TIME"
    # Query the API again and keep checking the value of conclusion.
    conclusion=$(curl -s "https://api.github.com/repos/${INPUT_REPO}/actions/runs/${workflow_id}" \
    	-H "Accept: application/vnd.github.v3+json" \
    	-H "Authorization: Bearer ${INPUT_TOKEN}" | jq '.conclusion')
    counter=$(( counter + INPUT_WAIT_TIME ))
  done

  # Set the value of conclusion as an output parameter for subsequent steps to consume.
  echo "::set-output name=conclusion::${conclusion}"
  if [[ $conclusion == "\"success\"" ]]
  then
    echo "Workflow run successful"
  else
    echo "Workflow run failed"
    exit 1
  fi
}

function main {
  # Start by triggering the workflow, then find the ID of the workflow which was just triggered and finally, wait until it completes.
  trigger_workflow
  find_workflow
  wait_on_workflow
}

main
