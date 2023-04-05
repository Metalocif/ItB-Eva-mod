Mission_EVASeriesBoss = Mission_Boss:new{
	Name = "Eva Series",
	BossPawn = "EVASeriesBoss",
	SpawnStartMod = -4,
	BossText = "Destroy the Eva Series",
}

function Mission_EVASeriesBoss:StartMission()
	self:StartBoss()
	local ret = SkillEffect()
	local point = Board:GetPawn(self.BossID):GetSpace()
	local vicinity = extract_table(general_DiamondTarget(point,4))
	local spawnPoints = {}
	local backup = {}
	for i,v in ipairs(vicinity) do
		if not Board:IsBlocked(v,PATH_GROUND) and
				v ~= point	then
			
			if point:Manhattan(v) > 2 then
				backup[#backup + 1] = v
			else
				spawnPoints[#spawnPoints + 1] = v
				--LOG("Valid target = "..spawnPoints[#spawnPoints]:GetString())
			end
			
		end
	end
	
	local spawn_amount = 1 + GetSector()
		
	for i = 1, spawn_amount do
		local location
		-- local damage = SpaceDamage(0)
		if #spawnPoints ~= 0 then
			location = random_removal(spawnPoints)
		elseif #backup ~= 0 then
			location = random_removal(backup)
		else
			ret:AddScript("Board:AddAlert("..point:GetString()..",\"Alert_BlobSpawn\")")
			break
		end
		
		-- damage.sPawn = "EVASeriesBoss"
		-- ret:AddDamage(damage)
		Board:AddPawn("EVASeriesBoss",location)
		
	end
end

EVASeriesBoss = Pawn:new{
	Name = "Eva Series",
	Health = 6,
	MoveSpeed = 4,
	Ranged=1,
	Image = "EVASeriesBoss",
	--ImageOffset = 2,
	SkillList = { "EVASeriesBossAtk1" },	
	SoundLocation = "/enemy/goo_boss/",
	Flying = false,
	IsDeathEffect = true,
	Portrait = "enemy/EVASeriesBoss",
	ImpactMaterial = IMPACT_FLESH,			
	Tier = TIER_BOSS,
	Massive=true,
	Corpse=false,
	DefaultTeam = TEAM_ENEMY,
	DeathSpawn = "EVASeriesCorpse"
}
AddPawnName("EVASeriesBoss")
function EVASeriesBoss:GetCustomPositionScore(point) 
	local result
	if Game:GetTurnCount() <= 2 then return 0 end

	--for each direction, look for a mech we can hit, if we find one we can kill do so, otherwise keep looking
	for dir = DIR_START, DIR_END do
		for i = 1, 7 do
			local curr = p1 + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then break end
			if Board:GetPawn(curr) and Board:GetPawn(curr):IsMech() then
				if Board:GetPawn(curr):GetHealth() <= 2 then return 10 else result = 5 end
			end
			if Board:IsBlocked(PATH_PROJECTILE) then break end

		end
	end
	return result
end

local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
LOG(resourcePath)
local writepath = "img/units/aliens/"
local readpath = resourcePath .. writepath
local imagepath = writepath:sub(5,-1)
local a = ANIMS

modApi:appendAsset("img/units/aliens/EVASeriesBoss.png", readpath.."EVASeriesBoss.png")
modApi:appendAsset("img/units/aliens/EVASeriesBossa.png", readpath.."EVASeriesBossa.png")
modApi:appendAsset("img/units/aliens/EVASeriesBoss_emerge.png", readpath.."EVASeriesBoss_emerge.png")
modApi:appendAsset("img/units/aliens/EVASeriesBoss_death.png", readpath.."EVASeriesBoss_death.png")
modApi:appendAsset("img/units/aliens/EVASeriesCorpse.png", readpath.."EVASeriesCorpse.png")
modApi:appendAsset("img/units/aliens/EVASeriesCorpse_death.png", readpath.."EVASeriesCorpse_death.png")

local base = a.EnemyUnit:new{Image = "units/aliens/EVASeriesBoss.png", PosX = -23, PosY = -16, Height = 1}	
local baseEmerge = a.BaseEmerge:new{Image = "units/aliens/EVASeriesBoss_emerge.png", NumFrames = 4, Height = 1}

a.EVASeriesBoss = base
a.EVASeriesBosse = baseEmerge
a.EVASeriesBossa = base:new{ Image = "units/aliens/EVASeriesBossa.png", NumFrames = 4, PosX = -23, PosY = -16, Height = 1 }
a.EVASeriesBossd = base:new{ Image = "units/aliens/EVASeriesBoss_death.png", Loop = false, NumFrames = 4, Time = .15, Height = 1 }
a.EVASeriesCorpse = a.EnemyUnit:new{Image = "units/aliens/EVASeriesCorpse.png", PosX = -23, PosY = -16, Height = 1}
a.EVASeriesCorpsed = a.EnemyUnit:new{Image = "units/aliens/EVASeriesCorpse_death.png", Loop = false, NumFrames = 5, Time = .15, PosX = -23, PosY = -16, Height = 1}	

--need a corpse death anim where it turns to LCL or something, not super canon-friendly but w/e

modApi:appendAsset("img/portraits/enemy/EVASeriesBoss.png", resourcePath.."img/portraits/enemy/EVASeriesBoss.png")

local effects = {
	"replica_R.png",
	"replica_U.png",
	"shotup_replica.png"
}
for _, effect in ipairs(effects) do
	modApi:appendAsset("img/effects/".. effect, resourcePath .. "img/effects/" .. effect)
end



EVASeriesBossAtk1 = Skill:new{
	Name = "Heavy Sword",	
	Description = "Strikes at adjacent tiles with a massive blade.",	--note it will turn into a replica after turn 2
	Icon = "weapons/EVASeriesHeavySword.png",
	Class = "Enemy",
	PathSize = 1,
	Damage = 3,	
	Push = 0,
	-- ScoreEnemy = 5,
	-- ScoreFriendlyDamage = -2,
	-- ScoreBuilding = 5,
	-- ScoreNothing = 0,
	--the above is the default values
	TipImage = {
		CustomPawn = "EVASeriesBoss",
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Target = Point(2,1),
	}
}

EVASeriesBossAtk2 = Skill:new{
	Name = "Replica",		--not sure about the name
	Description = "An unpredictable weapon that pierces shields.",	--visually returns to the sender as artillery
	Icon = "weapons/EVASeriesReplica.png",
	Class = "Enemy",
	PathSize = 1,
	Range = RANGE_PROJECTILE,
	Damage = 2,	
	Push = 0,
	ScoreEnemy = 5,
	ScoreFriendlyDamage = -2,
	ScoreBuilding = 4,		
	--basically they focus on mechs after turn 2
	--their attack is not queued
	--boost HP prior to going into the mission or get oneshotted
	--might make it prefer low HP mechs as well
	ScoreNothing = 0,
	ProjectileArt = "effects/replica",
	TipImage = {
		CustomPawn = "EVASeriesBoss",
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Target = Point(2,3),
	}
}

function EVASeriesBossAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	ret:AddQueuedDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], self.Damage))
	ret:AddQueuedDamage(SpaceDamage(p2 - DIR_VECTORS[(direction + 1)% 4], self.Damage))
	local damage = SpaceDamage(p2, self.Damage)
	damage.sAnimation = "explosword_"..direction
	ret:AddQueuedDamage(damage)
	if Game:GetTurnCount() >= 2 then
		ret:AddQueuedScript(string.format("Board:GetPawn(%s):RemoveWeapon(1)", Board:GetPawn(p1):GetId()))
		ret:AddQueuedScript(string.format("Board:GetPawn(%s):AddWeapon(\"EVASeriesBossAtk2\")", Board:GetPawn(p1):GetId()))
	end
	--could also hook; this won't replace their weapon until they attack, so it's weird if they are smoked/in water on turn 2
	return ret
end
--issues: 
--they are not ranged units, so they use the replica in melee, which is weird

function EVASeriesBossAtk2:GetSkillEffect(p1,p2)
	--not queued, otherwise a very normal attack
	local ret = SkillEffect()
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	local damage = SpaceDamage(target, self.Damage)
	if Board:GetPawn(target) then ret:AddScript(string.format("Board:GetPawn(%s):SetShield(false)", Board:GetPawn(target):GetId())) end
	ret:AddProjectile(damage, self.ProjectileArt)
	damage.loc = p1
	damage.iDamage = 0
	damage.bHide = true
	--ret:AddDelay(0.5)
	ret:AddArtillery(target, damage, "effects/shotup_replica.png")	--just so the replica visually returns to the user
	return ret
end

function EVASeriesBoss:GetDeathEffect(point)
	--they revive like in EoE
	local ret = SkillEffect()
	
	if self.DeathSpawn == "" then return ret end
	local damage = SpaceDamage(point, 0)
	
	damage.sPawn = self.DeathSpawn
	ret:AddDamage(damage)
	
	
	return ret
end

EVASeriesCorpse = Pawn:new{
	Name = "Eva Series Corpse",
	Health = 1,
	MoveSpeed = 0,
	Image = "EVASeriesCorpse",
	--ImageOffset = 2,
	SkillList = { "EVASeriesRevival" },	
	SoundLocation = "/enemy/goo_boss/",
	Flying = false,
	Portrait = "enemy/EVASeriesBoss",
	ImpactMaterial = IMPACT_FLESH,			
	Tier = TIER_BOSS,
	Massive=true,
	Corpse=false,
	DefaultTeam = TEAM_ENEMY,
}

EVASeriesRevival = Skill:new{
	Name = "Revival",	
	Description = "Revives.",
	Icon = "weapons/EVASeriesHeavySword.png",
	Class = "Enemy",
	PathSize = 1,
	Damage = 0,	
	Push = 0,
	-- ScoreEnemy = 5,
	-- ScoreFriendlyDamage = -2,
	-- ScoreBuilding = 5,
	-- ScoreNothing = 0,
	--the above is the default values
	TipImage = {
		CustomPawn = "EVASeriesCorpse",
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Target = Point(2,2),
	}
}

function EVASeriesRevival:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	--add a reversed death animation; more interesting if the death anim looks decent
	ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(-1000, -1000)", Board:GetPawn(p1):GetId()))
	ret:AddScript(string.format("Board:AddPawn(\"EVASeriesBoss\", %s", p1:GetString()))
	ret:AddScript(string.format("Board:GetPawn(%s):SetHealth(5)", Board:GetPawn(p1):GetId()))
	ret:AddScript(string.format("Board:GetPawn(%s):SetActive(true)", Board:GetPawn(p1):GetId()))
	if Game:GetTurnCount() >= 2 then
		ret:AddScript(string.format("Board:GetPawn(%s):RemoveWeapon(1)", Board:GetPawn(p1):GetId()))
		ret:AddScript(string.format("Board:GetPawn(%s):AddWeapon(\"EVASeriesBossAtk2\")", Board:GetPawn(p1):GetId()))
	end
	--could also hook; this won't replace their weapon until they attack, so it's weird if they are smoked/in water on turn 2
	return ret
end

--revive, setactive, take one HP off, and set the Replica on