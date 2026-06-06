#!/bin/bash

max_length=40
info=$(playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null)

if [ -z "$info" ]; then
  echo "<span font='11'>󰝛</span> Nothing playing"
else
  if [ ${#info} -gt $max_length ]; then
    echo "<span font='13'>󰝚</span> ${info:0:$max_length}..."
  else
    echo "<span font='13'>󰝚</span> $info"
  fi
fi
