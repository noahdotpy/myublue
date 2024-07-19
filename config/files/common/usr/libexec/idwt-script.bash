#!/usr/bin/bash

# I Don't Want To (IDWT)

## JUST A REFERENCE TO ADD TO /usr/lib/idwt/cmd_apply.nu
# TODO: Remove this file when done translating to nushell

function enable-networking {
	iptables -D OUTPUT -m owner --uid-owner $USERNAME -j DROP >/dev/null
	ip6tables -D OUTPUT -m owner --uid-owner $USERNAME -j DROP >/dev/null
	echo "on" >$STATUS_FILE
	echo "Networking enabled for user $USERNAME."
}

function disable-networking {
	iptables -A OUTPUT -m owner --uid-owner $USERNAME -j DROP >/dev/null
	ip6tables -A OUTPUT -m owner --uid-owner $USERNAME -j DROP >/dev/null
	echo "off" >$STATUS_FILE
	echo "Networking disabled for user $USERNAME."
}

USERNAME="noah"

TIME_START="08:30"
TIME_END="15:00"

CURRENT_TIME=$(date +"%H:%M")
DAY_OF_WEEK=$(date +%u)

CONFIG_FILE="/etc/idwt/config"
CONFIG=$(cat $CONFIG_FILE)

STATUS_FILE="/etc/idwt/networking-status"

echo "Networking config is set to: '$CONFIG'"

if [[ "$CONFIG" = "disallow" ]]; then
	disable-networking
elif [[ "$CONFIG" = "allow" ]]; then
	enable-networking
elif [[ "$CONFIG" = "schedule" ]]; then
	# If day == wednesday and time_is_between(8:30-15:00); then: enable networking; else: disable networking.
	if [[ "$CURRENT_TIME" > "$TIME_START" && "$CURRENT_TIME" < "$TIME_END" && "$DAY_OF_WEEK" = "3" ]]; then
		enable-networking
	else
		disable-networking
	fi
else
	echo "Config is not a valid option. Must be 'disallow', 'allow' or 'schedule'"
fi
