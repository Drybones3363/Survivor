

local Player = require("Objects/Player")

local FirstNames = require("Data/FirstNames")
local LastNames = require("Data/LastNames")
local PlayerStats = require("Data/PlayerStats")
local TribeNames = require("Data/TribeNames")

local json = require("Libraries/json")

local Game = {}

--Game.__index = Game

local Default_Data = {
	numTribes = 2,
	numPlayers = 16
}

local clock = os.clock
function	wait(n)
	local t0 = clock()
	while clock() - t0 <= n do end
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

function format_number(n)
	if n > 10 and n < 20 then
		return n.."th"
	elseif n%10 == 1 then
		return n.."st"
	elseif n%10 == 2 then
		return n.."nd"
	elseif n%10 == 3 then
		return n.."rd"
	else
		return n.."th"
	end
end

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

	local tribesIndex = {}
	local tribeNamesTable = clonet(TribeNames)
	for i=1,data.numTribes do
		local r = math.random(#tribeNamesTable)
		table.insert(tribesIndex,tribeNamesTable[r])
		table.remove(tribeNamesTable,r)
	end

	ret.GameData = {}
	ret.GameData.Tribes = {}
	for i,k in pairs (tribesIndex) do
		ret.GameData.Tribes[k] = {}
	end
	local nameHashTable = {}

	for i=1,data.numPlayers do
		local playerData = {Gender = (i <= data.numPlayers/2 and "Male" or "Female")}
		local tribeName = tribesIndex[(i%data.numTribes+1)]
		local gender = playerData.Gender
		local firstNamesTable = FirstNames[gender]
		local first,last
		repeat
			first = firstNamesTable[math.random(#firstNamesTable)]
			last = LastNames[math.random(#LastNames)]
		until nameHashTable[first] == nil and nameHashTable[last] == nil --..last
		nameHashTable[first] = true --..last
		nameHashTable[last] = true
		playerData.FirstName = first
		playerData.LastName = last
		playerData.Tribe = tribeName
		playerData.Stats = PlayerStats[first.." "..last]
		local player = Player.new(playerData)

		table.insert(ret.GameData.Tribes[tribeName],player)
	end

	ret.GameData.Day = 0
	ret.GameData.VotedOut = {}

	return ret
end

function Game:showIntro(quick)
	for tribeName,players in pairs (self.GameData.Tribes) do
		print(tribeName)
		if not quick then wait(1) end
		print("")
		if not quick then wait(1) end
		for _,player in pairs (players) do
			print(player)
			if not quick then wait(2) end
		end
		if not quick then wait(1) end
		print("")
		if not quick then wait(1) end
	end
end

function Game:simulateDay()
	local gameData = self.GameData

end

function Game:simulateRewardChallenge()

end

function Game:simulateImmunityChallenge()

end

function Game:simulateVote(tribeName,ignorePlayers,revote)
	local oldNum = #self.GameData.VotedOut
	local votingTribe = (function()
		local ret = {}
		for i=1,#self.GameData.Tribes[tribeName] do
			local player = self.GameData.Tribes[tribeName][i]
			if ignorePlayers == nil or ignorePlayers[player] == nil then
				table.insert(ret,player)
			end
		end
		return ret
	end)()
	local beingVoted = (function()
		local ret = {}
		for i=1,#self.GameData.Tribes[tribeName] do
			local player = self.GameData.Tribes[tribeName][i]
			if ignorePlayers == nil or ignorePlayers[player] then
				table.insert(ret,player)
			end
		end
		return ret
	end)()
	local voteData = {}
	for _,player in pairs (votingTribe) do
		wait(1)
		local votedPlayer = player:getVote(beingVoted)
		voteData[player] = votedPlayer
		print(tostring(player).." casted")
	end
	print("I'll go tally the votes")
	wait(3)
	print("If anyone has a hidden immunity idol and you would like to play it,")
	wait(2)
	print("now would be the time to do so.")
	wait(4)
	print("Alright, once the votes are read, the decision is final.")
	wait(2)
	print("The person voted out will be asked to leave the council area immediately.")
	wait(2)
	print("I'll read the votes")
	wait(3)
	print("First Vote")
	wait(1.5)
	local readData = {}
	local first,second = 0,0
	local clonedVoteData = (function()
		local ret = {}
		for i,k in pairs (voteData) do
			ret[i] = k
		end
		return ret
	end)()
	local function readNextVote(n,left)
		for e,r in pairs (clonedVoteData) do
			if readData[r] == nil or readData[r] <= n then
				clonedVoteData[e] = nil
				readData[r] = readData[r] and readData[r] + 1 or 1
				if first < readData[r] then
					first = readData[r]
				elseif second < readData[r] then
					second = readData[r]
				end
				if first-second > left then
					local votedOutData = {Player = r,VoteData = voteData}
					table.insert(self.GameData.VotedOut,votedOutData)
					for q,w in pairs (self.GameData.Tribes[tribeName]) do
						if w == votedOutData.Player then
							table.remove(self.GameData.Tribes[tribeName],q)
							break
						end
					end
					print(format_number(#self.GameData.VotedOut).." person voted out of Survivor...")
					wait(3)
					print(r)
					return true
				end
				print(r)
				wait(3)
				if left == 0 then
					if revote then
						return false
					end
					print("There was a tie...")
					wait(3)
					print("We will be revoting")
					wait(3)
					local ignore = {}
					for plr,r in pairs (readData) do
						if r == first then
							ignore[plr] = true
							print(tostring(plr).." will not vote.")
						end
					end
					self:simulateVote(tribeName,ignore,true)
					return false
				end
				return
			end
		end
		return readNextVote(n+1,left)
	end
	local successfulVote
	for i=1,#votingTribe do
		if i == #votingTribe then
			print("One vote left")
			wait(2)
		end
		successfulVote = readNextVote(0,#votingTribe-i)
		if successfulVote ~= nil then
			break
		end
	end
	if successfulVote == false and oldNum == #self.GameData.VotedOut then
		print("We have to draw rocks...")
	else
		wait(5)
		print("Vote Outcome: ")
		for i,k in pairs (voteData) do
			wait(1.5)
			print(tostring(i).."\t\t\t"..tostring(k))
		end
	end


end

function Game:tribeMerge(tribe1,tribe2)

end

function Game:mixTribes(switch,n)
	if not n then
		print("TODO: mixTribes for every player")
	else
		local playersSwitching = {}
		local tribeNumbers = {}
		for tribename,players in pairs (self.GameData.Tribes) do
			if n > #players then
				print(tribename.." only has "..#players.." Members")
				return
			end
			tribeNumbers[tribename] = n
			for i=1,n do
				local r = math.random(#players)
				local player = players[r]
				table.insert(playersSwitching,player)
				table.remove(players,r)
			end
		end
		for i=1,#playersSwitching do
			local player = playersSwitching[i]
			local oldTribe = player:getTribe()
			local possibilities = (function()
				local ret = 0
				for e,r in pairs (tribeNumbers) do
					if not(switch and e == oldTribe) then
						ret = ret + r
					end
				end
				return ret
			end)()
			local rand = math.random(possibilities)
			for newTribe,r in pairs (tribeNumbers) do
				if not(switch and e == oldTribe) then
					if rand <= 0 then
						table.insert(self.GameData.Tribes[newTribe],player)
						player:setTribe(newTribe)
						break
					else
						rand = rand - r
					end
				end
			end
		end
	end
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