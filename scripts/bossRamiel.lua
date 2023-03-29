Mission_RamielBoss = Mission_Boss:new{
	Name = "Ramiel",
	BossPawn = "EVA_RamielBoss",
	SpawnStartMod = -2,
	BossText = "Destroy the Angel Ramiel",
	islandLock = 3,
}
--IslandLocks.Mission_SwarmerBoss = 3

EVA_RamielBoss = Pawn:new{
	Name = "Ramiel",
	Health = 9,
	MoveSpeed = 3,
	Ranged=1,
	Image = "EVA_RamielBoss",
	--ImageOffset = 2,
	SkillList = { "EVA_RamielBossAtk1" },	--I also want the reflexive shot thing, since that's a big part of its battle in the anime
	SoundLocation = "/enemy/goo_boss/",
	Flying = true,
	Portrait = "enemy/EVA_RamielBoss",
	ImpactMaterial = IMPACT_METAL,			--yes, I know it has blood and all
	Tier = TIER_BOSS,
	Massive=true,
	Corpse=false,
	DefaultTeam = TEAM_ENEMY,
}
AddPawnName("EVA_RamielBoss")

local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
LOG(resourcePath)
local writepath = "img/units/aliens/"
local readpath = resourcePath .. writepath
local imagepath = writepath:sub(5,-1)
local a = ANIMS

modApi:appendAsset("img/units/aliens/EVA_RamielBoss.png", readpath.."EVA_RamielBoss.png")
modApi:appendAsset("img/units/aliens/EVA_RamielBossa.png", readpath.."EVA_RamielBossa.png")
modApi:appendAsset("img/units/aliens/EVA_RamielBoss_emerge.png", readpath.."EVA_RamielBoss_emerge.png")
modApi:appendAsset("img/units/aliens/EVA_RamielBoss_death.png", readpath.."EVA_RamielBoss_death.png")

local base = a.EnemyUnit:new{Image = "units/aliens/EVA_RamielBoss.png", PosX = -23, PosY = -16, Height = 1}	--, PosX = -23, PosY = -16
local baseEmerge = a.BaseEmerge:new{Image = "units/aliens/EVA_RamielBoss_emerge.png", NumFrames = 10, Height = 1}

a.EVA_RamielBoss = base
a.EVA_RamielBosse = baseEmerge
a.EVA_RamielBossa = base:new{ Image = "units/aliens/EVA_RamielBossa.png", NumFrames = 11, PosX = -23, PosY = -16, Height = 1 }
a.EVA_RamielBossd = base:new{ Image = "units/aliens/EVA_RamielBoss_death.png", Loop = false, NumFrames = 10, Time = .15, Height = 1 }

EVA_RamielBossAtk1 = LaserDefault:new{
	Name = "Particle Beam",
	Description = "Obliterate everything in a direction with a powerful particle beam. Only stopped by mountains and energy shields.",
	Icon = "weapons/RamielParticleBeam.png",
	Class = "Enemy",
	PathSize = 1,
	Damage = 5,
	MinDamage=5,	
	Push = 0,
	TipImage = {
		CustomPawn = "EVA_RamielBoss",
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Target = Point(2,1),
	}
}

function EVA_RamielBossAtk1:AddLaser(ret,point,direction,queued,forced_end)
	local queued = queued or false
	local minDamage = self.MinDamage or 1
	local damage = self.Damage
	local start = point - DIR_VECTORS[direction]
	while Board:IsValid(point) do
		
		local dam = SpaceDamage(point, damage)
		local pawn = Board:GetPawn(point)
		-- if it's the end of the line (ha), add the laser art -- not pretty
		if forced_end == point or (Board:IsBuilding(point) and Board:IsShield(point)) or (pawn and pawn:IsShield()) or Board:GetTerrain(point) == TERRAIN_MOUNTAIN or not Board:IsValid(point + DIR_VECTORS[direction]) then
		--unlike LaserBase's version, this goes through unshielded buildings, but stops on shielded pawns; stil stopped by mountains 
			if queued then 
				ret:AddQueuedProjectile(dam,self.LaserArt)
			else
				ret:AddProjectile(start,dam,self.LaserArt,FULL_DELAY)
			end
			break
		else
			if queued then
				ret:AddQueuedDamage(dam)  
			else
				ret:AddDamage(dam)   --JUSTIN TEST
			end
		end
		
		damage = damage - 1
		if damage < minDamage then damage = minDamage end
					
		point = point + DIR_VECTORS[direction]	
	end
end