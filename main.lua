
local Player = require("Objects/Player")
local Game = require("Objects/Game")


local p = Player.new()

math.randomseed(os.time())

function main()
	local g = Game.new()
	--g:save("First")
	io.write("\nSurvivor Season Started\n\n")

end



main()