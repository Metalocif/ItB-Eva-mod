-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath

-- add assets from our mod so the game can find them.

local iconPath = path .."img/weapons/"

local files = {
	"EVA_ProgKnife.png",
	-- "EVA_SniperRifle.png",
	-- "EVA_NeedleRack.png",
	"EVA_SonicGlaive.png",
	-- "EVA_LonginusSpear.png"
}

-- iterate our files and add the assets so the game can find them.
for _, file in ipairs(files) do
	modApi:appendAsset("img/weapons/".. file, iconPath .. file)
end

--EVA weapons are massively overpowered because Angels are massively overpowered.
--This runs the risk of being overcentralizing but it is lore-accurate.
--There is also something to be said for the fantasy of Evangelion stomping through bugs.
--Let the damn kids get a win for once!

--For real though, I'll make an option to balance their weapons for a no-Angels run.

--------------
--Prog Knife--
--------------

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
			damage.sAnimation="explosword"..direction
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
			damage.sAnimation="explosword"..direction
		end
		ret:AddMelee(p3 - DIR_VECTORS[direction], damage)
		ret:AddDelay(0.2)
	end
	return ret
end

----------------
--Sonic Glaive--
----------------

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
			--if it is further and there is a space we can walk it to jump into in front of target, that's fine too
		end
	end
	return ret
end

function EVA_SonicGlaive:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p2:Manhattan(p1)
	LOG(distance)
	if distance == 1 then	--sword mode
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)% 4], self.MinDamage))
		ret:AddDamage(SpaceDamage(p2 - DIR_VECTORS[(direction + 1)% 4], self.MinDamage))
		local damage = SpaceDamage(p2, self.MinDamage)
		LOG("pre anim")
		damage.sAnimation = "explosword_"..direction
		LOG("sword anim")
		ret:AddDamage(damage)
		LOG("sword damage")
	elseif distance == 2 then	--spear mode
		for i = 1, distance do
			local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i, self.MinDamage)
			if i == 1 then damage.sAnimation = "explospear"..distance.."_"..direction end
			ret:AddDamage(damage)
			LOG(i)
		end
	else	--jumping spear mode
		LOG("pre leap")
		local move = PointList()
		move:push_back(p1)
		move:push_back(p2 - DIR_VECTORS[direction])
		ret:AddLeap(move,FULL_DELAY)	--p2 - that vector is the tile before p2, which is empty as per GetTargetArea
		LOG("post leap")
		local damage = SpaceDamage(p2, self.Damage)
		damage.sAnimation = "explospear2_"..direction
		ret:AddDamage(damage)
		LOG("post damage")
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
	Push = 0,
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

Brute_Sniper_A = Brute_Sniper:new{
	MaxDamage = 5,
	Damage = 5,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}

Brute_Sniper_B = Brute_Sniper:new{
	MaxDamage = 5, 
	Damage = 5, 
	MinDamage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}
			
Brute_Sniper_AB = Brute_Sniper:new{
	MaxDamage = 6, 
	Damage = 6,
	MinDamage = 3,
	TipImage = {
		Unit = Point(2,5),
		Enemy = Point(2,0),
		Target = Point(2,1),
	},
}