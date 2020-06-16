#!/bin/bash

# Updates the file $1 to contain the latest OSBot jarfile
# If not provided, assumes ~/OSBot/osbot.jar
#  Usage: ./update-osbot.sh [ jarfile=osbot.jar ]

# The default path to the OSBot jar when not provided
OSBOT_JAR_DEFAULT_PATH=~/OSBot/osbot.jar
if test -z "$1"
then
	if ! test -d $(dirname $OSBOT_JAR_DEFAULT_PATH)
	then
		echo "Creating directory: $(dirname $OSBOT_JAR_DEFAULT_PATH)"
		mkdir -p $(dirname $OSBOT_JAR_DEFAULT_PATH)
	fi
	OSBOT_JAR=$OSBOT_JAR_DEFAULT_PATH
else
	OSBOT_JAR="$1"
fi
OSBOT_JAR=$(realpath $OSBOT_JAR)
OSBOT_DIR=$(dirname "$OSBOT_JAR")

# A folder where previous versions of OSBot should go
# Set to empty to disable backups entirely
BACKUP_FOLDER="$OSBOT_DIR/$(basename $OSBOT_JAR)-backups"

# The URL from where the latest OSBot.jar should be downloaded
OSBOT_URL="https://osbot.org/mvc/get"

# Parses the version result from OSBot, echoing the version of $1
# and storing the latest version in $OSBOT_LATEST_VERSION
osbot_version() {
	VERSION_NOW=$(java -jar "$1" -version)

	# Split on ", " gives "Current=..." and "Latest=..."
	IFS=", "
	read -a VERSIONS <<< "$VERSION_NOW"

	# Split on "=" gives "Current" and "2.5.83"
	IFS="="

	# Do for both current and latest
	read -a CURRENT <<< "${VERSIONS[0]}"
	CURRENT="${CURRENT[1]}"
	read -a LATEST <<< "${VERSIONS[1]}"
	LATEST="${LATEST[1]}"

	# Output
	OSBOT_CURRENT_VERSION="${CURRENT[1]}"
	OSBOT_LATEST_VERSION="${LATEST[1]}"
}

# Make a backup of $1 as version $2
osbot_backup() {
	mkdir -p $BACKUP_FOLDER
	BACKUP_FILE="$BACKUP_FOLDER/$2.jar"
	echo "Backing up $1 to $BACKUP_FILE"
	cp "$1" "$BACKUP_FILE"
}

# Download the latest version of OSBot to $1
osbot_download() {
	echo "Downloading from $OSBOT_URL to $1..."
	# Use curl if it exists, or wget
	curl "$OSBOT_URL" --silent --output "$1" || \
	wget "$OSBOT_URL" --quiet --output-document "$1"
	echo "Checking downloaded version..."
	osbot_version "$1"
	echo "Downloaded: $OSBOT_CURRENT_VERSION"
}

# Update $1, an OSBot jar file
osbot_update() {
	echo "Checking version of $1..."
	osbot_version "$1"

	if test $OSBOT_CURRENT_VERSION = $OSBOT_LATEST_VERSION
	then
		echo "Up-to-date: $OSBOT_CURRENT_VERSION"
	else
		echo "Out-of-date: $OSBOT_CURRENT_VERSION"
		if ! test -z "$BACKUP_FOLDER"
		then
			osbot_backup "$OSBOT_JAR" "$OSBOT_CURRENT_VERSION"
		fi
		osbot_download "$1"
	fi
}

# Performs the main logic of the program
main() {
	if test -f "$OSBOT_JAR"
	then
		osbot_update "$OSBOT_JAR"
	else
		osbot_download "$OSBOT_JAR"
	fi
}

main
