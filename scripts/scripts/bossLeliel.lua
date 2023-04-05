Mission_LelielBoss = Mission_Boss:new{
	Name = "Leliel",
	BossPawn = "EVA_LelielBoss",
	SpawnStartMod = -2,
	BossText = "Destroy the Angel Leliel",
	islandLock = 3,
}
--IslandLocks.Mission_LelielBoss = 3
--can use this to make angels appear in a more-or-less set order
--ideally, we'd pop other island-1 tier angels off the list after beating the first island and so on
EVA_LelielBoss = Pawn:new{
	Name = "Leliel",
	Health = 9,
	MoveSpeed = 5,
	Ranged=0,
	Image = "EVA_LelielBoss",
	--ImageOffset = 2,
	SkillList = { "EVA_LelielBossAtk1" },	
	SoundLocation = "/enemy/goo_boss/",
	Flying = true,
	Portrait = "enemy/EVA_LelielBoss",
	ImpactMaterial = IMPACT_FLESH,			
	Tier = TIER_BOSS,
	Massive=true,
	Corpse=false,				--definitely shouldn't have a corpse
	DefaultTeam = TEAM_ENEMY,
}
AddPawnName("EVA_LelielBoss")
--needs a custom positioning score, since it only wants to attack nonflying enemies
--you can manipulate AI by just setting scores for hitting buildings/allies/enemies in the pawn def, but doesn't work for flying

local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
LOG(resourcePath)
local writepath = "img/units/aliens/"
local readpath = resourcePath .. writepath
local imagepath = writepath:sub(5,-1)
local a = ANIMS

modApi:appendAsset("img/units/aliens/EVA_LelielBoss.png", readpath.."EVA_LelielBoss.png")
modApi:appendAsset("img/units/aliens/EVA_LelielBossa.png", readpath.."EVA_LelielBossa.png")
modApi:appendAsset("img/units/aliens/EVA_LelielBoss_emerge.png", readpath.."EVA_LelielBoss_emerge.png")
modApi:appendAsset("img/units/aliens/EVA_LelielBoss_death.png", readpath.."EVA_LelielBoss_death.png")

local base = a.EnemyUnit:new{Image = "units/aliens/EVA_LelielBoss.png", PosX = -23, PosY = -16, Height = 1}	
local baseEmerge = a.BaseEmerge:new{Image = "units/aliens/EVA_LelielBossa.png", NumFrames = 4, Height = 1}

a.EVA_LelielBoss = base
a.EVA_LelielBosse = baseEmerge
a.EVA_LelielBossa = base:new{ Image = "units/aliens/EVA_LelielBossa.png", NumFrames = 4, PosX = -23, PosY = -16, Height = 1 }
a.EVA_LelielBossd = base:new{ Image = "units/aliens/EVA_LelielBoss_death.png", Loop = false, NumFrames = 4, Time = .15, Height = 1 }

modApi:appendAsset("img/portraits/enemy/EVA_LelielBoss.png", resourcePath.."img/portraits/enemy/EVA_LelielBoss.png")

LelielHold_Break = Animation:new{
	Image = "effects/holdtest/hold_break.png", NumFrames = 7, Loop = false, Time = 0.07, PosX = -26, PosY = 9
}

LelielHold_Anim = Animation:new{ Time = 0.07, NumFrames = 4, Loop = false, Layer = LAYER_BACK,}

LelielHold_0 = LelielHold_Anim:new{
	Image = "effects/holdtest/hold_0_death.png", PosX = -7, PosY = 2
}
LelielHold_1 = LelielHold_Anim:new{
	Image = "effects/holdtest/hold_1_death.png", PosX = -7, PosY = 22
}
LelielHold_2 = LelielHold_Anim:new{
	Image = "effects/holdtest/hold_2_death.png", PosX = -34, PosY = 22
}
LelielHold_3 = LelielHold_Anim:new{
	Image = "effects/holdtest/hold_3_death.png", PosX = -31, PosY = -1
}

LelielHold_Anim_Emerge = LelielHold_Anim:new{Time = 0.075}

