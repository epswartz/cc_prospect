-- Replace with server address.
SERVER_ADDR = "http://XXX:3000/add_scan"
geo = peripheral.wrap("left")
 
 
function printTable(table)
  for key, value in pairs(table) do
    print(key .. ": " .. value)
  end
end

function upOrErr(dist)
    for i=1,dist,1 do
        if not turtle.up() then
            error("Cannot move inside move or die function: upOrErr()")
        end
    end
end


function fwdOrErr(dist)
    for i=1,dist,1 do
        if not turtle.forward() then
            error("Cannot move inside move or die function: fwdOrErr()")
        end
    end
end
 
function sendToServer(x, y)
	chunk_data, chunk_error = geo.chunkAnalyze()
	if chunk_data ~= nil then
	  --print("Chunk Data:")
	  --printTable(chunk_data)
	else
	  error("Chunk data is nil: " .. chunk_error)
	  os.exit(1)
	end
	-- Create the POST data
	local post_data = {
	  probe_name = "TESTBED3",
	  chunk_x = x,
	  chunk_y = y,
	  block_counts = chunk_data
	}

	local headers = {
	  ["Content-Type"] = "application/json",
	  ["Accept"] = "text/plain"
	}

	post_json = textutils.serializeJSON(post_data)
	resp = http.post(SERVER_ADDR, post_json, headers)
	if resp ~= nil then
		print("Code: " .. resp.getResponseCode())
		print("Response:")
		print(resp.readAll())
		if resp.getResponseCode() ~= 200 then
			error("Non-200 code:" .. resp.getResponseCode())
		end
	else
		error("Server response was nil")
	end
end

-- TODO just go up to the world height.
upOrErr(200)
x = 0
y = 0
sendToServer(x,y)
move_chunks = 1
facing = 0 -- Forward in Y direction
while true do
	for i=1,2,1 do
		for j=1,move_chunks,1 do
			fwdOrErr(16)
			if facing == 0 then
				y = y + 1
			elseif facing == 1 then
				x = x + 1
			elseif facing == 2 then
				y = y - 1
			elseif facing == 3 then
				x = x - 1
			else
				error("Invalid facing: " .. facing)
			end
			sendToServer(x,y)
		end
		turtle.turnRight()
		facing = math.fmod(facing + 1, 4)
	end
	move_chunks = move_chunks + 1
	
end
