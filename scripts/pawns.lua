-- add color palette
local pathScripts = mod_loader.mods[modApi.currentMod].scriptPath
modApi:addPalette({
		ID = "EVA_Unit_00_palette",
		Name = "Unit 00 Paintjob",
		PlateHighlight = {168, 119, 200},	--lights
		PlateLight     = {245, 158, 5},		--main highlight
		PlateMid       = {221, 75, 6},	--main light
		PlateDark      = {150, 75, 0},		--main mid  {130, 93, 39}
		PlateOutline   = {10, 10, 10},		--main dark
		PlateShadow    = {0, 0, 0},		--metal dark
		BodyColor      = {177, 185, 217},		--metal mid
		BodyHighlight  = {250, 250, 250},	--metal light
})
local palette0 = modApi:getPaletteImageOffset("EVA_Unit_00_palette")
modApi:addPalette({
		ID = "EVA_Unit_01_palette",
		Name = "Unit 01 Paintjob",
		PlateHighlight = {168, 119, 200},	--lights
		PlateLight     = {97, 46, 105},		--main highlight
		PlateMid       = {133, 55, 152},	--main light
		PlateDark      = {56, 34, 78},		--main mid
		PlateOutline   = {9, 22, 27},		--main dark
		PlateShadow    = {0, 0, 0},		--metal dark
		BodyColor      = {107, 127, 173},		--metal mid
		BodyHighlight  = {162, 218, 90},	--metal light
})
local palette1 = modApi:getPaletteImageOffset("EVA_Unit_01_palette")
modApi:addPalette({
		ID = "EVA_Unit_02_palette",
		Name = "Unit 02 Paintjob",
		PlateHighlight = {10, 150, 200},	--lights
		PlateLight     = {252, 56, 40},		--main highlight
		PlateMid       = {252, 56, 40},	--main light
		PlateDark      = {120, 30, 30},		--main mid
		PlateOutline   = {9, 22, 27},		--main dark
		PlateShadow    = {0, 0, 0},		--metal dark
		BodyColor      = {240, 135, 20},		--metal mid
		BodyHighlight  = {168, 119, 200},	--metal light
})
local palette2 = modApi:getPaletteImageOffset("EVA_Unit_02_palette")

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-------------------
-- Cyborg Pilots --
-------------------

local names = {
	"EVA_Unit_00",
	"EVA_Unit_01",
	"EVA_Unit_02",
}
local oldGetSkillInfo = GetSkillInfo
function GetSkillInfo(skill)
	-- if IsEvaOne then
		-- IsEvaOne = nil
		-- if skill == "Survive_Death"    then
			-- return PilotSkill("Third Child", "Normal Pilots cannot be equipped. Loses 25 XP when the unit is disabled.")
		-- end
	-- elseif IsEvaTwo then
		-- IsEvaTwo = nil
		-- if skill == "Survive_Death"    then
			-- return PilotSkill("Second Child", "Normal Pilots cannot be equipped. Loses 25 XP when the unit is disabled.")
		-- end
	-- elseif IsEvaZero then
		-- IsEvaZero = nil
		-- if skill == "Survive_Death"    then
			-- return PilotSkill("First Child", "Normal Pilots cannot be equipped. Loses 25 XP when the unit is disabled.")
		-- end
	-- end
	if IsEva then
		if skill == "Survive_Death"    then
			return PilotSkill("Evangelion Pilot", "Normal Pilots cannot be equipped. Loses 25 XP when the unit is disabled.")
		end
	end
	return oldGetSkillInfo(skill)
end

	modApi:appendAsset("img/portraits/pilots/Pilot_EVA_Unit_00.png",path.."img/portraits/pilots/Pilot_EVA_Unit_00.png")
	CreatePilot{
		Id = "Pilot_EVA_Unit_00",
		Name = "Rei",
		Personality = "Vek",	--I'll ask ChatGPT later
		Sex = SEX_VEK,
		Rarity = 0,
		-- GetSkill = function() IsEvaZero = true; return "Survive_Death" end,
		GetSkill = function() IsEva = true; return "Survive_Death" end,
		Blacklist = {"Invulnerable", "Popular"},
	}
	modApi:appendAsset("img/portraits/pilots/Pilot_EVA_Unit_01.png",path.."img/portraits/pilots/Pilot_EVA_Unit_01.png")
	CreatePilot{
		Id = "Pilot_EVA_Unit_01",
		Name = "Shinji",
		Personality = "Vek",	--I'll ask ChatGPT later
		Sex = SEX_VEK,
		Rarity = 0,
		-- GetSkill = function() IsEvaOne = true; return "Survive_Death" end,
		GetSkill = function() IsEva = true; return "Survive_Death" end,
		Blacklist = {"Invulnerable", "Popular"},	--ahahah baka Shinji is not popular
	}
	modApi:appendAsset("img/portraits/pilots/Pilot_EVA_Unit_02.png",path.."img/portraits/pilots/Pilot_EVA_Unit_02.png")
	CreatePilot{
		Id = "Pilot_EVA_Unit_02",
		Name = "Asuka",
		Personality = "Vek",	--I'll ask ChatGPT later
		Sex = SEX_VEK,
		Rarity = 0,
		-- GetSkill = function() IsEvaTwo = true; return "Survive_Death" end,
		GetSkill = function() IsEva = true; return "Survive_Death" end,
		Blacklist = {"Invulnerable", "Popular"},
	}
