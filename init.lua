--[[
ESP8266-remote

Trigger a camera from a smartphone connected to ESP8266 running NodeMCU.  

[20150419][v1.0]
	Initial release
]]


-- SET UART CONFIGURATION
uart.setup(0, 115200, 8, 0, 1, 1)

-- SET WIFI CONFIGURATION
wifi.setmode(wifi.SOFTAP)

local cfg

cfg = {
	ip = "10.10.10.10",
	netmask = "255.255.255.0",
	gateway = "10.10.10.10"
}
wifi.ap.setip(cfg)

cfg = {
	ssid = "ESP",
	pwd = "12345678"
}
wifi.ap.config(cfg)

print("\r\n********************")
print("ESP IP:\r\n", wifi.ap.getip())
print("Heap:\r\n", node.heap())
print("********************")

cfg = nil

-- COMPILE LUA FILES
local files = { 'server.lua', 'filesend.lua' }

for _, f in ipairs(files) do
	if file.open(f) then
		file.close()
		node.compile(f)
		file.remove(f)
		print(f, " is now compiled")
	end
end

files = nil

-- START SERVER
collectgarbage()
dofile("server.lc");
