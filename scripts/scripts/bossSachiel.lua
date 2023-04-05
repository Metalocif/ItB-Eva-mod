Mission_SachielBoss = Mission_Boss:new{
	Name = "Sachiel",
	-- islandLock = 3,
	BossPawn = "SachielBoss",
	SpawnStartMod = -3,
	BossText = "Destroy the Angel Sachiel",
}

SachielBoss = {
	Health = 15,
	MoveSpeed = 4,
	Image = "beetle",
	ImageOffset = 2,
	SkillList = { "Sachiel_Punch" },
	Ranged = 0,
	SoundLocation = "/enemy/beetle_1/",
	Massive = true,
	IsDeathEffect = true,
	ImpactMaterial = IMPACT_FLESH,
	DefaultTeam = TEAM_ENEMY,
	Portrait = "enemy/BeetleB",
	Tier = TIER_BOSS,
}
AddPawn("SachielBoss") 

Sachiel_Punch = Prime_Punchmech:new{  
	Class = "Enemy",
	Icon = "weapons/prime_punchmech.png",
	LaunchSound = "/weapons/titan_fist",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 5,
	PushBack = false,
	Flip = false,
	Dash = false,
	Shield = false,
	Projectile = false,
	Push = 0,
	TipImage = StandardTips.Melee
}

function SachielBoss:GetDeathEffect(point)
	local ret = SkillEffect()
	local damage = SpaceDamage(point,2)
	damage.sAnimation = "ExploAir2"
	ret:AddDamage(damage)
	for dir = DIR_START, DIR_END do
		damage.loc = point + DIR_VECTORS[dir]
		ret:AddDamage(damage)
		damage.loc = point + DIR_VECTORS[dir] * 2
		ret:AddDamage(damage)
	end
	return ret
end

local hook = function(mission, pawn, isShield)
	if pawn:GetId() == "SachielBoss" and not isShield then
		pawn:SetShield(true)
		Board:AddAlert(space,"A.T. FIELD ACTIVE")
		--we also want to say "if is Angel and not adjacent to an EVA"
	end
end

modApiExt:addPawnIsShieldedHook(hook)