

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
}

function Player.new(data)
	local ret = {}

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

	local stats = data.Stats
	ret.Stats = stats

	return ret
end

return Player