![Alt text](images/wip.png?raw=true "Title")

# Xiaomi-BLE-Temperature-and-Humidity-sensor
Bash script for retrieving data from Xiaomi BLE Temperature/Humidity sensor and publishing via MQTT. These sensors are designed to be connected to Xiaomi's Mi app but provide no historic data recording, only current readings.

Specs:
CPU | Nordic N51802
Temp/Humidity Sensor | SHT30-DIS-B (Typical accuracy of ±2% RH and ±0.2°C) [Datasheet](https://www.sensirion.com/fileadmin/user_upload/customers/sensirion/Dokumente/0_Datasheets/Humidity/Sensirion_Humidity_Sensors_SHT3x_Datasheet_digital.pdf)
LCD Driver | BU9795AFV
Power|  1x AAA

![Alt text](images/MiTemp.jpg?raw=true "Title")

These sensors have fairly short range so this script is designed to be run from a linux computer or a Raspberry Pi with BT LE capability, tested/developed on a Raspberry Pi Zero W running Raspbian Stretch using the built in BT.

![Alt text](images/screenshot.png?raw=true "Title")

Original version of the script written by mig in the Home Assistant forums:
<https://community.home-assistant.io/t/xiaomi-mijia-bluetooth-temperature-humidity-sensor-compatibility/43568/7>

# Installation

```bash
apt-get install mosquitto-clients bc
git clone https://github.com/mplinuxgeek/Xiaomi-BLE-Temperature-and-Humidity-sensor
cd Xiaomi-BLE-Temperature-and-Humidity-sensor
sudo ln -s $(pwd)/mi_temp.sh /opt/mi_temp
```
# Configuration

Find MAC address of you Mi Temp devices:
```bash
# Enable and initialise HCI device
sudo hciconfig hci0 up
# Enable LE mode
sudo btmgmt le on
# Scan for LE devices
sudo hcitool lescan
# or for an output nicely formatted for copy and paste
sudo hcitool lescan | grep "MJ_HT_V1" | tr ' ' ','
```
The Mi Temp devices appear as "MJ_HT_V1"

Look for a line like this:
```
4C:65:A8:DC:0F:B2 MJ_HT_V1
```
Copy the line with "MJ_HT_V1" and add it to the sensors file:
```bash
nano /opt/sensors
```
The file should be formatted like a CSV file, the MAC address and Name should be separated by a comma and replace MJ_HT_V1 with a name for the sensor (do not use spaces), it should look something like this:
```
4C:65:A8:DC:0F:B2,Outside
```

If you have more than one sensor add as many as you like, the script will loop through the content of the sensors file.

Lastly create a crontab entry.
```cron
*/1 * * * * /opt/mi_temp > /tmp/mi_temp
```
