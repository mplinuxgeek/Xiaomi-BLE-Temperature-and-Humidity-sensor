# Xiaomi-BLE-Temperature-and-Humidity-sensor
Bash script for retrieving data from Xiaomi BLE Temperature and Humidity sensor and publishing via MQTT.

These sensors have an LCD screen, run from 1 AAA battery and use an SHT30 temperature and humidity sensor. They are designed to be used with Xiaomi's Mi Home App.
![Alt text](images/MiTemp.jpg?raw=true "Title")

These sensors have fairly short range so this script is designed to be run from a linux computer with a USB Bluetooth dongle or from one of the Raspberry Pi's with Wifi/BT.

![Alt text](images/screenshot.png?raw=true "Title")

The script has been tested on a Raspberry Pi Zero W running Raspbian Stretch.

# Installation

```bash
apt-get install mosquitto-clients bc
git clone https://github.com/mplinuxgeek/Xiaomi-BLE-Temperature-and-Humidity-sensor
cd Xiaomi-BLE-Temperature-and-Humidity-sensor
sudo ln -s $(pwd)/mi_temp.sh /opt/mi-temp
```
# Configuration

Scan for BT devices:
```bash
sudo hcitool lescan
```
The Mi Temp devices appear as "MJ_HT_V1"

Look for a line like this:
```
4C:65:A8:DC:0F:B2 MJ_HT_V1
```
Copy the line with "MJ_HT_V1" and add it to the sensors file:
```bash
nano sensors
```
The file should be formatted like a CSV file, replace MJ_HT_V1 with the a name for the sensor (do not use spaces), it should look something like this:
```
4C:65:A8:DC:0F:B2,Outside
```

If you have more than one sensor add as many as you like, the script will loop through the content of the sensors file.

Lastly create a crontab entry.
```cron
*/1 * * * * /opt/mi_temp > /tmp/mi_temp
```
