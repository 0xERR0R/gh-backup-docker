#!/bin/bash

if [ -z "$GH_ACCESS_TOKEN" ]; then
	echo "GH_ACCESS_TOKEN is not set!"
	exit 1;
fi

if [ -z "$GH_USER" ]; then
	echo "GH_USER is not set!"
	exit 1;
fi

TARGET_DIR=/tmp/gh-backup
rm -rf $TARGET_DIR
mkdir -p $TARGET_DIR

DEFAULT_BACKUP_ENTITIES="--starred --watched --followers --following --issues --labels  --milestones --repositories --wikis --gists --starred-gists --private --releases "

GH_BACKUP_ENTITIES="${GH_BACKUP_ENTITIES:-$DEFAULT_BACKUP_ENTITIES}"

echo "starting backup for user: $GH_USER"

github-backup --token $GH_ACCESS_TOKEN \
	      --output-directory /tmp/gh-backup \
	      $GH_BACKUP_ENTITIES \
	      $GH_USER
	      
if [ $? -eq 0 ]
then
  echo "Backup: OK"
else
  echo "ERROR: Backup failed!"
  exit 1
fi

cd /tmp/gh-backup && zip -r /out/gh-backup_$(date +"%Y%m%d_%H%M%S").zip ./*
if [ $? -eq 0 ]
then
  echo "Backup archive: OK"
else
  echo "ERROR: Creation of backup archive failed!"
  exit 1
fi
