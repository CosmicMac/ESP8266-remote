## ESP8266-remote

Trigger a camera from a smartphone connected to ESP8266 running NodeMCU (configured as access point).  
Tested with a Canon DSLR, but it should work with any cameras with built-in shutter switch terminal (cf. http://www.doc-diy.net/photo/remote_pinout/).

### Main functions
* Instant trigger
* Self-timer
* Intervalometer

<p align="center">
![Screenshot](https://github.com/CosmicMac/ESP8266-remote/raw/master/readme/screenshot.jpg)
</p>

### Shopping list
1. ESP8266 running a recent version of NodeMCU (I used `nodemcu_integer_0.9.6-dev_20150406`)
2. battery AAA x 2
3. battery holder
4. switch
5. optocoupler 4N25 or equivalent
6. resistor 220 Ohm (actual value depends on optocoupler charateristics)
7. tablets tube (nice enclosure :) )
8. cable and connector depending on your camera model

### Wiring
* 4N25 `pin 1` to `VCC` throught resistor
* 4N25 `pin 2` to ESP `GPIO0`
* 4N25 `pin 4` to `ground wire` of the release cable
* 4N25 `pin 5` to `shutter wire` of the release cable

<p align="center">
![Wiring](https://github.com/CosmicMac/ESP8266-remote/raw/master/readme/wiring.jpg)
</p>

<p align="center">
![The thing](https://github.com/CosmicMac/ESP8266-remote/raw/master/readme/640.jpg)
</p>

### 2DO
* Wrap self adhesive velcro around the tablets tube and my tripod
* Play with another ESP in client mode to trigger with PIR sensor

### Resources
* http://www.martyncurrey.com/activating-the-shutter-release/  
  Great tutorial with excellent explanations of optocouplers  
  
* http://www.instructables.com/id/Automatic-Camera-Shutter-Switch/  
  About the different ways to trigger a remote camera

* http://www.doc-diy.net/photo/eos_wired_remote/  
  All you need to know about remote control for Canon EOS cameras

* http://github.com/marcoskirsch/nodemcu-httpserver  
  Excellent entry point to understand how to play with NodeMCU and Lua to get a working HTTP server (many thanks @marcoskirsch!)  
  
* http://www.esp8266.com/viewforum.php?f=17  
  ESP8266 Community Forum (inevitable...)

### Credits
Favicon by [Turbomilk](http://www.softicons.com/toolbar-icons/iconza-grey-icons-by-turbomilk/camera-icon)
  
&nbsp;
&nbsp;

----

By the way, this project includes many "first time":

* First GitHub project
* First contact with NodeMCU and Lua
* First use of a stand alone ESP8266
* First time I publish something usefull (I hope so :)) on the Internet

*Have a nice day playing with ESP8266!*