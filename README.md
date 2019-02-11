![Alt text](images/wip.png?raw=true "Title")

# Xiaomi-BLE-Temperature-and-Humidity-sensor
Bash script for retrieving data from Xiaomi BLE Temperature/Humidity sensor and publishing via MQTT. These sensors are designed to be connected to Xiaomi's Mi app but provide no historic data recording, only current readings.

Specs|[]()
------------- | -------------
Temp/Humidity Sensor|SHT30-DIS-B (Typical accuracy of ±2% RH and ±0.2°C) [Datasheet](https://www.sensirion.com/fileadmin/user_upload/customers/sensirion/Dokumente/0_Datasheets/Humidity/Sensirion_Humidity_Sensors_SHT3x_Datasheet_digital.pdf)
SoC|N51802 (Nordic nRF51802)
LCD Driver|BU9795AFV [Datasheet](http://rohmfs.rohm.com/en/products/databook/datasheet/ic/driver/lcd_segment/bu9795afv-e.pdf)
Power|1x AAA

I can't find any real information on the SoC but it appears to be a Nordic nRF51802, Mousers description of the nRF51802 is "Nordic Semiconductor BLE/2.4GHz RF SoC with 256K Flash nRF51 LC QFN 48 pin 6x6" and the code on the SoC lines up with nRF51 codes. I assume the CPU/MCU is the same as the nRF51822 which is a 16MHz 32bit ARM Cortex M0.

Based on the nRF51822 datasheet the product code breaks out to this:
QFAAA0
QF = QFN48 package
AA = 256kB Flash/16kB RAM, DC/DC bond-out
A0 = Hardware version/revision identifier

Tracking code: 1807Z8
18 = Year of production, ie 2018
07 = Week of production, ie 7th week
Z8 = Wafer production lot identifier

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
