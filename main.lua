
--Startup
----Welcome to the "main.lua" file! Here is where all the magic happens, everything from functions to callbacks are dOne_Character.
--Startup
local mod = RegisterMod("Commission Template - Character + Tainted", 1)
local game = Game()
local rng = RNG()

local test = 500

---@param name string
---@param isTainted boolean
---@return table
local function addCharacter(name, isTainted, speed, tears, damage, range, shotspeed, luck, tearcolor, flying, tearflag) -- This is the function used to determine the stats of your character, you can simply leave it as you will use it later!
	local character = { -- these stats are added to Isaac's base stats.
		NAME = name,
		ID = Isaac.GetPlayerTypeByName(name, isTainted), -- string, boolean
		Costume_ID = Isaac.GetCostumeIdByPath("gfx/characters/"..name.."-head.anm2"),
	}
	return character
end

--Character Stat Definitions
----------addCharacter(NAME, isTainted)
mod.One_Character = addCharacter("One", false)
mod.Two_Character = addCharacter("Two", true)

--Stat Functions
local function toTears(fireDelay) --thanks oat for the cool functions for calculating firerate!
	return 30 / (fireDelay + 1)
end
local function fromTears(tears)
	return math.max((30 / tears) - 1, -0.99)
end

function mod:evalCache(player, cacheFlag) -- this function applies all the stats the character gains/loses on a new run.
	---@param speed number
	---@param tears number
	---@param damage number
	---@param range number
	---@param shotspeed number
	---@param luck number
	---@param tearcolor Color
	---@param flying boolean
	---@param tearflag TearFlags
	local function addStats(name, speed, tears, damage, range, shotspeed, luck, tearcolor, flying, tearflag) -- This is the function used to determine the stats of your character, you can simply leave it as you will use it later!
		if player:GetPlayerType(name) then
			if cacheFlag == CacheFlag.CACHE_SPEED then
				player.MoveSpeed = player.MoveSpeed + speed
			end
			if cacheFlag == CacheFlag.CACHE_FIREDELAY then
				player.MaxFireDelay = math.max(1.0, fromTears(toTears(player.MaxFireDelay) + tears))
			end
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.Damage = player.Damage + damage
			end
			if cacheFlag == CacheFlag.CACHE_DAMAGE then
				player.TearRange = player.TearRange + range * 40
			end
			if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
				player.ShotSpeed = player.ShotSpeed + shotspeed
			end
			if cacheFlag == CacheFlag.CACHE_LUCK then
				player.Luck = player.Luck + luck
			end
			if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
				player.TearColor = tearcolor
			end
			if cacheFlag == CacheFlag.CACHE_FLYING and flying then
				player.CanFly = true
			end
			if cacheFlag == CacheFlag.CACHE_TEARFLAG then
				player.TearFlags = player.TearFlags | tearflag
			end
		end
	end
	mod.One_Stats = addStats("One", 0, 0, 0, 0, 0, 0, Color(1, 1, 1, 1.0, 0, 0, 0), false, TearFlags.TEAR_NORMAL)
	mod.Two_Stats = addStats("Two", 0, 0, 0, 0, 0, 0, Color(1, 1, 1, 1.0, 0, 0, 0), false, TearFlags.TEAR_NORMAL)
	
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE,mod.evalCache)

function mod:playerSpawn(player)
    if player:GetName() == mod.One_Character.NAME then
        player:AddNullCostume(mod.One_Character.Costume_ID)
    end
    if player:GetName() == mod.Two_Character.NAME then
        player:AddNullCostume(mod.Two_Character.Costume_ID)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.playerSpawn)