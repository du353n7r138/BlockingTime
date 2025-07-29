local BT = BlockingTime


function BT:Initialize()
	BT.sVar = ZO_SavedVars:NewAccountWide(BT.sVarName, BT.sVarVersion, nil, BT.default)
	EVENT_MANAGER:RegisterForEvent("BlockingTime", EVENT_PLAYER_COMBAT_STATE, BT.combatState)
	BT.createSettingsWindow()
	ZO_CreateStringId("SI_BINDING_NAME_BT_TOGGLE", "Toggle")
	BT.isLoaded = true
	d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.WH .. " AddOn loaded and initialized." .. BT.col.End)
end


function BT.addOnLoaded(_, name)
	if name == BT.name then
		BT:Initialize()
		EVENT_MANAGER:UnregisterForEvent(BT.name, EVENT_ADD_ON_LOADED)
	end
end

EVENT_MANAGER:RegisterForEvent(BT.name, EVENT_ADD_ON_LOADED, BT.addOnLoaded)