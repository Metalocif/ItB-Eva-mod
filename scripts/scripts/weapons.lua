-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- add assets from our mod so the game can find them.

local iconPath = path .."img/weapons/"

local files = {
	"EVA_ProgKnife.png",
	-- "EVA_SniperRifle.png",
	"EVA_NeedleRacks.png",
	"EVA_SonicGlaive.png",
	-- "EVA_LonginusSpear.png"
	"EVA_PositronRifle.png",
	-- "EVA_HeavySword.png" the EVA series' weapon
}

-- iterate our files and add the assets so the game can find them.
for _, file in ipairs(files) do
	modApi:appendAsset("img/weapons/".. file, iconPath .. file)
end

local effects = {
	"needle_R.png",
	"needle_U.png",
}
for _, effect in ipairs(effects) do
	modApi:appendAsset("img/effects/".. effect, path .. "img/effects/" .. effect)
end

--EVA weapons are massively overpowered because Angels are massively overpowered.
--This runs the risk of being overcentralizing but it is lore-accurate.
--There is also something to be said for the fantasy of Evangelion stomping bugs.
--Let the damn kids get a win for once!

--For real though, I'll make an option to balance their weapons for a no-Angels run.

--------------
--Prog Knife--
--------------

--based on the Knife used by everyone all the time
EVA_ProgKnife = Skill:new{
	Name = "Prog Knife",
	Description = "Use a quick knife to strike twice at adjacent targets. Can choose different targets.",
	Class = "TechnoVek",
	Rarity = 1,
	Icon = "weapons/EVA_ProgKnife.png",	
	Explosion = "",
	Damage = 2,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,2},
	Strikes = 1,
	PathSize = 1,
	UpgradeList = { "+1 Damage",  "Double Strikes"  },
	TwoClick = true,
	ZoneTargeting = ZONE_DIR,
	LaunchSound = "/weapons/sword",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(3,3),
		Target = Point(2,2),
		Second_Origin = Point(2,3),
		Second_Target = Point(3,3),
		Mountain = Point(0,3),
	}
}

EVA_ProgKnife_A = EVA_ProgKnife:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 3,
}

EVA_ProgKnife_B = EVA_ProgKnife:new{
	UpgradeDescription = "Strikes each target twice.",
	Strikes = 2,
}

EVA_ProgKnife_AB = EVA_ProgKnife:new{
	Damage = 3,
	Strikes = 2,
}

function EVA_ProgKnife:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[i]
		ret:push_back(curr)
	end
	return ret
end

function EVA_ProgKnife:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		ret:push_back(curr)
	end
	return ret
end


function EVA_ProgKnife:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage)
	for i = 1,self.Strikes do
		local animNumber = math.random(1,4)
		if animNumber <= 3 then
			damage.sAnimation="explospear"..animNumber.."_"..direction
		else
			damage.sAnimation="explosword"..direction
		end
		ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
		ret:AddDelay(0.2)
	end
	return ret
end

function EVA_ProgKnife:GetFinalEffect(p1,p2,p3)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local direction2 = GetDirection(p3 - p1)
	local damage = SpaceDamage(p2, self.Damage)
	for i = 1,self.Strikes do
		local animNumber = math.random(1,4)
		if animNumber <= 3 then
			damage.sAnimation="explospear"..animNumber.."_"..direction
		else
			damage.sAnimation="explosword_"..direction
		end
		ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
		ret:AddDelay(0.2)
	end
	damage.loc = p3
	for i = 1,self.Strikes do
		local animNumber = math.random(1,4)
		if animNumber <= 3 then
			damage.sAnimation="explospear"..animNumber.."_"..direction
		else
			damage.sAnimation="explosword_"..direction
		end
		ret:AddMelee(p3 - DIR_VECTORS[direction], damage)
		ret:AddDelay(0.2)
	end
	return ret
end

----------------
--Sonic Glaive--
----------------

