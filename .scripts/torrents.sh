#!/bin/bash
clear
echo "Currently Downloading"
for (( ; ; )); do
  clear
  transmission-remote -l
  sleep 2
done
