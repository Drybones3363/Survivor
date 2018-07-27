

local Challenge = {}

local Challenge_Types = {
	"Strength",
	"Intelligence",
	"Mix"
}

local Challenge_Data = {
	Strength = function()
		local ret = {}
		for i=1,math.random(5) do
			table.insert(ret,{Type = "Strength", Amount = math.random(25,100)})
		end
		return ret
	end,
	Intelligence = function()
		local ret = {}
		for i=1,math.random(5) do
			table.insert(ret,{Type = "Intelligence", Amount = math.random(25,100)})
		end
		return ret
	end,
	Mix = function()
		local ret = {}
		for i=3,math.random(7) do
			table.insert(ret,{
				Type = math.random(2) == 1 and "Strength" or "Intelligence",
				Amount = math.random(25,100)
			})
		end
		return ret
	end,

}

function Challenge.new(data)
	if not data then
		data = {}
	end

	local self = {}
	setmetatable(self,Challenge)
	Challenge.__index = Challenge

	local Challenge_Type = data.Challenge_Type or math.random(3)
	if type(Challenge_Type) == "number" then
		Challenge_Type = Challenge_Types[Challenge_Type]
	end

	self.Data = Challenge_Data[Challenge_Type]()

	return self
end

function Challenge:getData()
	return self.Data
end

return Challenge
