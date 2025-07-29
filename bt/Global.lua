BlockingTime = {
	name = "BlockingTime",
	author = "@Duesentrieb",
	version = "20250729-2306",
	chat = "[Blocking Time]",
	slash	= "/bt",

	blockingTime = 0,
	fightStartTime = 0,
	fightUpdateTime = 0,
	groupRole = 0,
	isCombat = false,
	isBlocking = false,

	default = {
		isEnabled = true,
		isEnabledSolo = true,
		isEnabledTank = true,
		isEnabledHeal = true,
		isEnabledDD = true,
		minFightTime = 0
	},

	col = {
		OG = "|cff7f00",
		WH = "|cffffff",
		GN = "|c00ff00",
		RD = "|cff0000",
		GRAD = "|cff7f00",
		End = "|r"
	},

	sVar = {},
	sVarVersion = 1,
	sVarName = "BlockingTimeVariables",

	varAddonPanel = nil,
	isLoaded = false
}