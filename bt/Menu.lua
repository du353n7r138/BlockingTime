local BT = BlockingTime
local LAM2 = LibAddonMenu2


function BT.createSettingsWindow()
	local panelData = {
		type = "panel",
		name = "[BT] Blocking Time",
		displayName = BT.col.OG .. "[BT] Blocking" .. BT.col.End .. BT.col.WH .. " Time" .. BT.col.End,
		author = BT.col.OG .. BT.author .. BT.col.End .. BT.col.WH .. " [EU]" .. BT.col.End,
		version = BT.col.OG .. BT.version .. BT.col.End,
		registerForRefresh = true
	}

	local optionsData = {
		{
			type = "header",
			name = BT.col.OG .. "General Options" .. BT.col.End
		},
		{
			type = 	"description",
			text = 	"Set a custom" .. BT.col.OG .. " keybind" .. BT.col.End .. " through Controls > Addons > [BT].\n" ..
					"Type " .. BT.col.OG .. BT.slash .. BT.col.End .. " in chat to quickly toggle the" .. BT.col.End .. BT.col.OG .. " entire addon" .. BT.col.End .. " on or off.\n" ..
					"Type " .. BT.col.OG .. BT.slash .. " help" .. BT.col.End .. " in chat to see additionally slash commands.\n" ..
					"Type " .. BT.col.OG .. BT.slash .. " menu" .. BT.col.End .. " in chat to open this setup page.",
			width = "full"
		},
		{
			type = "checkbox",
			name = "MASTERSWITCH (Turns the entire addon ON/OFF)",
			tooltip = "Enables or disables all features of the addon. If disabled, no blocking time will be tracked or reported.",
			getFunc = function() return BT.sVar.isEnabled end,
			setFunc = function(value)
				BT.sVar.isEnabled = value
				if value == true then
					d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.GN .. " Addon Enabled" .. BT.col.End)
					EVENT_MANAGER:RegisterForEvent(BT.name, EVENT_PLAYER_COMBAT_STATE, BT.combatState)
				else
					d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.RD .. " Addon Disabled" .. BT.col.End)
					EVENT_MANAGER:UnregisterForEvent(BT.name, EVENT_PLAYER_COMBAT_STATE)
                    EVENT_MANAGER:UnregisterForUpdate("BlockingTimeUpdate")
				end
			end,
			width = "full"
		},
		{
			type = "slider",
			name = "Minimum Fight Time (Seconds)",
			tooltip = "Sets the minimum duration a fight must last (in seconds) for blocking statistics to be reported in chat. Fights shorter than this will not be reported.",
			min = 0,
			max = 120,
			step = 5,
			default = 0,
			getFunc = function() return BT.sVar.minFightTime end,
			setFunc = function(value) BT.sVar.minFightTime = value end,
			disabled = function() return not BT.sVar.isEnabled end,
			width = "full"
		},
		{
			type = "divider"
		},
		{
			type = "checkbox",
			name = "Enable for Tanks",
			tooltip = "Activates blocking time tracking and reporting when you are playing as a Tank.",
			getFunc = function() return BT.sVar.isEnabledTank end,
			setFunc = function(value) BT.sVar.isEnabledTank = value end,
			disabled = function() return not BT.sVar.isEnabled end,
			width = "full"
		},
		{
			type = "checkbox",
			name = "Enable for Heals",
			tooltip = "Activates blocking time tracking and reporting when you are playing as a Healer.",
			getFunc = function() return BT.sVar.isEnabledHeal end,
			setFunc = function(value) BT.sVar.isEnabledHeal = value end,
			disabled = function() return not BT.sVar.isEnabled end,
			width = "full"
		},
		{
			type = "checkbox",
			name = "Enable for DPS",
			tooltip = "Activates blocking time tracking and reporting when you are playing as Damage Dealer (DPS).",
			getFunc = function() return BT.sVar.isEnabledDD end,
			setFunc = function(value) BT.sVar.isEnabledDD = value end,
			disabled = function() return not BT.sVar.isEnabled end,
			width = "full"
		},
		{
			type = "checkbox",
			name = "Enable for Solo",
			tooltip = "Activates blocking time tracking and reporting when you are playing Solo (not in group).",
			getFunc = function() return BT.sVar.isEnabledSolo end,
			setFunc = function(value) BT.sVar.isEnabledSolo = value end,
			disabled = function() return not BT.sVar.isEnabled end,
			width = "full"
		},
		{
			type = "divider"
		},
		{
			type = "description",
			text = "If you enjoy " .. BT.col.OG .. "Blocking Time" .. BT.col.End .. ", consider sharing your feedback or supporting its development. Your input and contributions are greatly appreciated!",
			width = "full"
		},
		{
			type = "button",
			name = "Feedback / Donate",
			tooltip = "Opens a mail to send feedback or donate to the author. <3",
			func = function()
				SCENE_MANAGER:Show('mailSend')
				zo_callLater(function()
					ZO_MailSendToField:SetText(BT.author)
					ZO_MailSendSubjectField:SetText("Blocking Time")
					ZO_MailSendBodyField:TakeFocus()
				end, 250)
			end,
			width = "full"
		}
	}
	BT.varAddonPanel = LAM2:RegisterAddonPanel(BlockingTime.name .. "Menu", panelData)
	LAM2:RegisterOptionControls(BlockingTime.name .. "Menu", optionsData)
end