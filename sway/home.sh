#!/usr/bin/env bash
 
case "$(echo -e "󰛨 Lights on\n󰹐 Lights off" | bemenu $@ \
    "Power:" -l 2)" in
        "󰛨 Lights on") exec mosquitto_pub -t 'zigbee2mqtt/living_room/set' -m '{ "state": "ON" }';;
        "󰹐 Lights off") exec mosquitto_pub -t 'zigbee2mqtt/living_room/set' -m '{ "state": "OFF" }';;
esac