--------------
-- Unit 01 ---
--------------

-- locate our mech assets.

-- make a list of our files.
local files = {
	"eva00.png",
	"eva00_a.png",
	"eva00_w.png",
	"eva00_broken.png",
	"eva00_w_broken.png",
	"eva00_ns.png",
	"eva00_h.png",
	"eva01.png",
	"eva01_a.png",
	"eva01_w.png",
	"eva01_broken.png",
	"eva01_w_broken.png",
	"eva01_ns.png",
	"eva01_h.png",
	"eva02.png",
	"eva02_a.png",
	"eva02_w.png",
	"eva02_broken.png",
	"eva02_w_broken.png",
	"eva02_ns.png",
	"eva02_h.png",
}
local mechFilesEnd = {
	".png",
	"_a.png",
	"_w.png",
	"_broken.png",
	"_w_broken.png",
	"_ns.png",
	"_h.png"
}

-- iterate our files and add the assets so the game can find them.
for _, file in ipairs(mechFilesEnd) do
	--modApi:appendAsset("img/units/player/".. file, path .."img/units/player/" .. file)
	for i = 0,2 do
		modApi:appendAsset("img/units/player/eva0"..i.. file, path .."img/units/player/eva0"..i .. file)
	
	
	end
end

-- create animations for our mech with our imported files.
-- note how the animations starts searching from /img/
local a = ANIMS
a.EVA_Unit_00 =				a.MechUnit:new{Image = "units/player/eva00.png", PosX = -33, PosY = -26 }
a.EVA_Unit_00a =			a.MechUnit:new{Image = "units/player/eva00_a.png", PosX = -33, PosY = -26, NumFrames = 4 }
a.EVA_Unit_00w =			a.MechUnit:new{Image = "units/player/eva00_w.png", PosX = -31, PosY = -15 }
a.EVA_Unit_00_broken =		a.MechUnit:new{Image = "units/player/eva00_broken.png", PosX = -33, PosY = -26 }
a.EVA_Unit_00w_broken =		a.MechUnit:new{Image = "units/player/eva00_w_broken.png", PosX = -31, PosY = -15 }
a.EVA_Unit_00_ns =			a.MechIcon:new{Image = "units/player/eva00_ns.png"}

a.EVA_Unit_01 =				a.MechUnit:new{Image = "units/player/eva01.png"}
a.EVA_Unit_01a =			a.MechUnit:new{Image = "units/player/eva01_a.png", PosX = -33, PosY = -26, NumFrames = 4 }
a.EVA_Unit_01w =			a.MechUnit:new{Image = "units/player/eva01_w.png", PosX = -31, PosY = -15 }
a.EVA_Unit_01_broken =		a.MechUnit:new{Image = "units/player/eva01_broken.png", PosX = -33, PosY = -26 }
a.EVA_Unit_01w_broken =		a.MechUnit:new{Image = "units/player/eva01_w_broken.png", PosX = -31, PosY = -15 }
a.EVA_Unit_01_ns =			a.MechIcon:new{Image = "units/player/eva01_ns.png"}

a.EVA_Unit_02 =				a.MechUnit:new{Image = "units/player/eva02.png", PosX = -33, PosY = -26 }
a.EVA_Unit_02a =			a.MechUnit:new{Image = "units/player/eva02_a.png", PosX = -33, PosY = -26, NumFrames = 4 }
a.EVA_Unit_02w =			a.MechUnit:new{Image = "units/player/eva02_w.png", PosX = -31, PosY = -15 }
a.EVA_Unit_02_broken =		a.MechUnit:new{Image = "units/player/eva02_broken.png", PosX = -33, PosY = -26 }
a.EVA_Unit_02w_broken =		a.MechUnit:new{Image = "units/player/eva02_w_broken.png", PosX = -31, PosY = -15 }
a.EVA_Unit_02_ns =			a.MechIcon:new{Image = "units/player/eva02_ns.png"}

EVA_Unit_00 = Pawn:new {
	Name = "Unit 00",
	Class = "TechnoVek",
	Health = 3,
	MoveSpeed = 3,
	Image = "EVA_Unit_00",
	ImageOffset = palette0,
	SkillList = { "EVA_SniperRifle" },
	SoundLocation = "/enemy/burnbug_2/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_FLESH,
	Massive = true,
}
AddPawnName("EVA_Unit_00")
EVA_Unit_01 = Pawn:new {
	Name = "Unit 01",
	Class = "TechnoVek",
	Health = 3,
	MoveSpeed = 4,
	Image = "EVA_Unit_01",
	ImageOffset = palette1,
	SkillList = { "EVA_ProgKnife" },
	SoundLocation = "/enemy/burnbug_2/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_FLESH,
	Massive = true,
}
AddPawnName("EVA_Unit_01")
EVA_Unit_02 = Pawn:new {
	Name = "Unit 02",
	Class = "TechnoVek",
	Health = 3,
	MoveSpeed = 4,
	Image = "EVA_Unit_02",
	ImageOffset = palette2,
	SkillList = { "EVA_SonicGlaive", "EVA_NeedleRacks" },
	SoundLocation = "/enemy/burnbug_2/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_FLESH,
	Massive = true,
}
AddPawnName("EVA_Unit_02")

local function EVENT_onModsLoaded()
	modApi:addPostLoadGameHook(HOOK_postLoadGameHook)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
