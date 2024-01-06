#!/usr/bin/env bash

exec mosquitto_pub -p 1883 -t 'zigbee2mqtt/living_room/set' -m '{ "state": "OFF" }'
