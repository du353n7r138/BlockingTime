BlockingTime = {
	name = "BlockingTime",
	author = "@Duesentrieb",
	version = "20250728-0920",
	chat = "[Blocking Time]",
	colorOrange = "|cff7f00",
	colorWhite = "|cffffff",
	colorEnd = "|r",

	blockingTime = 0,
	fightStartTime = 0,
	fightUpdateTime = 0,
	isCombat = false,
	isBlocking = false,
}


local BT = BlockingTime


function BT:Initialize()
	EVENT_MANAGER:RegisterForEvent("BlockingTime", EVENT_PLAYER_COMBAT_STATE, BT.combatState)
end


function BT.combatState()
	local preCombatState = BT.isCombat
	BT.isCombat = IsUnitInCombat('player')

	if BT.isCombat == true and preCombatState == false then
		EVENT_MANAGER:RegisterForUpdate("BlockingTimeUpdate", 100, function() BT:updateBlockTime() end)
		BT.isBlocking = false
		BT.blockingTime = 0
		BT.fightStartTime = GetGameTimeMilliseconds()
		BT.fightUpdateTime = GetGameTimeMilliseconds()
	elseif BT.isCombat == false and preCombatState == true then
		EVENT_MANAGER:UnregisterForUpdate("BlockingTimeUpdate")
		BT:reportBlockStats()
	end
end


function BT:updateBlockTime()
	local currentTime = GetGameTimeMilliseconds()
	local deltaTime = currentTime - BT.fightUpdateTime
	BT.fightUpdateTime = currentTime

	BT.isBlocking = IsBlockActive()

	if BT.isBlocking then
		BT.blockingTime = BT.blockingTime + deltaTime
	end
end


function BT.formatDuration(totalSeconds)
	if totalSeconds >= 60 then
		local totalMinutes = math.floor(totalSeconds / 60)
		local remainingSeconds = totalSeconds % 60
		return string.format("%d min %.0f s", totalMinutes, remainingSeconds)
	else
		return string.format("%.0f s", totalSeconds)
	end
end


function BT:reportBlockStats()
	local fightDuration = GetGameTimeMilliseconds() - BT.fightStartTime
	local blockingPercentage = 0
	if fightDuration > 0 then
		blockingPercentage = (BT.blockingTime / fightDuration) * 100
	end

	local fightDurationSeconds = fightDuration / 1000
	local blockingTimeSeconds = BT.blockingTime / 1000

	local formattedFightDuration = BT.formatDuration(fightDurationSeconds)
	local formattedBlockingTime = BT.formatDuration(blockingTimeSeconds)
	local formattedBlockingPercentage = string.format("%.1f", blockingPercentage)

	d(BT.colorOrange .. BT.chat .. BT.colorEnd .. BT.colorWhite .. " Fight Duration: " .. formattedFightDuration .. " - Blocked: " .. formattedBlockingTime .. " -" .. BT.colorEnd .. BT.colorOrange .. " " .. formattedBlockingPercentage .. " %" .. BT.colorEnd)
end


function BT.addOnLoaded(_, name)
	if name == BT.name then
		BT:Initialize()
		EVENT_MANAGER:UnregisterForEvent(BT.name, EVENT_ADD_ON_LOADED)
	end
end

EVENT_MANAGER:RegisterForEvent(BT.name, EVENT_ADD_ON_LOADED, BT.addOnLoaded)