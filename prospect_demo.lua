-- Replace with server address.
SERVER_ADDR = "http://XXX:3000/add_scan"
geo = peripheral.wrap("left")
 
 
 
function printTable(table)
  for key, value in pairs(table) do
    print(key .. ": " .. value)
  end
end
 
 
chunk_data, error = geo.chunkAnalyze()
if chunk_data ~= nil then
  --print("Chunk Data:")
  -- printTable(chunk_data)
else
  print("Chunk data is nil: " .. error)
end
 
-- Create the POST data
local post_data = {
  probe_name = "TESTBED",
  chunk_x = 0,
  chunk_y = 0,
 -- block_counts = {
 --   ["minecraft:dirt"] = 10,
 --   ["minecraft:cobblestone"] = 15
  --}
  block_counts = chunk_data
}
 
local headers = {
  ["Content-Type"] = "application/json",
  ["Accept"] = "text/plain"
}
 
post_json = textutils.serializeJSON(post_data)
print("JSON Body: " .. post_json)
resp = http.post(SERVER_ADDR, post_json, headers)
if resp ~= nil then
  print("Code: " .. resp.getResponseCode())
  print("Response:")
  print(resp.readAll())
else
  print("Response was nil")
end