--based on Asuka's weapon she uses to cleave Israfel in two
EVA_SonicGlaive = Skill:new{
	Name = "Sonic Glaive",
	Description = "Either slash targets in front, stab enemies at a 2-tiles range, or jump at an enemy.",
	Class = "TechnoVek",
	Rarity = 1,
	Icon = "weapons/EVA_SonicGlaive.png",	
	Explosion = "",
	Damage = 3,	   --damage dealt using the jump attack
	MinDamage = 2, --dealt by the other two modes; we use it for tooltip reasons
	PowerCost = 1,
	Upgrades = 2,
	UpgradeCost = {1,2},
	PathSize = 1,
	UpgradeList = { "+1 Damage",  "+2 Damage"  },
	ZoneTargeting = ZONE_DIR,
	LaunchSound = "/weapons/sword",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Enemy2 = Point(1,2),
		Enemy3 = Point(1,3),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(1,3),
		Mountain = Point(0,3),
	}
}
EVA_SonicGlaive_A = EVA_SonicGlaive:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 4,
	MinDamage = 3,
}

EVA_SonicGlaive_B = EVA_SonicGlaive:new{
	UpgradeDescription = "Increases damage by 2.",
	Damage = 5,
	MinDamage = 4,
}

EVA_SonicGlaive_AB = EVA_SonicGlaive:new{
	Damage = 6,
	MinDamage = 5,
}

function EVA_SonicGlaive:GetTargetArea(point)
	local ret = PointList()
	-- can target something in front to hit like a sword
	-- can target something 2 tiles away to hit like a spear
	-- can target something further away if it is a pawn and there is an empty tile in front
	for dir = DIR_START, DIR_END do
		for i = 1, 7 do
			local curr = point + DIR_VECTORS[dir] * i
			if not Board:IsValid(curr) then break end
			local prev = point + DIR_VECTORS[dir] * (i-1)
			local distance = point:Manhattan(curr)
			if distance <= 2 or Board:GetPawn(curr) and not Board:IsBlocked(prev, PATH_MASSIVE) then ret:push_back(curr) end
			--if the target is within two tiles, we can hit in melee
			--if it is further and there is a space we can walk in to jump into in front of target, that's fine too
		end
	end
	return ret
end

function EVA_SonicGlaive:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p2:Manhattan(p1)
	if distance == 1 then	--sword mode
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], self.MinDamage))
		ret:AddDamage(SpaceDamage(p2 - DIR_VECTORS[(direction + 1)% 4], self.MinDamage))
		local damage = SpaceDamage(p2, self.MinDamage)
		damage.sAnimation = "explosword_"..direction
		ret:AddDamage(damage)
	elseif distance == 2 then	--spear mode
		for i = 1, distance do
			local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i, self.MinDamage)
			if i == 1 then damage.sAnimation = "explospear"..distance.."_"..direction end
			ret:AddDamage(damage)
		end
	else	--jumping spear mode
		local move = PointList()
		move:push_back(p1)
		move:push_back(p2 - DIR_VECTORS[direction])
		ret:AddLeap(move,FULL_DELAY)	--p2 - that vector is the tile before p2, which is empty as per GetTargetArea
		local damage = SpaceDamage(p2, self.Damage)
		damage.sAnimation = "explospear2_"..direction
		ret:AddDamage(damage)
	end
	ret:AddDamage(SoundEffect(p2,self.LaunchSound))
	return ret
end

EVA_SniperRifle = Brute_Sniper:new{
	Name = "Sniper Rifle",
	Description = "Fire a projectile in a direction, dealing more damage to targets further away.",
	Class = "TechnoVek",
	Icon = "weapons/brute_sniper.png",
	PowerCost = 0, --AE Change
	ProjectileArt = "effects/shot_sniper",
	Damage = 2, -- for tooltip
	Push = true,
	MaxDamage = 4,
	MinDamage = 2,
	Upgrades = 2,
	Explosion = "",
	UpgradeCost = {1,2}, --AE Change 1,1
	UpgradeList = { "+1 Max Damage",  "+1 Damage"  },
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {				--the tip image is wrong, Lemon said yesterday this is because it uses the weapon it's inherited from
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1)
	},
	ZoneTargeting = ZONE_DIR,
}

