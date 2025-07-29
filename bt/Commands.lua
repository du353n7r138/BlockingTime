local BT = BlockingTime
local LAM2 = LibAddonMenu2


function BT.slashCommand(txt)
	txt = txt or ""
	local number = tonumber(txt)
	txt = string.lower(txt)

	if txt == "" then
		if BT.sVar.isEnabled == true then
			txt = "off"
		else
			txt = "on"
		end
	end

	if txt == "help" then
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.GN .. " Help / Options" .. BT.col.End)
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.WH .. " Enable / Disable The Addon:" .. BT.col.End .. BT.col.OG .. " " .. BT.slash .. " on" .. BT.col.End .. BT.col.WH .. " or" .. BT.col.End .. BT.col.OG .. " off" .. BT.col.End)
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.WH .. " See a list of slash commands:" .. BT.col.End .. BT.col.OG .. " " .. BT.slash .. " help" .. BT.col.End)
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.WH .. " Open the Settings Menu:" .. BT.col.End .. BT.col.OG .. " " .. BT.slash .. " menu" .. BT.col.End)

	elseif txt == "on" then
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.GN .. " Addon Enabled" .. BT.col.End)
		BT.sVar.isEnabled = true

	elseif txt == "off" then
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.RD .. " Addon Disabled" .. BT.col.End)
		BT.sVar.isEnabled = false

	elseif txt == "menu" then
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.GN .. " Open: Controls > Addons > [BT]" .. BT.col.End)
		LAM2:OpenToPanel(BT.varAddonPanel)
	else
		d(BT.col.OG .. BT.chat .. BT.col.End .. BT.col.RD .. "Unknown Command! Type " .. BT.slash .. " help" .. BT.col.End)
	end
end

SLASH_COMMANDS[BT.slash] = BT.slashCommand