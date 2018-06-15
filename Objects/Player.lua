

local FirstNames = require("Data/FirstNames")
local LastNames = require("Data/LastNames")

local Player = {}




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
	Stats = {
		Strength = 50,
		Popularity = 50,
		Control = 50,
	},
	FirstName = "Adam",
	LastName = "Galauner",
	Gender = "Male"
}

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

return Player