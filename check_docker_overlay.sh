#!/bin/bash
# Limit for folder 10 GB
while true
do
    LIMIT="10"

    # Overlay2 folder
    path=/var/lib/docker/overlay2/

    # Check the current size
    CHECK="`/usr/bin/du -sh $path | /usr/bin/cut -f1`"

    # Check if folder size 0 or not
    if [ $CHECK -eq 0 ];then
        echo "Folder size is 0,nothing to do"
        /usr/bin/sleep 3600
        continue
    fi

    echo "Current Foldersize: $CHECK GB"

    # Get last character and remove it
    last_char="`echo "${CHECK:0-1}"`"
    CHECK="`echo ${CHECK:0:-1}`"

    # Check size and if neccesary delete/prune docker system
    if [ $last_char == "M" ] || [ $last_char == "K" ];then
        echo "Its megabyte"
        /usr/bin/sleep 3600
        continue
    elif [ $CHECK -ge $LIMIT ];then
        echo "Start prune docker"
        docker system prune -a --volumes
        /usr/bin/sleep 3600
    else
        echo "Its other error"
        break
    fi
done