--not even pretending to be original here
--I am thinking about turning it into a pallet rifle so it can spread shoot in two-click mode
--but Rei is more associated with sniper rifles so idk

EVA_SniperRifle_A = EVA_SniperRifle:new{
	MaxDamage = 5,
	Damage = 5,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}

EVA_SniperRifle_B = EVA_SniperRifle:new{
	MaxDamage = 5, 
	Damage = 5, 
	MinDamage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}
			
EVA_SniperRifle_AB = EVA_SniperRifle:new{
	MaxDamage = 6, 
	Damage = 6,
	MinDamage = 3,
	TipImage = {
		Unit = Point(2,5),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}

function EVA_SniperRifle:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	local counter = p1 + DIR_VECTORS[dir]
	local dist = 0
	
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)  
	
	while counter ~= target  and  dist ~= 8 do 
		dist = dist + 1
		counter = counter + DIR_VECTORS[dir]
	end
	
	
	local damage = SpaceDamage(target, math.min(self.MaxDamage, self.MinDamage + dist), dir)
	damage.sAnimation = "explopush1_"..dir
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)

	--ret.path = Board:GetSimplePath(p1, target)
	
	return ret
end

----------------
--Needle Racks--
----------------

--based on Asuka's shoulder thing she uses against an EVA Series
EVA_NeedleRacks = Skill:new{
	Name = "Needle Racks",	--ideally, this should have an emitter to drop casings on the ground
	Description = "Fire a short-range projectile as a free action, pushing the target.",
	Class = "TechnoVek",
	Icon = "weapons/EVA_NeedleRacks.png",
	PowerCost = 0, --AE Change
	ProjectileArt = "effects/needle",
	Damage = 1, -- for tooltip
	Push = true,
	Upgrades = 2,
	Range = 2,
	Limited = 2,
	Explosion = "",
	UpgradeCost = {1,2}, --AE Change 1,1
	UpgradeList = { "+1 Damage",  "+1 Use"  },
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1)
	},
	ZoneTargeting = ZONE_DIR,
}

EVA_NeedleRacks_A = EVA_NeedleRacks:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,
}

EVA_NeedleRacks_B = EVA_NeedleRacks:new{
	UpgradeDescription = "Can be used one more time.",
	Limited = 3,
}
			
EVA_NeedleRacks_AB = EVA_NeedleRacks:new{
	Damage = 2,
	Limited = 3,
}

function EVA_NeedleRacks:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 1, self.Range do
			local curr = DIR_VECTORS[i] * k + point
			if not Board:IsValid(curr) then break end
			ret:push_back(curr)
			if Board:IsBlocked(curr, PATH_PROJECTILE) then break end
		end
	end
	return ret
end

function EVA_NeedleRacks:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage, direction)
	damage.sScript = string.format("Board:GetPawn(%s):SetActive(true)",Board:GetPawn(p1):GetId())    
	ret:AddProjectile(p1, damage,self.ProjectileArt,NO_DELAY)
	return ret
end	

------------------
--Positron Rifle--
------------------

--based on the gun used by Shinji against Ramiel, and never again
EVA_PositronRifle = Laser_Base:new{
	Name = "Positron Rifle",
	Description = "Channel the power of the grid into a particle accelerator, firing a beam of antimatter. Costs Grid when fired, and can only be fired adjacent to a building.",
	Class = "TechnoVek",
	Icon = "weapons/EVA_PositronRifle.png",
	PowerCost = 0, --AE Change
	ProjectileArt = "effects/needle",
	Damage = 10, -- for tooltip
	Push = false,
	Upgrades = 0,
	Explosion = "",
	--UpgradeCost = {1,2}, 
	--UpgradeList = { "+1 Damage",  "+1 Use"  },	--maybe take into account grid DEF as an upgrade?
	LaunchSound = "/weapons/raining_volley",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1)
	},
	ZoneTargeting = ZONE_DIR,
}

