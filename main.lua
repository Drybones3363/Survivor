
local Player = require("Objects/Player")
local Game = require("Objects/Game")


local p = Player.new()

math.randomseed(os.time())

function main()
	local g = Game.new()

	io.write("\nSurvivor Season Started\n\n")

	local input
	while input ~= "q" do
		print("Command: ")
		input = io.read()
		if input:sub(1,5) == "vote " then
			local tribeName = input:sub(6)
			g:simulateVote(tribeName)
		elseif input:sub(1,5) == "save " then
			g:save(input:sub(6))
		elseif input == "intro" then
			g:showIntro(true)
		elseif input == "slow intro" then
			g:showIntro()
		end
	end

end



main()