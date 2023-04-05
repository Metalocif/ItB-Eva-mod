
-- init.lua is the entry point of every mod

local mod = {
	id = "Metalocif_Evangelion",
	name = "Evangelion Mod",
	version = "0",
	requirements = {},
	dependencies = { --This requests modApiExt from the mod loader
		modApiExt = "1.17", --We can get this by using the variable `modapiext`
		memedit = "1.0.1",
	},
	modApiVersion = "2.8.3",
	icon = "img/mod_icon.png"
}

function mod:init()
	-- look in template/mech to see how to code mechs.
	require(self.scriptPath .."weapons")
	require(self.scriptPath .."pawns")
	require(self.scriptPath .."libs/boardEvents")
	require(self.scriptPath .."bossList")
	require(self.scriptPath .."bossRamiel")
	require(self.scriptPath .."bossLeliel")
	require(self.scriptPath .."bossSeries")
	--require(self.scriptPath .."bossSachiel")
end

function mod:load( options, version)
	-- after we have added our mechs, we can add a squad using them.
	modApi:addSquad(
		{
			"NERV Unit",-- title
			"EVA_Unit_00",-- mech #2
			"EVA_Unit_01",-- mech #1
			"EVA_Unit_02",-- mech #3
			id="Metalocif_Evangelion_Squad"
		},
		"Evangelions",
		"The Evangelions, multipurpose decisive weapon platforms.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
