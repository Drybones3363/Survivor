

local Player = require("Objects/Player")

local FirstNames = require("Data/FirstNames")
local LastNames = require("Data/LastNames")

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
	setmetatable(ret,Game)
	Game.__index = Game

	for i,k in pairs (Default_Data) do
		if not data[i] then
			data[i] = k
		end
	end

	ret.GameData = {}
	ret.GameData.Players = {}
	for i=1,data.numPlayers do
		local playerData = {Gender = (i%2 == 0 and "Male" or "Female")}
		local player = Player.new(playerData)
		table.insert(ret.GameData.Players,player)
	end

	local nameHashTable = {}
	for i=1,#ret.GameData.Players do
		local player = ret.GameData.Players[i]
		local gender = player:getGender()
		local firstNamesTable = FirstNames[gender]
		local first,last
		repeat
			first = firstNamesTable[math.random(#firstNamesTable)]
			last = LastNames[math.random(#LastNames)]
		until nameHashTable[first] == nil and nameHashTable[last] == nil --..last
		nameHashTable[first] = true --..last
		nameHashTable[last] = true
		player:setFirstName(first)
		player:setLastName(last)
		print(first,last)
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