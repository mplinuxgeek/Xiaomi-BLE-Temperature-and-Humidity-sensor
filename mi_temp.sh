#!/bin/bash

bt="4C:65:A8:DB:D1:32"
sensor="mi_temp"
room="Lounge_Room"
ip="192.168.1.60"

cel=$'\xe2\x84\x83'
per="%"

echo "Enabling LE Mode"
btmgmt le on

RET=1
until [ ${RET} -eq 0 ]; do
    echo "Getting Temperature and Humidity..."
    data=$(/usr/bin/timeout 20 /usr/bin/gatttool -b $bt --char-write-req --handle=0x10 -n 0100 --listen | grep "Notification handle" -m 2)
    RET=$?
    sleep 5
done

RET=1
until [ ${RET} -eq 0 ]; do
    echo "Getting Battery Level..."
    battery=$(/usr/bin/gatttool -b $bt --char-read --handle=0x18 | cut -c 34-35)
    RET=$?
    sleep 5
done

temp=$(echo $data | tail -1 | cut -c 42-54 | xxd -r -p)
humid=$(echo $data | tail -1 | cut -c 64-74 | xxd -r -p)
batt=$(echo "ibase=16; $battery"  | bc)
echo "Temperature: $temp$cel"
echo "Humidity: $humid$per"
echo "Battery Level: $batt$per"

echo -e -n "\nPublishing data via MQTT... "
if [[ "$temp" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    /usr/bin/mosquitto_pub -h $ip -V mqttv311 -t "/$sensor/$room/temperature" -m "$temp"
fi

if [[ "$humid" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    /usr/bin/mosquitto_pub -h $ip -V mqttv311 -t "/$sensor/$room/humidity" -m "$humid"
fi

if [[ "$batt" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    /usr/bin/mosquitto_pub -h $ip -V mqttv311 -t "/$sensor/$room/battery" -m "$batt"
fi
echo "done"
