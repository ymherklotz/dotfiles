#!/usr/bin/env bash

mail=${HOME}/.mail/imperial/Inbox/new

inotifywait -m ${mail} | while read line; do
  if [[ $line =~ .*MOVED_TO ]] || [[ $line =~ .*CREATE ]]; then
    filename=$(echo "$line" | sed -E 's/[[:space:]]+((MOVED_TO)|(CREATE))[[:space:]]+//')
    subject=$(grep '^Subject:' $filename | sed -E 's/^Subject:[[:space:]]+//')
    from=$(grep '^From:' $filename | sed -E 's/^From:[[:space:]]+//')
    dunstify -i mail-unread "$from
$subject" "" &
  fi
done
