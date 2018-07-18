
local Player = require("Objects/Player")
local Game = require("Objects/Game")


local p = Player.new()

math.randomseed(os.time())

function stringSplit(str)
	local ret = {}
	for i in string.gmatch(str, "%S+") do
		table.insert(ret,i)
	end
	return ret
end

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
		elseif input:sub(1,8) == "friends " then
			local playerName = input:sub(9)
			g:findPlayer(playerName):printTribeFriendships()
		elseif input:sub(1,5) == "save " then
			g:save(input:sub(6))
		elseif input == "intro" then
			g:showIntro(true)
		elseif input == "slow intro" then
			g:showIntro()
		elseif input:sub(1,5) == "merge " then
			local t = stringSplit(input:sub(6))
			g:mergeTribes(t[1],t[2])
		elseif input:sub(1,14) == "switch tribes " then
			local n = tonumber(input:sub(6))
			g:mixTribes(n)
		end
	end

end



main()