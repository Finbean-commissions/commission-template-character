----Welcome to the "main.lua" file! Here is where all the magic happens, everything from functions to callbacks are done here.
--Startup
local mod = RegisterMod("Commission Template - Character + Tainted", 1)
local game = Game()
local rng = RNG()

--local RECOMMENDED_SHIFT_IDX = 35
--local seeds = game:GetSeeds()
--local startSeed = seeds:GetStartSeed()

local function toTears(fireDelay) --thanks oat for the cool functions for calculating firerate
	return 30 / (fireDelay + 1)
end
local function fromTears(tears)
	return math.max((30 / tears) - 1, -0.99)
end

mod.One = {
	ID = Isaac.GetPlayerTypeByName("One"),
	Costume_ID = Isaac.GetCostumeIdByPath("gfx/characters/One-head.anm2"),
	Stats = {
		DAMAGE = 0.00,
		FIREDELAY = 0.00,
		SHOTSPEED = 0.00,
		SPEED = 0.00,
		TEARCOLOR = Color(255/255, 255/255, 255/255, 255/255, 0, 0, 0),
		FLYING = false,
		TEARFLAG = TearFlags.TEAR_NORMAL,
		LUCK = 0.00,
		RANGE = 0.00
	},
}
mod.Two = {
	ID = Isaac.GetPlayerTypeByName("Two", true),
	Costume_ID = Isaac.GetCostumeIdByPath("gfx/characters/Two-head.anm2"),
	Stats = {
		DAMAGE = 0.00,
		FIREDELAY = 0.00,
		SHOTSPEED = 0.00,
		SPEED = 0.00,
		TEARCOLOR = Color(255/255, 255/255, 255/255, 255/255, 0, 0, 0),
		FLYING = false,
		TEARFLAG = TearFlags.TEAR_NORMAL,
		LUCK = 0.00,
		RANGE = 0.00
	},
}

function mod:playerSpawn(player) 
    if player:GetName() == "One" then
        player:AddNullCostume(mod.One.Costume_ID)
    end
    if player:GetName() == "Two" then
        player:AddNullCostume(mod.Two.Costume_ID)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.playerSpawn)

function mod:evalCache(player, cacheFlag)
	if player:GetName() == "One" then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + mod.One.Stats.DAMAGE
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = math.max(1.0, fromTears(toTears(player.MaxFireDelay) + mod.One.Stats.FIREDELAY))
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + mod.One.Stats.SHOTSPEED
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + mod.One.Stats.SPEED
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + mod.One.Stats.LUCK
		end
		if cacheFlag == CacheFlag.CACHE_FLYING and mod.One.Stats.FLYING then
			player.CanFly = true
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | mod.One.Stats.TEARFLAG
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = mod.One.Stats.TEARCOLOR
		end
	end
	if player:GetName() == "Two" then
		if cacheFlag == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + mod.Two.Stats.DAMAGE
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			player.MaxFireDelay = math.max(1.0, fromTears(toTears(player.MaxFireDelay) + mod.Two.Stats.FIREDELAY))
		end
		if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + mod.Two.Stats.SHOTSPEED
		end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + mod.Two.Stats.SPEED
		end
		if cacheFlag == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + mod.Two.Stats.LUCK
		end
		if cacheFlag == CacheFlag.CACHE_FLYING and mod.Two.Stats.FLYING then
			player.CanFly = true
		end
		if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			player.TearFlags = player.TearFlags | mod.Two.Stats.TEARFLAG
		end
		if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			player.TearColor = mod.Two.Stats.TEARCOLOR
		end
	end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.evalCache)