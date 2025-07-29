local BT = BlockingTime


function BT.combatState()
	local preCombatState = BT.isCombat
	BT.isCombat = IsUnitInCombat('player')

	if BT.isCombat == true and preCombatState == false then
		EVENT_MANAGER:RegisterForUpdate("BlockingTimeUpdate", 100, function() BT:updateBlockTime() end)
		BT.isBlocking = false
		BT.blockedTime = 0
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
		BT.blockedTime = BT.blockedTime + deltaTime
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


function BT.colorHex(value)
	local r, g, b
	value = math.max(0, math.min(100, value))

	if value >= 75 then
		local segmentValue = value - 75
		local factor = segmentValue / 25
		r = 255
		g = math.floor(127 * (1 - factor))
		b = 0
	elseif value >= 50 then
		local segmentValue = value - 50
		local factor = segmentValue / 25
		r = 255
		g = math.floor(255 - (128 * factor))
		b = 0
	elseif value >= 25 then
		local segmentValue = value - 25
		local factor = segmentValue / 25
		r = math.floor(127 + (128 * factor))
		g = 255
		b = 0
	else
		local segmentValue = value
		local factor = segmentValue / 25
		r = math.floor(127 * factor)
		g = 255
		b = 0
	end

	return "|c" .. string.format("%02x%02x%02x", r, g, b)
end


function BT:reportBlockStats()
	BT.groupRole = GetGroupMemberSelectedRole('player')

	if BT.sVar.isEnabled == false then
		return
	elseif BT.groupRole == 2 and BT.sVar.isEnabledTank == false then
		return
	elseif BT.groupRole == 4 and BT.sVar.isEnabledHeal == false then
		return
	elseif BT.groupRole == 1 and BT.sVar.isEnabledDD == false then
		return
	elseif BT.groupRole == 0 and BT.sVar.isEnabledSolo == false then
		return
	end

	local fightDuration = GetGameTimeMilliseconds() - BT.fightStartTime

	if fightDuration < (BT.sVar.minFightTime * 1000) then
		return
	end

	local blockedPercentage = 0
	if fightDuration > 0 then
		blockedPercentage = (BT.blockedTime / fightDuration) * 100
	end

	local fightDurationSeconds = fightDuration / 1000
	local blockedTimeSeconds = BT.blockedTime / 1000

	local formattedFightDuration = BT.formatDuration(fightDurationSeconds)
	local formattedBlockedTime = BT.formatDuration(blockedTimeSeconds)
	local formattedblockedPercentage = string.format("%.1f", blockedPercentage)

	BT.GRAD = BT.colorHex(string.format("%.0f", blockedPercentage))
	d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.WH .. " Fight Duration: " .. formattedFightDuration .. " - Blocked: " .. formattedBlockedTime .. " - " .. BT.col.End .. BT.GRAD .. formattedblockedPercentage .. " %" .. BT.col.End)
end