LelielHold_0_Emerge = LelielHold_Anim_Emerge:new{
	Image = "effects/holdtest/hold_0_emerge.png", PosX = -8, PosY = 1
}
LelielHold_1_Emerge = LelielHold_Anim_Emerge:new{
	Image = "effects/holdtest/hold_1_emerge.png", PosX = -8, PosY = 21
}
LelielHold_2_Emerge = LelielHold_Anim_Emerge:new{
	Image = "effects/holdtest/hold_2_emerge.png", PosX = -35, PosY = 21
}
LelielHold_3_Emerge = LelielHold_Anim_Emerge:new{
	Image = "effects/holdtest/hold_3_emerge.png", PosX = -32, PosY = -2
}

LelielHold_Off = Animation:new{
	Image = "effects/holdtest/hold_death.png", 
	NumFrames = 8,
	Loop = false, 
	Time = 0.07, 
	Lengths = {0.07,0.07,0.07,0.07,0.07,0.07,0.07,LelielHold_Anim_Emerge.Time*4},--account for growth in reverse mode
	PosX = -17, 
	PosY = 12
}

--AFAICT none of the above does anything

modApi:appendAsset("img/effects/holdtest/hold_break.png", resourcePath.."img/effects/holdtest/hold_break.png")
modApi:appendAsset("img/effects/holdtest/hold_0_death.png", resourcePath.."img/effects/holdtest/hold_0_death.png")
modApi:appendAsset("img/effects/holdtest/hold_1_death.png", resourcePath.."img/effects/holdtest/hold_1_death.png")
modApi:appendAsset("img/effects/holdtest/hold_2_death.png", resourcePath.."img/effects/holdtest/hold_2_death.png")
modApi:appendAsset("img/effects/holdtest/hold_3_death.png", resourcePath.."img/effects/holdtest/hold_3_death.png")
modApi:appendAsset("img/effects/holdtest/hold_0_emerge.png", resourcePath.."img/effects/holdtest/hold_0_emerge.png")
modApi:appendAsset("img/effects/holdtest/hold_1_emerge.png", resourcePath.."img/effects/holdtest/hold_1_emerge.png")
modApi:appendAsset("img/effects/holdtest/hold_2_emerge.png", resourcePath.."img/effects/holdtest/hold_2_emerge.png")
modApi:appendAsset("img/effects/holdtest/hold_3_emerge.png", resourcePath.."img/effects/holdtest/hold_3_emerge.png")
modApi:appendAsset("img/effects/holdtest/hold_death.png", resourcePath.."img/effects/holdtest/hold_death.png")

-- local effects = {

-- }
-- for _, effect in ipairs(effects) do
	-- modApi:appendAsset("img/effects/".. effect, resourcePath .. "img/effects/" .. effect)
-- end

EVA_LelielBossAtk1 = Skill:new{
	Name = "Black Hole",	--haha geddit
	Description = "Attempts to pull every adjacent nonflying unit into its body, killing it instantly.",
	Icon = "weapons/LelielBlackHole.png",
	Class = "Enemy",
	PathSize = 1,
	Damage = 0,	
	Push = 0,
	TipImage = {
		CustomPawn = "EVA_LelielBoss",
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Building = Point(1,1),
		Target = Point(2,1),
	}
}

