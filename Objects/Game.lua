

local Player = require("Objects/Player")

local json = require("Libraries/json")

local Game = {}

--Game.__index = Game

local Default_Data = {
	numTribes = 2,
	numPlayers = 16
}

function Game.new(data)
	local ret = {}
	if not data then
		data = {}
	end

	for i,k in pairs (Default_Data) do
		if not data[i] then
			data[i] = k
		end
	end

	ret.GameData = {}
	ret.GameData.Players = {}
	for i=1,data.numPlayers do
		table.insert(ret.GameData.Players,Player.new())
	end

	return ret
end

function Game.load(saveString)
	local file = io.open("Saves/"..saveString..".txt","r")
	local str = file:read()
	file:close()
	if str:len() == 0 then
		print("No game found for: "..saveString..".txt\n")
		return
	end
	return json.decode(str)
end

function Game:save(saveString)
	local str = json.encode(self.GameData)
	local file = io.open("Saves/"..saveString..".txt","w")
	file:write(str)
	file:close()
	print("Saved Successfully to "..saveString..".txt\n")
end

return Game