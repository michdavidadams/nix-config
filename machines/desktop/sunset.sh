#!/usr/bin/env bash

if [ $(sunwait poll 34.26N 85.18W) == "NIGHT" ]
then
  exec mosquitto_pub -p 1883 -t 'zigbee2mqtt/living_room/set' -m '{ "scene_recall": 2 }'
else
  exec mosquitto_pub -p 1883 -t 'zigbee2mqtt/living_room/set' -m '{ "scene_recall": 1 }'
fi
