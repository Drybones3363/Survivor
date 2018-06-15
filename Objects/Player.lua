

local FirstNames = require("Data/FirstNames")
local LastNames = require("Data/LastNames")

local Player = {}

Player.__tostring = function(self)
	return self.FirstName --.." "..self.LastName
end


function clonet(t)
	local ret = {}
	for i,k in pairs (t) do
		if type(k) == "table" then
			ret[i] = clonet(k)
		else
			ret[i] = k
		end
	end
	return ret
end


local Default_Data = {
	--[[Stats = {
		Strength = 50,
		Popularity = 50,
		Control = 50,
		Intelligence = 50,
	},--]]
	FirstName = "Adam",
	LastName = "Galauner",
	Gender = "Male",
	Health = 50
}

local getStat = {
	Strength = function(gender)
		local rand = math.random()
		if gender == "Male" then
			return 100*(rand^.35)
		else
			return 100*(rand^1.75)
		end
	end,
	Popularity = function(gender)
		local rand = math.random()
		return 100*(rand^.5)
	end,
	Control = function(gender)
		local rand = math.random()
		if gender == "Male" then
			return 100*(rand^.75)
		else
			return 100*(rand)
		end
	end,
	Intelligence = function(gender)
		local rand = math.random()
		if gender == "Male" then
			return 100*(rand^.65)
		else
			return 100*(rand^.4)
		end
	end,
}


function getRandomStats(gender)
	local ret = {}
	for i,k in pairs (getStat) do
		ret[i] = math.ceil(k(gender))
	end
	return ret
end

function Player.new(data)
	local ret = {}
	setmetatable(ret,Player)
	Player.__index = Player

	local function updateData(t,copy)
		if not t then
			t = {}
		end
		for i,k in pairs (copy) do
			if not t[i] then
				if type(k) == "table" then
					t[i] = clonet(k)
				else
					t[i] = k
				end
			elseif type(k) == "table" then
				t[i] = updateData(t[i],k)
			end
		end
		return t
	end
	data = updateData(data,Default_Data)

	if not data.Stats then
		data.Stats = getRandomStats(data.Gender)
	end


	for i,k in pairs (data) do
		ret[i] = k
	end
	return ret
end

function Player:setFirstName(name)
	self.FirstName = name
end

function Player:setLastName(name)
	self.LastName = name
end

function Player:getGender()
	return self.Gender
end

function Player:getTribe()
	return self.Tribe
end

function Player:setTribe(tribeName)
	self.Tribe = tribeName
end

function Player:getStats()
	return self.Stats
end

function Player:getVote(tribe)
	local index
	repeat
		index = math.random(#tribe)
	until tribe[index] ~= self or #tribe == 1
	return tribe[index]
end

return Player