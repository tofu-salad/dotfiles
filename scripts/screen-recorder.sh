#!/usr/bin/env bash

NGINX_SERVICE_NAME="nginx"
OBS_EXEC="obs"
OUTPUT="rtmp://127.0.0.1/feed/live"

is_nginx_running() {
	systemctl is-active --quiet "$NGINX_SERVICE_NAME"
}

start_nginx() {
	echo "attempting to start Nginx..."
	sudo systemctl start "$NGINX_SERVICE_NAME"
	if [ $? -eq 0 ]; then
		echo "Nginx started successfully."
	else
		echo "failed to start Nginx. please check Nginx configuration and permissions."
		exit 1
	fi
}

stop_nginx() {
	echo "stopping Nginx..."
	sudo systemctl stop "$NGINX_SERVICE_NAME"
	if [ $? -eq 0 ]; then
		echo "Nginx stopped successfully."
	else
		echo "failed to stop Nginx. manual intervention might be required."
	fi
}

trap 'echo "script interrupted. cleaning up..."; stop_nginx; exit' INT TERM
trap 'echo "script finished. cleaning up..."; stop_nginx' EXIT

echo "searching for Chromecast..."

CHROMECAST_IP=$(avahi-browse -rt _googlecast._tcp | awk '
/^= / { in_chromecast = 0 }
/Chromecast/ { in_chromecast = 1 }
/address/ && in_chromecast {
	gsub(/[ \[\]]/, "", $3);
	print $3;
	exit
}')

if [ -z "$CHROMECAST_IP" ]; then
	echo "error: Chromecast not found. please ensure it's on the same network."
	exit 1
else
	echo "chromecast found at ip: $CHROMECAST_IP"
fi

echo "checking Nginx status..."
if is_nginx_running; then
	echo "Nginx is already running."
else
	echo "Nginx is not running. starting it now..."
	start_nginx
	sleep 3
fi

echo "launching OBS"
"$OBS_EXEC" --startstreaming &
OBS_PID=$!

echo "waiting 10 seconds for OBS to establish stream..."
sleep 10

if ! kill -0 "$OBS_PID" 2>/dev/null; then
	echo "OBS failed to launch or crashed. exiting."
	exit 1
fi

echo "starting VLC to cast RTMP feed to Chromecast..."
cvlc "$OUTPUT" --sout "#chromecast{ip=$CHROMECAST_IP}"

echo "VLC has finished. exiting script."