function EVA_PositronRifle:GetTargetArea(point)
	--LaserBase with a check for building adjacency and grid power level
	local ret = PointList()
	local GridAdjacent
	for dir = DIR_START, DIR_END do
		curr = point + DIR_VECTORS[dir]
		if Board:GetTerrain(curr) == TERRAIN_BUILDING and (Board:IsPowered(curr) or not Board:GetPawn(curr):IsNonGridStructure()) then GridAdjacent = true end
	end
	if not GridAdjacent or Game:GetPower():GetValue() == 1 then return ret end
	for dir = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[dir]
		while Board:GetTerrain(curr) ~= TERRAIN_MOUNTAIN and not Board:IsBuilding(curr) and Board:IsValid(curr) do
			ret:push_back(curr)
			curr = curr + DIR_VECTORS[dir]
		end
		
		if Board:IsValid(curr) then ret:push_back(curr) end
	end
	return ret
end

function EVA_PositronRifle:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = p1 + DIR_VECTORS[direction]
	
	self:AddLaser(ret, target, direction)
	ret:AddScript("Game:ModifyPowerGrid(-1)")
	return ret
end

------------------
--Spacecraft Shield--
------------------

--based on the shield Rei uses to protect Shinji against Ramiel
--Ramiel's laser loses damage when it hits something, so Rei can bodyblock it
EVA_SpacecraftShield = Skill:new{
	Name = "Spacecraft Shield",
	Description = "Slam a massive shield, pushing adjacent tiles. Can self-target to gain 2 maximum HP for one turn.",
	Class = "TechnoVek",
	Icon = "weapons/EVA_SpacecraftShield.png",
	PowerCost = 0, --AE Change
	Damage = 2, -- for tooltip
	Push = false,
	Upgrades = 0,
	Explosion = "",
	UpgradeCost = {2,3}, 
	UpgradeList = { "Aegis", "+2 Shield Strength"   },
	LaunchSound = "/weapons/shield_bash",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,3)
	},
	ZoneTargeting = ZONE_DIR,
}

EVA_SpacecraftShield_A = EVA_SpacecraftShield:new{
	UpgradeDescription = "Grants a shield and pushes adjacent tiles when self-targeted.",
	Aegis = true,
}

EVA_SpacecraftShield_B = EVA_SpacecraftShield:new{
	UpgradeDescription = "Increases damage and maximum HP gained by 2.",
	Damage = 4,
}
			
EVA_SpacecraftShield_AB = EVA_SpacecraftShield:new{
	Damage = 4,
	Aegis = true,
}

function EVA_SpacecraftShield:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		curr = point + DIR_VECTORS[dir]
		ret:push_back(curr)
	end
	ret:push_back(point)
	return ret
end

function EVA_SpacecraftShield:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	if p1 == p2 then
		--gain self HP, if Aegis push adjacents & gain shield
	else
		--deal damage, push adjacents except self using the slam code
		damage = SpaceDamage(p2, self.Damage)
		damage.sAnimation = "explosmash_"..direction
		
		ret:AddDamage(damage)
		
		ret:AddDelay(0.1)
		ret:AddBounce(p2,3)
		ret:AddDelay(0.2)
		
		local damage = SpaceDamage(p2 + DIR_VECTORS[direction], 0, direction)
		damage.sAnimation = "airpush_"..direction
		ret:AddDamage(damage)
		
		damage = SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], 0, (direction+1)%4)
		damage.sAnimation = "airpush_"..((direction+1)%4)
		ret:AddDamage(damage)
		
		damage = SpaceDamage(p2 + DIR_VECTORS[(direction - 1)% 4],0, (direction-1)%4)
		damage.sAnimation = "airpush_"..((direction-1)%4)
		ret:AddDamage(damage)
		
	end
	return ret
end