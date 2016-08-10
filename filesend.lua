-- Send file
return function(conn, fName, fType)

	local function getFSize(filename)
		local fsize
		for k, v in pairs(file.list()) do
			if k == filename then
				fsize = v
				break
			end
		end
		return fsize
	end

	if not file.open(fName, "r") then
		conn:send([[
HTTP/1.1 404 Not Found
Server: ESP
Content-Type: text/html
Content-Length: 14
Connection: close

File not found
]])
		return 0
	end

	local fSize = getFSize(fName);
	local data = ""
	if fOffset == 0 then
		data = [[
HTTP/1.1 200 OK
Server: ESP
Content-Type: ]] .. fType .. "\r\n" .. [[
Content-Length: ]] .. getFSize(fName) .. "\r\n" .. [[
Connection: close

]]
	end

	local CHUNK_SIZE = 1024

	file.seek("set", fOffset)
	local chunk = file.read(CHUNK_SIZE)
	file.close()

	if chunk then
		data = data .. chunk
		conn:send(data)
	end

	fOffset = fOffset + CHUNK_SIZE

	if fOffset > fSize then
		fOffset = 0
	end
end
