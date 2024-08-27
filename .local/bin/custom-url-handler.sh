#!/bin/bash 
 
url="$1" 
 
regex="^https://teams\.microsoft\.com/.*" 
 
if [[ $url =~ $regex ]]; then 
   /opt/teams-for-linux/teams-for-linux "$url" 
else 
   /usr/bin/google-chrome "$url"
fi
