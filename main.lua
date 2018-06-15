
local Player = require("Objects/Player")
local Game = require("Objects/Game")


local p = Player.new()

function main()
	local g = Game.new()
	Game.save(g,"First")
	io.write("\nSurvivor Season Started\n\n")

	local input,i2 = io.read(),io.read()
	print(input,i2)
end



main()