function EVA_LelielBossAtk1:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local lelielId = Board:GetPawn(p1):GetId()
	local pullDamage = SpaceDamage(p1, 0)
	local makeChasm = SpaceDamage(p1, 0)
	local terrainToRemake = Board:GetTerrain(p1)
	
	makeChasm.iTerrain = TERRAIN_HOLE
	makeChasm.bHide = true
	ret:AddQueuedDamage(makeChasm)
	for dir = DIR_START, DIR_END do
		local pawn = Board:GetPawn(p1+DIR_VECTORS[dir])
		if pawn and not pawn:IsFlying() then
			pullDamage.loc = p1+DIR_VECTORS[dir]
			--could change that constant to make the fall slower so it looks like sinking
			pullDamage.sScript = string.format("Board:GetPawn(%s):SetSpace(%s)", pawn:GetId(), p1:GetString())
			ret:AddQueuedDamage(pullDamage)	--not really a pull
			ret:AddGrapple(p1,p1+DIR_VECTORS[dir],"LelielHold")	
			--this should be an animation, if I understand the modloader correctly
			Board:MarkSpaceSimpleColor(p1+DIR_VECTORS[dir], COLOR_BLACK)
			pawn:SetSpaceColor(false)
			
			local d = SpaceDamage(p1+DIR_VECTORS[dir])
			d.sImageMark = "effects/holdtest/hold_front.png"
			Board:MarkSpaceDamage(d)
			
			Board:MarkSpaceSimpleColor(p1+DIR_VECTORS[dir], COLOR_BLACK)
			
			--could be a very dark, shadow tentacle-like version of the web grapple assets, though that's not how the scene looks
			--grappling so we can do the whole "pulling from quicksand" trope; could also set movement to 0
			--set anim to water, unset it on not grappled, ideally; pretty sure I'd need a hook to unset it so let's do that later
			--ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", lelielId))
			ret:AddQueuedDamage(SpaceDamage(p1+DIR_VECTORS[dir], 0, (dir+2)%4)	)
			--ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(%s)", lelielId, p1:GetString()))
			--pull target into self, this does nothing because we set space beforehand but makes preview look like the target is pulled
			--also makes preview looks like the target will bump into Leliel
			--might set Leliel off the board before pull, back in place after, just so it looks ok preview-wise... doesn't work
			
			
			
			--I just want ok-looking animations.
			--Option 1: a dark grapple, to sell the idea the targets are trapped.
			--Option 2: set the target's animation to water as long as they are adjacent to Leliel, set their movement to 0, set ground to black.
			--Please help.
		end
	end
	ret:AddDelay(1)
	LOG("start remaking")
	LOG(terrainToRemake)
	LOG(TERRAIN_HOLE)
	LOG(TERRAIN_ROAD)
	local unmakeChasm = SpaceDamage(p1, 0)
	unmakeChasm.iTerrain = terrainToRemake
	unmakeChasm.bHide = true
	ret:AddQueuedDamage(unmakeChasm)
	--Somehow this doesn't work, the longs are OK in previews but not during the enemy turn, leaving chasms behind.
	return ret
end
--collapse this, it's not interesting
--it's a slightly modified scorer to ignore flying targets, buildings, and stable pawns
--should also ignore robots (SEX_ROBOT) and units with no pilot inside (Artificial personality) eg. deployables for lore reasons ig
--(because robots are not Lilin)
function Skill:ScoreList(list, queued)
	local score = 0
	local posScore = 0
	for i = 1, list:size() do
		local spaceDamage = list:index(i)
		local target = spaceDamage.loc
		local damage = spaceDamage.iDamage 
		local moving = spaceDamage:IsMovement() and spaceDamage:MoveStart() == Pawn:GetSpace()
		
		if Board:IsValid(target) or moving then	
			if spaceDamage:IsMovement() then
				posScore = posScore + ScorePositioning(spaceDamage:MoveEnd(), Pawn)
			elseif Board:GetPawnTeam(target) == Pawn:GetTeam() and damage > 0 then
				if Board:IsFrozen(target) and not Board:IsTargeted(target) then
					if not Board:GetPawn(target):IsFlying() and not Board:GetPawn(target):IsGuarding() then score = score + self.ScoreEnemy end
				else
					score = score + self.ScoreFriendlyDamage
				end
			elseif isEnemy(Board:GetPawnTeam(target),Pawn:GetTeam()) then
					if Board:GetPawn(target):IsTempUnit() then --Board:GetPawn(target):IsDead() tries to eat corpses as well for lore reasons
						score = self.ScoreNothing
					else
						if not Board:GetPawn(target):IsFlying() and not Board:GetPawn(target):IsGuarding() then score = score + self.ScoreEnemy end
					end
			elseif Board:IsPod(target) and not queued and (damage > 0 or spaceDamage.sPawn ~= "") then
				return -100
			else
				score = score + self.ScoreNothing
			end
		end
	end
	
	--if position is REALLY BAD don't do this (blocking friends, dying, etc.)
	if posScore < -5 then	
		return posScore 
	end
	
	return score
end