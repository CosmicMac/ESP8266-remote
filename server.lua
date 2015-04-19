-- Create server
local function server()

	local srv = net.createServer(net.TCP)

	srv:listen(80, function(conn)

		-- Define some constants
		local LAG = 700 -- Value to substract from self-timer delay (ms)
		local TRIGGER = 500 -- Trigger duration (ms)
		local ON = gpio.LOW
		local OFF = gpio.HIGH
		local GPIO0 = 3

		-- Define some variables
		fOffset = 0 -- Yep, this one is global
		local fName = ""
		local fType = ""
		local fSend = dofile("filesend.lc")

		-- Set GPIO pin
		gpio.write(GPIO0, OFF)
		gpio.mode(GPIO0, gpio.OUTPUT)

		conn:on("receive", function(conn, request)

			local function gpioTrigger(gpioId)
				gpio.write(gpioId, ON)
				print("TRIGGER!")
				tmr.alarm(0, TRIGGER, 0, function()
					gpio.write(gpioId, OFF)
				end)
			end

			local function jsonSend(json)
				conn:send([[
HTTP/1.1 200 OK
Server: ESP
Content-Type: application/json
Content-Length:]] .. #json .. "\r\n" .. [[
Connection: close

]] .. json)
			end

			local _, _, method, path, vars = string.find(request, "([A-Z]+) /([^?]*)%??(.*) HTTP")

			print(string.format("Incoming request: %s /%s?%s HTTP/1.1", method, path, vars))

			if path == "favicon.png" then
				-- FAVICON REQUEST
				fName = "favicon.png"
				fType = "image/png"
				fSend(conn, fName, fType)

			elseif #vars > 0 then
				-- NORMAL REQUEST
				-- Get request parameters
				local GET = { action = "", timer = 0, interval = 0 }
				for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
					GET[k] = v
				end
				GET.timer = math.max(GET.timer * 1000 - LAG, 1)
				GET.interval = GET.interval * 1000

				if GET.action == "trigger" then
					-- TRIGGER
					tmr.stop(0)
					tmr.stop(1)
					tmr.alarm(0, GET.timer, 0, function()
						gpioTrigger(GPIO0)
						if GET.interval > 0 then
							tmr.alarm(1, GET.interval, 1, function()
								gpioTrigger(GPIO0)
							end)
						end
					end)
					jsonSend('{ "status": "OK", "heap":"' .. node.heap() .. '"}')

				elseif GET.action == "reset" then
					-- RESET
					tmr.stop(0)
					tmr.stop(1)
					jsonSend('{ "status": "OK", "heap":"' .. node.heap() .. '"}')

				else
					-- BAD REQUEST
					jsonSend('{ "status": "ERROR", "heap":"' .. node.heap() .. '"}')
				end

			else
				-- DEFAULT PAGE
				fName = "index.html"
				fType = "text/html"
				fSend(conn, fName, fType)
			end
		end)

		conn:on("sent", function(conn)
			if fOffset > 0 then
				fSend(conn, fName, fType)
			else
				conn:close()
				print("Connection closed")
				collectgarbage()
			end
		end)
	end)
	print("Server ready!")
end

server()