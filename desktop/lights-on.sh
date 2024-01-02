#!/usr/bin/env bash
exec mosquitto_pub -t 'zigbee2mqtt/living_room/set' -m '{ "state": "ON" }'
