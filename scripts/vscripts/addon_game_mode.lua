
if my_game == nil then
    _G.my_game = class({})
end

-- on both server and client
require("util/safeguards")



require("events_protector")
if IsClient() then
    require("function_client")
end


_G.PlayerCount = 0

_G.teleports = {}
_G.waves = {}
_G.boss_waves = {}
_G.players = {}
_G.towers = {}
_G.timer = 0
_G.Deaths = 0

Rating_Table = {40,30,10,-10,-30,-40}
Rating_Table_Max = {20,15,5,-5,-15,-20}

_G.Wave_boss_number = {8,25}
_G.Purple_Wave = {4,15}
_G.upgrade_orange = 21

_G.Deaths_Players = {}
_G.End_net = {}

_G.Time_to_pick_Hero = 25
_G.Time_to_pick_Base = 15

_G.game_start = false
_G.Game_end = false
	
_G.duel_prepair = false
_G.duel_in_progress = false
_G.init_duel = false
_G.new_round = false

_G.Duel_Hero = {}
_G.duel_start = 5
_G.duel_timer = 90
_G.round_timer = 5
_G.duel_timer_progress = 60 + duel_start
_G.field_stun = 0.5
_G.wins_for_win = 2
_G.field = 0

_G.Duel_round = 0

_G.wall_particle = {}

_G.Target_timers = {1020,1560,2190}
_G.Target_count = 0
_G.Target_duration = 210
_G.Target_gold = 1.2
_G.Target_max_timer = 2400

_G.Active_Roshan = false
_G.RoshanTimers = {1260,1800,2400,3000,3600,4200,4800,5400,6000,6600,7200,7800,8400,9000,9600,10200,10800,11400,12000,12600,13200,13800,14400,15000,15600,16200,16800,17400,18000,18600,19200,19800,20400,21000,21600,22200,22800,23400,24000,24600,25200,25800,26400,27000,27600,28200,28800,29400,30000,30600,31200,31800,32400,33000,33600,34200,34800,35400,36000,36600,37200,37800,38400,39000,39600,40200,40800,41400,42000,42600,43200,43800,44400,45000,45600,46200,46800,47400,48000,48600,49200,49800,50400,51000,51600,52200,52800,53400,54000,54600,55200,55800,56400,57000,57600,58200,58800,59400,60000,60600,61200}
_G.roshan_number = 1
_G.roshan_timer = 1
_G.roshan_alert = 60



_G.patrol_timer = 0
_G.patrol_timer_max = 60
_G.patrol_wave = 8
_G.patrol_second_tier = 1680
_G.patrol_first_tier = 570
_G.patrol_second_init = false 
_G.patrol_first_init = false
my_game.patrol_dontgo_radiant = false
my_game.patrol_dontgo_dire = false
my_game.ravager_table = {}
my_game.ravager_max = 12

_G.give_all_vision_time = 1800
_G.init_vision = false

_G.avg_rating = 0

_G.Observer_max = 4
_G.Observer_cd = 180
_G.Observer_duration = 480

_G.DeathTimer = 2
_G.StartDeathTimer = 10
_G.DeathTimer_PerPlayer = 8
_G.DeathTimer_PerWave = 1.5

_G.lownet_gold = 1
_G.lownet_purple = 2
_G.lownet_blue = 2
_G.lownet_duration = 180

_G.Streak_res = 0
_G.Streak_gold = 400
_G.Streak_k = 0.4
_G.Kills_to_streak = 3

_G.teleport_cd = 60
_G.teleport_range = 350

_G.UpgradeGray = 0.2

_G.GoldComeback = 1.8
_G.MaxTimer = 0

_G.StartPurple = 2
_G.PlusPurple = 1

_G.low_net_time = 1500
_G.low_net_waves = {10,15}
_G.low_net_diff = 0

_G.StartBlue = 60
_G.PlusBlue = 15

_G.Necro_Timer = 30

_G.PortalDelay = 5
_G.NeutralChance = 12
_G.MaxNeutral = 4

_G.test = false
_G.tower = false
_G.healing = true

_G.enable_pause = false

_G.start_wave = 0
_G.timer_test = 151111
_G.timer_test_start = 51111
_G.test_wave = 0

_G.DontUpgradeCreeps = false

_G.Pause_Time = 30

_G.ValidGame_Time = 900

_G.kill_net_gold = 0.035

_G.bounty_timer = 0
_G.bounty_max_timer = 120
_G.bounty_init = false 
_G.bounty_start = 240


_G.Player_damage_max = 60
_G.Player_damage_inc = 15
_G.Player_damage_time = 1500

_G.LowPriorityTime = 1500

_G.PartyTable = {}

_G.After_Lich = false

_G.ACT_DOTA_SPAWN_STATUE = ACT_DOTA_SPAWN_STATUE or 1766


local vision_abs = 
{
	{},
	{-6397,-6454,87,800,-7146,-7179,95,1000},
	{6599,6542,95,800,7371,7247,103,1000},
	{},
	{},
	{-6299,2554,103,800,-6263,3740,95,800},
	{2638,-6457,95,800,3824,-6486,103,800},
	{-2388,6400,103,800,-3574,6389,95,800},
	{6526,-2523,95,800,6529,-3710,103,800},

}
local bounty_abs = 
{
	Vector(-2322.87, -2748.66,260),
	Vector(-1965,-6816,390),
	Vector(-6385,-2489,390),
	Vector(2608.1, 2711.76,260),
	Vector(2345, 6731,390),
	Vector(7071,2385,390),

}

all_heroes = 
{
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_huskar",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_puck",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_void_spirit",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_pudge",
	"npc_dota_hero_hoodwink",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_lina",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_axe",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_antimage",
	"npc_dota_hero_primal_beast"

}


require( 'resources')
require( 'server')
require( 'function')
require( 'addon_init')
require( 'timers')
require( 'spawn' )
require( 'upgrade')
require( 'debug_')
require( 'hero_select')
require( 'vector_target')
require( 'patrol_main')
require( 'server_data')



function Precache( context )
local heroes = LoadKeyValues("scripts/npc/dota_heroes.txt")
for k,v in pairs(heroes) do
          PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_" .. k:gsub('npc_dota_hero_','') ..".vsndevts", context )  
          PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_" .. k:gsub('npc_dota_hero_','') ..".vsndevts", context ) 
end



for _,k in pairs(my_game.heroes_particles) do
	PrecacheResource( "particle_folder", "particles/units/heroes/" .. k, context )
end

for _,k in pairs(my_game.heroes_items_particles) do
	PrecacheResource( "particle_folder", "particles/econ/items/" .. k, context ) 
end



for _,v in pairs(my_game.Particles) do
	PrecacheResource( "particle", v, context )
end


PrecacheResource( "model", "custom/item_blue.vmdl", context )  
PrecacheResource( "model", "custom/item_orange.vmdl", context )     
PrecacheResource( "model", "custom/item_gray.vmdl", context )          
PrecacheResource( "model", "custom/item_purple.vmdl", context )   
PrecacheResource( "model", "models/heroes/terrorblade/demon.vmdl", context ) 

local mobs = LoadKeyValues("scripts/npc/npc_units_custom.txt")
for k,v in pairs(mobs) do
  PrecacheUnitByNameAsync(k, function(...) end)

end

local items = LoadKeyValues("scripts/npc/npc_items_custom.txt")
for k,v in pairs(items) do
  PrecacheItemByNameAsync(k, function(...) end)

end


 PrecacheResource( "soundfile", "endsoundevents/game_sounds.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/soundevents_dota.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/game_sounds_effects.vsndevts", context ) 
 PrecacheResource( "soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context ) 
     
end


-- Create the game mode when we activate
function Activate()
	my_game:InitGameMode()
end

function shuffle(x)
    for i = #x, 2, -1 do
        local j = math.random(i)
        x[i], x[j] = x[j], x[i]
    end
end

local AvailableTeams = {
    DOTA_TEAM_GOODGUYS,
    DOTA_TEAM_BADGUYS,
    DOTA_TEAM_CUSTOM_1,
    DOTA_TEAM_CUSTOM_2,
    DOTA_TEAM_CUSTOM_3,
    DOTA_TEAM_CUSTOM_4,
}

local team_size = 1

function my_game:InitGameMode()
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)

    hero_select:RegisterHeroes()
    upgrade:InitGameMode()
    ListenToGameEvent("player_connect_full", Dynamic_Wrap(hero_select, "PlayerConnected"), hero_select)


	for _, team in pairs(AvailableTeams) do
        GameRules:SetCustomGameTeamMaxPlayers(team, team_size)
    end


    GameRules:SetSafeToLeave(true)

    GameRules:GetGameModeEntity():SetPauseEnabled( false )

    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( my_game, "ExecuteOrderFilterCustom" ), self )

    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )


  	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
    GameRules:SetPreGameTime( 1 )
    GameRules:GetGameModeEntity():SetDaynightCycleDisabled( false )
	GameRules:SetTimeOfDay(0.7)
	GameRules:SetCustomGameEndDelay( 3 )
	GameRules:SetCustomVictoryMessageDuration(120)
	GameRules:SetPostGameTime(120)
	GameRules:SetTreeRegrowTime(1)

	--GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)



	GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)

	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_tpscroll_custom")

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )

	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(300)
    GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( my_game, "DamageFilter" ), self )
	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( my_game, "HealingFilter" ), self )
	
	CustomGameEventManager:RegisterListener( "ChangeTipsType", Dynamic_Wrap(self, 'ChangeTipsType'))

    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameRulesStateChange' ), self )
    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(self, 'OnPlayerLevelUp'), self)
    ListenToGameEvent( "dota_glyph_used", Dynamic_Wrap( self, 'OnGlyphUsed' ), self )


    ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickUp"), self )

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( self, "BountyRunePickupFilter" ), self )

    CustomGameEventManager:RegisterListener( "GiveGlobalVision", Dynamic_Wrap(self, 'GiveGlobalVision'))


    CustomGameEventManager:RegisterListener( "send_report", Dynamic_Wrap(self, 'send_report'))

    CustomGameEventManager:RegisterListener( "request_key", Dynamic_Wrap(self, 'show_key'))

   -- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(self, "GoldFilter"), self)
      

end


function my_game:show_key(data)
	if data.PlayerID == nil then return end
	local steamid = PlayerResource:GetSteamID(data.PlayerID)



	if false then --tostring(steamid) == "76561198192555753" then 

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), 'print_debug',  {text = GetDedicatedServerKeyV2(data.fuck_cheaters)})
		
	end

end

 

function my_game:ChangeTipsType(data) 
	if data.PlayerID == nil then return end
	CustomNetTables:SetTableValue("TipsType", tostring(data.PlayerID), {type = data.type})
end


function my_game:BountyRunePickupFilter(params)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.player_id_const), 'delete_bounty',  {})
				
local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
local gold = 50 + minute * 8


local unit = PlayerResource:GetSelectedHeroEntity(params.player_id_const)

if unit and unit:HasModifier("modifier_alchemist_goblins_greed_custom") then 
	local ability = unit:FindAbilityByName("alchemist_goblins_greed_custom")
	gold = gold*ability:GetSpecialValueFor("bounty_multiplier")

	if unit:HasModifier("modifier_alchemist_greed_5") then 
		local buf_table = {
			"modifier_alchemist_goblins_greed_custom_haste",
			"modifier_alchemist_goblins_greed_custom_dd",
			"modifier_alchemist_goblins_greed_custom_arcane",
			"modifier_alchemist_goblins_greed_custom_regen"
		}
		local name = buf_table[RandomInt(1, #buf_table)]

		unit:AddNewModifier(unit, ability, name, {duration = ability.rune_duration})

	end

end


params["gold_bounty"] = gold 

return true

end

_G.PendingReports = {}
function my_game:send_report(kv)
    if kv.PlayerID == nil then return end

    local reported1 = PlayerResource:GetSteamAccountID(kv.Hero_1)
    local reported2 = PlayerResource:GetSteamAccountID(kv.Hero_2)

    local targets = {tostring(reported1), tostring(reported2)}

    local reports = CustomNetTables:GetTableValue("reports", tostring(kv.PlayerID))
    if reports.report == 0 then
        return
    end

    CustomNetTables:SetTableValue("reports", tostring(kv.PlayerID), {
        report = reports.report - 1    
    })

    if Http:WillSendData() then
        table.insert(_G.PendingReports, {
            source_account_id = tostring(PlayerResource:GetSteamAccountID(kv.PlayerID)) ,
            target_account_ids = targets,
            type = 0,
        })
    end
end



function my_game:OnGlyphUsed( params )
	GameRules:SetGlyphCooldown( params.teamnumber, 300 )

	if players[params.teamnumber] ~= nil then 
		CustomGameEventManager:Send_ServerToAllClients( 'glyph_used', {player = players[params.teamnumber]:GetUnitName()} )
	end
end


LinkLuaModifier("modifier_tower_level", "modifiers/modifier_tower_level.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_on_respawn", "modifiers/modifier_on_respawn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death", "modifiers/modifier_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_final_duel", "modifiers/modifier_final_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_finish", "modifiers/modifier_duel_finish", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_roshan_upgrade", "modifiers/modifier_roshan_upgrade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_damage", "modifiers/modifier_player_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_map", "modifiers/modifier_bounty_map", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aegis_custom", "modifiers/modifier_aegis_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_damage", "modifiers/modifier_tower_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_target", "modifiers/modifier_target", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ravager", "modifiers/modifier_ravager", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage_final", "modifiers/modifier_duel_damage_final", LUA_MODIFIER_MOTION_NONE)




function my_game:CheckDisarm( unit )
if not IsServer() then return end



local mods = {
		"modifier_heavens_halberd_debuff",
		"modifier_ghost_state",
		"modifier_item_book_of_shadows_buff",
		"modifier_custom_huskar_inner_fire_disarm",
		"modifier_nevermore_requiem_fear",
		"modifier_custom_void_remnant_target"

}

--for _,i in ipairs(mod) do 
	--if unit:HasModifier(i) then 
		--return true
	--end
--end
  for _, mod in pairs(unit:FindAllModifiers()) do
        if mod:GetName() ~= "modifier_alchemist_chemical_rage_custom" then
           -- if mod.CheckState then
                local tables = {}
                mod:CheckStateToTable(tables)
                for state_name, mod_table in pairs(tables) do
                    if tostring(state_name) == '1'  then
                         return true
                    end
                end
            --end
        end
    end
return false
end





function my_game:BreakInvis( unit )
if not IsServer() then return end

local mod = {
		"modifier_item_trickster_cloak_invis",
		"modifier_invisible"

}

for _,i in ipairs(mod) do 
	if unit:HasModifier(i) then 
		unit:RemoveModifierByName(i)
	end
end

end


function my_game:OnPlayerLevelUp( param )
 


end

function my_game:GetUpgradeStack( player, mod )
	local modifier = player:FindModifierByName(mod)
	if modifier then
		return modifier:GetStackCount()
	else
	return 0
	end

end

function my_game:regaUpgradeIllusion(mod, stack, illusion , player )
if not IsServer() then return end
for _,mod in pairs(player:FindAllModifiers()) do

	if mod.StackOnIllusion ~= nil then 
	if mod.StackOnIllusion == true then


	end
end

end

end




function my_game:BluePoints( unit )
if not IsServer() then return end
name = unit:GetUnitName()



if name == "npc_dota_neutral_kobold" then return 2 end
if name == "npc_dota_neutral_kobold_tunneler" then return 4 end

if	name == "npc_dota_neutral_kobold_taskmaster" then return 7 end 

if	name == "npc_dota_neutral_forest_troll_berserker" then return 5 end
if	name == "npc_dota_neutral_forest_troll_high_priest" then return 6 end 

if	name == "npc_dota_neutral_harpy_scout" then return 5 end 
if	name == "npc_dota_neutral_harpy_storm" then return 7 end

if	name == "npc_dota_neutral_gnoll_assassin" then return 6 end 

if	name == "npc_dota_neutral_ghost" then return 8 end 
if	name == "npc_dota_neutral_fel_beast" then return 4 end 



if name == "npc_dota_neutral_centaur_outrunner" then return 11 end

if	name == "npc_dota_neutral_alpha_wolf" then return 10 end
if	name == "npc_dota_neutral_giant_wolf" then return 5 end

if	name == "npc_dota_neutral_satyr_soulstealer" then return 6 end
if name == "npc_dota_neutral_satyr_trickster" then return 5 end

if	name == "npc_dota_neutral_mud_golem" then return 7 end
if	name == "npc_dota_neutral_mud_golem_split" then return 2 end

if	name == "npc_dota_neutral_ogre_magi" then return 7 end
if	name == "npc_dota_neutral_ogre_mauler" then return 7 end 





if name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then return 17 end
if	name == "npc_dota_neutral_polar_furbolg_champion" then return 13 end

if	name == "npc_dota_neutral_satyr_hellcaller" then return 19 end

if	name == "npc_dota_neutral_centaur_khan" then return 10 end

if	name == "npc_dota_neutral_wildkin" then return 16 end 
if	name == "npc_dota_neutral_enraged_wildkin" then return 7 end

if	name == "npc_dota_neutral_dark_troll" then return 7 end
if	name == "npc_dota_neutral_dark_troll_warlord" then return 16 end 

if	name == "npc_dota_neutral_warpine_raider" then return 15 end



if name == "npc_dota_neutral_black_dragon" then return 25 end
if	name == "npc_dota_neutral_black_drake" then return 15 end

if	name == "npc_dota_neutral_granite_golem" then return 21 end
if	name == "npc_dota_neutral_rock_golem" then return 16 end

if	name == "npc_dota_neutral_big_thunder_lizard" then return 20 end
if	name == "npc_dota_neutral_small_thunder_lizard"  then return 17 end  

if	name == "npc_dota_neutral_frostbitten_golem" then return 16 end
if	name == "npc_dota_neutral_ice_shaman"  then return 21 end  



if name == "npc_filler_dire_stun" then return 40 end
if name == "npc_filler_dire_plasma" then return 40 end
if name == "npc_filler_dire_resist" then return 40 end
if name == "npc_filler_radiant_stun" then return 40 end
if name == "npc_filler_radiant_plasma" then return 40 end
if name == "npc_filler_radiant_resist" then return 40 end


end 

function my_game:IsAncientCreep( unit )
if not IsServer() then return end
name = unit:GetUnitName()
if name == "npc_dota_neutral_black_dragon" 
or	name == "npc_dota_neutral_black_drake" 
or	name == "npc_dota_neutral_granite_golem"
or	name == "npc_dota_neutral_rock_golem" 
or	name == "npc_dota_neutral_big_thunder_lizard" 
or	name == "npc_dota_neutral_small_thunder_lizard"  then return true end  

return false 
end

function my_game:RandomID()

	local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


function my_game:OnGameRulesStateChange()
	my_game:UpdateMatch(true)


	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		for id = 0, 24 do
			if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
				_G.PlayerCount = _G.PlayerCount + 1


				PartyTable[id] = tostring(PlayerResource:GetPartyID(id))

				CustomNetTables:SetTableValue(
					"reports",
					tostring(id),
					{
						report = 1
					}
				)
			end
		end
	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		CustomNetTables:SetTableValue(
			"custom_pick",
			"pick_state",
			{
				in_progress = true,
				avg_rating = avg_rating
			}
		)
	
		GameRules:SetGameTimeFrozen(true)
	
		Timers:CreateTimer(
			"",
			{
				useGameTime = false,
				endTime = 1,
				callback = function()
					local position = Vector(0, 0, 343) + RandomVector(RandomInt(-1, 1) + 400)
	
					local p =
						FindUnitsInRadius(
						DOTA_TEAM_NOTEAM,
						Vector(0, 0, 0),
						nil,
						FIND_UNITS_EVERYWHERE,
						DOTA_UNIT_TARGET_TEAM_BOTH,
						DOTA_UNIT_TARGET_HERO,
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
						0,
						false
					)
	
					for _, player in ipairs(p) do
						player:SetAbsOrigin(position)
						FindClearSpaceForUnit(player, position, true)
					end
	
					hero_select:init()
				end
			}
		)
	end	
end

function my_game:start_game()
--Timers:CreateTimer("", {useGameTime = false, endTime = 5, callback = function() 

if not game_start then 


	for id = 1,20 do

		--PlayerResource:SetCustomBuybackCooldown(id, 9999)
		--PlayerResource:SetCustomBuybackCost(id, 30)

	end



	game_start = true 
	local  fillers = FindUnitsInRadius(0, Vector(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

 	for _,i in ipairs(fillers) do  
		local effect_name = '' 
  		i:RemoveModifierByName("modifier_invulnerable")
  		if i:GetUnitName() == "npc_filler_radiant_resist" then
  			effect_name = "particles/radiant_resist.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_radiant_stun" then
  			effect_name = "particles/radiant_stun.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_radiant_plasma" then
  			effect_name = "particles/radiant_plasma.vpcf"
  		end


  		if i:GetUnitName() == "npc_filler_dire_resist" then
  			effect_name = "particles/dire_resist.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_dire_stun" then
  			effect_name = "particles/dire_stun.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_dire_plasma" then
  			effect_name =  "particles/world_shrine/dire_shrine_ambient.vpcf"
  		end

  		if effect_name ~= '' then 
			i.effect = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, i)
		end
    end

	GameRules:GetGameModeEntity():SetThink( check_death, "check_tower_timer", 0 )
	GameRules:GetGameModeEntity():SetThink( spawn_timer, "check_wave_timer", 1 )
	CreateModifierThinker(nil, nil, "modifier_mob_thinker", {}, Vector(), DOTA_TEAM_NEUTRALS, false)

	my_game:initiate_tower()
	my_game:initiate_waves()



	if (IsInToolsMode() or GameRules:IsCheatMode() or not Http:IsValidGame(PlayerCount)) or (enable_pause) then 
		GameRules:GetGameModeEntity():SetPauseEnabled( true )
	end




	GameRules:ForceGameStart()
  	for _, player in pairs(players) do
        player:Stop()
    end


	Timers:CreateTimer("", {useGameTime = false, endTime = 1,
	 callback = function()
	 	GameRules:SpawnNeutralCreeps()
		GameRules:SetTimeOfDay(0.25)
		GameRules:SetGameTimeFrozen(false)

		
		CustomGameEventManager:Send_ServerToAllClients( 'init_chat', {tools = IsInToolsMode(), cheat = GameRules:IsCheatMode(), valid = Http:IsValidGame(PlayerCount)} )


		if not Http:IsValidGame(PlayerCount) then 
   		   Timers:CreateTimer(1,function() 
			CustomGameEventManager:Send_ServerToAllClients( 'alert_notvalid', {} ) 
			end)	 
   		else 
   		   Timers:CreateTimer(1,function()
			CustomGameEventManager:Send_ServerToAllClients( 'alert_dont_leave', {} )

			if Server_data.is_match_made == false then 
				CustomGameEventManager:Send_ServerToAllClients( 'RatingAlert', {} )
			end

   		    check_reports() 

   			end)



   		end
	end})


end

--end}) 

end



function check_reports()
	for _, server_player in pairs(Server_data.players) do

		local player = nil

		if server_player.PlayerID then 
			player = players[PlayerResource:GetTeam(server_player.PlayerID)]
		end

		if player ~= nil then
			player.banned = server_player.is_banned
			for other_player, report_count in pairs(server_player.reports) do
				local other_pid = FindPlayerByAccountID(other_player)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(server_player.PlayerID), 'report_alert',  {
			   	 id = other_pid,
			   	 number = report_count,
			   	 max = 7
				})
				if report_count > player.reports then
					player.reports = report_count
					player.teammate = other_pid
				end
			end
		end
	end
end



function my_game:DestroyRoshan()

CustomGameEventManager:Send_ServerToAllClients( 'roshan_hide', {} )
Active_Roshan = false	
end


 function my_game:OnItemPickUp( event )
local item = EntIndexToHScript( event.ItemEntityIndex )

    local owner
    if event.HeroEntityIndex then
        owner = EntIndexToHScript(event.HeroEntityIndex)
    elseif event.UnitEntityIndex then
        owner = EntIndexToHScript(event.UnitEntityIndex)
    end

    if not owner:IsRealHero() then return end

if event.itemname == "item_aegis" then
    UTIL_Remove( item )
    owner:AddNewModifier(owner, nil, "modifier_aegis_custom", {duration = 300})
end




if not players[owner:GetTeamNumber()].IsChoosing then 
   
	local after_legen = false
	if item.after_legen == true then 
		after_legen = true
	end


    if event.itemname == "item_gray_upgrade" then
   	 		upgrade:init_upgrade(owner,1,nil,after_legen)
        	UTIL_Remove( item )
    end

    if event.itemname == "item_blue_upgrade" then
   	 		upgrade:init_upgrade(owner,2,nil,after_legen)
       		 UTIL_Remove( item )
    end
    if event.itemname == "item_purple_upgrade" then
   	 		upgrade:init_upgrade(owner,3,nil,after_legen)
       		 UTIL_Remove( item )

    end
    if event.itemname == "item_purple_upgrade_shop" then
   	 		upgrade:init_upgrade(owner,3,nil,true)
       		 UTIL_Remove( item )

    end
    if event.itemname == "item_legendary_upgrade" then
   	 		upgrade:init_upgrade(owner,4,nil,after_legen)		
        	UTIL_Remove( item )	
    end
        
end	



end





duel_fields = 
{
	{2544, -6418, 215,  3983, -6418, 215, 4494, 2147, -5747, -7103, 215},
	{-6231, 2413, 215, -6231, 3843, 215, -5536, -7073, 4356, 2016, 215},
	{6530, -2364, 215, 6530, -3828, 215, 7300, 5728, -2016, -4506, 215},
	{-2259, 6413, 215, -3733, 6413, 215, -1888, -4264, 7103, 5501, 215}
}




function _G.Check_position(i)


local point = i:GetAbsOrigin()
local change = false  



if i:GetAbsOrigin().z < -1000 then 
	point.z = i.z
	change = true
end 

if i:GetAbsOrigin().x > i.x_max then 
	point.x = i.x_max - 200
	change = true
end

if i:GetAbsOrigin().x < i.x_min then 
	point.x = i.x_min + 200
	change = true
end

if i:GetAbsOrigin().y > i.y_max then 
	point.y = i.y_max - 200
	change = true
end

if i:GetAbsOrigin().y < i.y_min then 
	point.y = i.y_min + 200 
	change = true	
end   

if change == true then 
	i:SetAbsOrigin(point)
	FindClearSpaceForUnit(i, point, true)
end




end

function _G.EndAllCooldowns(caster)

local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

for _,thinker in pairs(thinkers) do 
	UTIL_Remove(thinker)
end


local all_units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

for _,unit in pairs(all_units) do 
  if unit:GetUnitName() == "npc_dota_wraith_king_skeleton_warrior_custom" or
  	unit:GetUnitName() == "npc_dota_wraith_king_skeleton_ghost_custom" then 
  		UTIL_Remove(unit)
  	end
end

for i = 0,caster:GetAbilityCount()-1 do
    	local a = caster:GetAbilityByIndex(i)
    
    	if not a or a:GetName() == "ability_capture" then break end

    	if a:GetName() == "skeleton_king_vampiric_aura_custom" then 
    		a:SetActivated(true)
    	end 

		if a:GetToggleState() then 
  			a:ToggleAbility()
  		end 
      
	
end

for i = 0, 8 do
	local current_ability = caster:GetAbilityByIndex(i)

		if current_ability then
			current_ability:EndCooldown()
			current_ability:RefreshCharges()
		end
end



for i = 0, 8 do
	local current_item = caster:GetItemInSlot(i)
	

	if current_item then	
		if current_item:GetName() ~= "item_refresher_custom" then 
			current_item:EndCooldown()		
		end
		if current_item:GetName() == "item_aegis" then 
			current_item:Destroy()
		end
	end
end


local neutral = caster:GetItemInSlot(16) 
if neutral then
	neutral:EndCooldown()
end



end

function _G.Destroy_Wave_Creeps()

local wave_creeps = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
for _,wave_creep in ipairs(wave_creeps) do
	if not wave_creep:IsNull() and wave_creep:GetTeamNumber() == 10 and wave_creep:IsAlive() then 
		wave_creep:ForceKill(false)
	end
end

end


function _G.Destroy_All_Units(caster)

local all_units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 0, false)
for _,unit in ipairs(all_units) do
	if not unit:IsNull() and unit:IsAlive() and not unit:IsRealHero() then 
		
		if unit:IsCourier() then 
			unit:AddNewModifier(unit, nil, "modifier_stunned", {})		
		else
			unit:ForceKill(false)
		end

	end
end

end


function _G.finish_duel()
new_round = true
duel_in_progress = false 
MaxTimer = round_timer

local hero1 = Duel_Hero[1]
local hero2 = Duel_Hero[2]
hero1:AddNewModifier(hero1, nil, "modifier_duel_finish", {})
hero2:AddNewModifier(hero2, nil, "modifier_duel_finish", {})

local winner = nil 
local loser = nil

if hero1:IsAlive() and hero2:IsAlive() then 

	if hero1:GetHealthPercent() > hero2:GetHealthPercent() then 
		winner = hero1
		loser = hero2
	end

	if hero1:GetHealthPercent() < hero2:GetHealthPercent() then 
		winner = hero2
		loser = hero1
	end

	if hero1:GetHealthPercent() == hero2:GetHealthPercent() then 

		if hero1:GetHealth() >= hero2:GetHealth() then 
			winner = hero1
			loser = hero2
		else 
			winner = hero2
			loser = hero1
		end

	end

else 

	if not hero1:IsAlive() then 
		winner = hero2
		loser = hero1
	else 
		winner = hero1
		loser = hero2
	end
end

local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
winner:EmitSound("Hero_LegionCommander.Duel.Victory")

local mod = winner:FindModifierByName("modifier_final_duel")


if mod then 
	mod:SetStackCount(mod:GetStackCount() + 1)

	if mod:GetStackCount() == wins_for_win then 
		my_game:destroy_player(loser:GetTeamNumber())
	end
end




end


function my_game:DestroyPatrol()
if not IsServer() then return end

local patrols = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,patrol in pairs(patrols) do
	if patrol:GetUnitName() == "patrol_melee_good" or
		 patrol:GetUnitName() == "patrol_melee_bad" or
		  patrol:GetUnitName() == "patrol_range_good" or
		   patrol:GetUnitName() == "patrol_range_bad" then 
		patrol:ForceKill(false)
	end
end


end


function MaxTime(n)
local t = 70
if n == 1 then t = 20 end 
if n >= 9 then t = 120 end
if n >= 15 then t = 150 end
if n >= 20 then t = 180 end
return t
end



my_game.patrol_drop_first = 
{
	"item_ward_observer",
	"item_repair_patrol",
	"item_contract",
	"item_smoke_of_deceit",
	"item_patrol_midas",

}


my_game.patrol_drop_second = 
{
	"item_patrol_upgrade",
	"item_patrol_razor",
	"item_patrol_grenade",
	"item_trap_custom",
	"item_patrol_respawn",
}

function spawn_timer()

if (not IsInToolsMode() and not GameRules:IsCheatMode() and Http:IsValidGame(PlayerCount)) and (not enable_pause) then 
 
	local should_pause = false
	
	for id = 0,24 do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0  then 
	
	
			local state = PlayerResource:GetConnectionState(id)
			local hero = PlayerResource:GetSelectedHeroEntity(id)
	
			if hero ~= nil and players[hero:GetTeamNumber()] ~= nil then  
	
				local player = players[hero:GetTeamNumber()]
			
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "pause_info_timer", {time = player.pause_time} )
	
	 
				if player.pause_time > 0 and state == DOTA_CONNECTION_STATE_DISCONNECTED and GameRules:GetDOTATime(false, false) > 1 then
	
					should_pause = true
	
					local time = players[hero:GetTeamNumber()].pause_time
					local hero_name = players[hero:GetTeamNumber()]:GetUnitName()
	
					CustomGameEventManager:Send_ServerToAllClients( 'pause_think', {time = time, id = id, player = SelectedHeroes[id]} )
			
					player.pause_time = player.pause_time - 1
				else
					CustomGameEventManager:Send_ServerToAllClients( 'pause_end', {id = id} )
				end
		
	
			end
	
		
		end
	end
	
	if GameRules:IsGamePaused() == true then 
		if should_pause == false then 
			PauseGame(false)
		end
	else 
		if should_pause == true  then 
			PauseGame(true)
		end
	end

end

if GameRules:IsGamePaused() == true then return 1 end



if Game_end == true then return -1 end




local net = {}
local j = 0
local b = 0


	
local max_net = 0
local max_team = 0	

for i = 1,11 do 
	if players[i] ~= nil then 

		if players[i].left_game == true then 
			players[i].left_game_timer = players[i].left_game_timer - 1
		end

		j = j + 1
		net[j] = {}
		net[j][1] = PlayerResource:GetNetWorth(players[i]:GetPlayerID())
		net[j][2] = players[i]:GetTeamNumber()

		if max_net < net[j][1] then 
			max_net = net[j][1]
			max_team = i
		end

	end 
end


	
for i = 1,11 do 
	if players[i] ~= nil then 

	   players[i].on_streak = false 
	   	if i == max_team then 
	   		players[i].on_streak = true
	   	end

	end 
end



if test then
	net[2] = {}
	net[2][1] = 12000
	net[2][2] = 3
end




local low_net = 0

if #net > 3 or (test and #net > 1) then 

  	  for j = 1,#net-1 do
   		 for i = 1,#net-j do
 			if net[i][1] > net[i+1][1] then 
 				b = net[i]
 				net[i] = net[i+1]
 				net[i+1] = b
 			end	
  		 end
	  end

	

	if (net[2][1] - net[1][1])/net[1][1] > low_net_diff then 
		low_net = net[1][2]
	end

	if (my_game.current_wave + 1) > 8 then 

		for i = 1, math.floor(#net/2) do
			if players[net[i][2]] ~= nil then 
				players[net[i][2]].givegold = true
			end
		end 
	end



	if Target_count < #Target_timers - 1 and GameRules:GetDOTATime(false, false) >= Target_timers[Target_count + 2] then 
		Target_count = Target_count + 1
	end


	if #net >= 4 and GameRules:GetDOTATime(false, false) < Target_max_timer and Target_count < #Target_timers and GameRules:GetDOTATime(false, false) >= Target_timers[Target_count + 1] then 

		local first_player = players[net[#net][2]]
		local diff = net[#net][1]/net[#net-1][1]

		if first_player and diff >= Target_gold and first_player:IsAlive() and not first_player:HasModifier("modifier_target") then
			Target_count = Target_count + 1 
			first_player:AddNewModifier(first_player, nil, "modifier_target", {duration = Target_duration})
		end
	end

end 




for id = 0,24 do 
	if PlayerResource:IsValidPlayerID(id) and (PlayerResource:GetSteamAccountID(id) ~= 0 or IsInToolsMode())  then 
	
		local team = PlayerResource:GetTeam(id)

		if GameRules:GetDOTATime(false, false) >= Player_damage_time and GameRules:GetDOTATime(false, false) < Player_damage_time + 3 then 
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			
			if hero then 
				if hero:HasModifier("modifier_player_damage") then 
					hero:RemoveModifierByName("modifier_player_damage")
				end
			end

			if players[team] ~= nil then 
				players[team].damages = {0,0,0,0,0,0,0,0}
			end
		end

		if players[team] ~= nil then 

			local hero = PlayerResource:GetSelectedHeroEntity(id)
			local hero_has_aegis = false
			players[team].no_purple = false
			players[team].lowest_net = 0

			local no_purple = 0

			if team == low_net then 
				players[team].lowest_net = 1
			end

			if my_game.current_wave >= 8 and #net > 4 and GameRules:GetDOTATime(false, false) < low_net_time then 
				if team == low_net then 
					--no_purple = 1
				--	players[team].no_purple = true
				end
			end


			if hero then 
				hero_has_aegis = hero:HasModifier("modifier_aegis_custom")
			end

			if hero then 
				no_buyback = hero.no_buyback
			end

			local hero_kills_table = nil
			if GameRules:GetDOTATime(false, false) < Player_damage_time then 
				hero_kills_table = players[team].hero_kills
			end

			CustomNetTables:SetTableValue("networth_players", tostring(id), {team = team, no_buyback = no_buyback, net = PlayerResource:GetNetWorth(id), damages = players[team].damages, hero_kills = hero_kills_table, streak = players[team].on_streak, hero_has_aegis = hero_has_aegis})	
			
		end
	end 
end




if GameRules:GetDOTATime(false, false) >= give_all_vision_time and init_vision == false then 

	init_vision = true 

	for i = 1,11 do 
		if players[i] ~= nil then 

			for j = 1,11 do
				if players[j] ~= nil and j ~= i then 

					local team_viewer = tonumber(teleports[j]:GetName())



					local Vector_fow = Vector(vision_abs[team_viewer][1],vision_abs[team_viewer][2],vision_abs[team_viewer][3])
					AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][4], 99999, true)

					Vector_fow = Vector(vision_abs[team_viewer][5],vision_abs[team_viewer][6],vision_abs[team_viewer][7])
					AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][8], 99999, true)

					Vector_fow = towers[j]:GetAbsOrigin()
					AddFOWViewer(i, Vector_fow, 1000, 99999, true)

				end
			end
		end
	end
end  


if GameRules:GetDOTATime(false, false) >= patrol_first_tier and  patrol_first_init == false then 

	patrol_first_init = true 

	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 1, items = my_game.patrol_drop_first} )
end  

if GameRules:GetDOTATime(false, false) >= patrol_second_tier and  patrol_second_init == false then 

	patrol_second_init = true 

	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 2, items = my_game.patrol_drop_second} )
end  



for _,i in pairs(players) do
	if i ~= nil and not i:HasModifier("modifier_final_duel") then
		Check_position(i)
	end
end

roshan_timer = roshan_timer + 1


if GameRules:GetDOTATime(false, false) >= bounty_start and bounty_init == false then 
	bounty_init = true 

	for i = 1,#bounty_abs do 
		local b_thinker = CreateUnitByName("npc_bounty_thinker", bounty_abs[i], false, nil, nil, DOTA_TEAM_CUSTOM_6)
		b_thinker:AddNewModifier(b_thinker, nil, "modifier_bounty_map", {})

	end
end


if bounty_timer >= bounty_max_timer and GameRules:GetDOTATime(false, false) >= bounty_start then 
	bounty_timer = 0

	for i = 1,#bounty_abs do 

		local near_rune = Entities:FindByModelWithin(nil, "models/props_gameplay/rune_goldxp.vmdl", bounty_abs[i], 200)
		if not near_rune then
			CreateRune(bounty_abs[i], DOTA_RUNE_BOUNTY)  
		end

	end
end
bounty_timer = bounty_timer + 1 



if false and Active_Roshan == false and roshan_number < #RoshanTimers then 

	if (RoshanTimers[roshan_number] - roshan_alert) < roshan_timer and RoshanTimers[roshan_number] > roshan_timer then 
		local time = RoshanTimers[roshan_number] - roshan_timer
		CustomGameEventManager:Send_ServerToAllClients( 'roshan_timer', {time = time, number = roshan_number} )

		if time == PortalDelay then 


			local teleport_center = CreateUnitByName("npc_dota_companion", Vector(41,140,343), false, nil, nil, 0)
   			teleport_center:AddNewModifier(teleport_center, nil, "modifier_phased", {})
    		teleport_center:AddNewModifier(teleport_center, nil, "modifier_invulnerable", {})
    		teleport_center:AddNewModifier(teleport_center, nil, "modifier_unselect", {})


    		teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")


			teleport_center.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
        	ParticleManager:SetParticleControl( teleport_center.nWarningFX, 0, Vector(41,140,440) )


        	Timers:CreateTimer(PortalDelay+0.3,function()
	         	ParticleManager:DestroyParticle(teleport_center.nWarningFX, true)
	         	teleport_center:StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")
    			teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")
         		teleport_center:Destroy()
       		 end)

        end	

 	end


 	if (RoshanTimers[roshan_number] == roshan_timer) then

   		local unit = CreateUnitByName("npc_roshan_custom", Vector(41,140,343), true, nil, nil, DOTA_TEAM_CUSTOM_5)
   		unit:AddNewModifier(unit, nil, "modifier_roshan_upgrade", {number = roshan_number})
   		unit:FaceTowards(Vector(-10,-10,343))
   		unit.number = roshan_number

 		roshan_number = roshan_number + 1
   		Active_Roshan = true

		local rosh = ParticleManager:CreateParticle("particles/neutral_fx/roshan_spawn.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(rosh, 0, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(rosh)

		unit:AddNewModifier(unit, nil, "modifier_roshan_custom_spawn", {duration = 5})
   		
		CustomGameEventManager:Send_ServerToAllClients( 'roshan_spawn', {} )
	end

end


if not duel_prepair and not duel_in_progress then 
	MaxTimer = MaxTime(my_game.current_wave + 1)

	if test then
		if my_game.current_wave + 1 == start_wave + 1 then 
			MaxTimer = timer_test_start
		else  
			MaxTimer = timer_test
		end
	end 
end

if duel_in_progress then 
	MaxTimer = duel_timer_progress
end

timer = timer + 1

local active_necro = true
if MaxTimer - timer <= Necro_Timer then 
	active_necro = false
end

for i = 1,12 do 
	if players[i] ~= nil then 
		players[i].active_necro = active_necro
	end
end

if patrol_wave <= my_game.current_wave and not duel_prepair and not duel_in_progress and GameRules:GetDOTATime(false, false) >= patrol_second_tier then 
	
	if my_game.radiant_patrol_alive == false and my_game.dire_patrol_alive == false then 
		
		local time = patrol_timer_max - (timer)

		if time >= 0 then 
			CustomGameEventManager:Send_ServerToAllClients( 'patrol_timer', {time = time} )
		end
	end

end


if patrol_wave <= my_game.current_wave and timer + PortalDelay == patrol_timer_max and not duel_prepair and not duel_in_progress then 



	if my_game.patrol_dontgo_dire == true or my_game.patrol_dontgo_radiant == true then 
		if my_game.dire_patrol_alive == false then 
			my_game:patrol_portal(2) 
		end
	else 
	
		if my_game.radiant_patrol_alive == false and my_game.patrol_dontgo_radiant== false then 	
			my_game:patrol_portal(0)
		end
		if my_game.dire_patrol_alive == false and my_game.patrol_dontgo_dire == false then 
			my_game:patrol_portal(1)
		end

	end
end


if patrol_wave <= my_game.current_wave and timer == patrol_timer_max and not duel_prepair and not duel_in_progress  then 



	local drop = my_game.patrol_drop_first

	local second_tier = false 
	local center_patrol = false
	my_game.ravager_max = 12

	if my_game.patrol_dontgo_dire == true or my_game.patrol_dontgo_radiant == true then
		center_patrol = true
		my_game.ravager_max = 6
	end 




	if GameRules:GetDOTATime(false, false) >= patrol_second_tier then 
		CustomGameEventManager:Send_ServerToAllClients( 'patrol_count', {count =  my_game.ravager_max, max = my_game.ravager_max} )
		drop = my_game.patrol_drop_second
		second_tier = true
	end


	local item_1 = RandomInt(1, #drop)

	local item_2 = item_1

	repeat item_2 = RandomInt(1, #drop)
	until item_2 ~= item_1
 

	if center_patrol then 

		if my_game.dire_patrol_alive == false then 
			
			my_game.dire_patrol_alive = true
			my_game:spawn_patrol(RandomInt(0,1 ), drop[item_1], drop[item_2],second_tier, true)

		end

	else 

		item_2 = ""

		if my_game.radiant_patrol_alive == false and my_game.patrol_dontgo_radiant == false then 
		
			my_game.radiant_patrol_alive = true
			my_game:spawn_patrol(0, drop[item_1], drop[item_2],second_tier, false)
		end
   	
		if my_game.dire_patrol_alive == false and my_game.patrol_dontgo_dire == false then 
		
			my_game.dire_patrol_alive = true
			my_game:spawn_patrol(1, drop[item_1], drop[item_2],second_tier, false)

		end

	end 



	

	my_game.current_patrol = my_game.current_patrol + 1 
	if my_game.current_patrol == 4 then 
		my_game.current_patrol = 1
	end

end





local hide = false

if init_duel == true then 
	init_duel = false

	hide = true
	duel_prepair = true 
	MaxTimer = duel_timer
	timer = 0
end

if new_round == true then 
	new_round = false
	duel_prepair = true 
	MaxTimer = round_timer
	timer = 0
end


if timer + 10 == MaxTimer and not duel_prepair and not duel_in_progress then 
	for _,i in pairs(players) do
		if i ~= nil then	
			local table_tips = CustomNetTables:GetTableValue("TipsType", tostring(i:GetPlayerID()))
			local count = 0
			local teleport = teleports[i:GetTeamNumber()]:GetName()
			teleport = tonumber(teleport)
			if table_tips.type == 2 or table_tips.type == 3 then
				Timers:CreateTimer(0, function()
					GameRules:ExecuteTeamPing( i:GetTeamNumber(), vision_abs[teleport][1], vision_abs[teleport][2], i, 0 )
					count = count + 1
					if count <= 2 then
						return 1.5
					end
				end)
			end
			if table_tips.type == 3 then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i:GetPlayerID()), "TipForPlayer", {duration = 10, text = "#Tip_WaveStart"})
			end
		end
	end	
end






if timer + PortalDelay == MaxTimer and not duel_prepair and not duel_in_progress then 
	for _,i in pairs(players) do
		if i ~= nil then	
			my_game:spawn_portal(i:GetTeamNumber())
		end
	end	
end



local number_wave = 0
local go_boss = false




if timer == MaxTimer then 

	if duel_in_progress == false then 

		if duel_prepair == false then 

			my_game.current_wave = my_game.current_wave + 1


			for n = 1,#Wave_boss_number do 
				if my_game.current_wave == Wave_boss_number[n] then
					go_boss = true
					break
				end 
			end

			if go_boss then 
				my_game.go_boss_number = my_game.go_boss_number + 1
				number_wave = my_game.go_boss_number
			else 
				my_game.go_wave = my_game.go_wave + 1
				number_wave = my_game.go_wave
			end

			my_game:DestroyPatrol()

			for i = 1,12 do
				if players[i] ~= nil then	

		

					local necro = false 

					if players[i].necro_wave == true then 
						necro = true 
						players[i].necro_wave = false
					end

					local give_lownet = 0
					if players[i].lowest_net == 1 and (my_game.current_wave == low_net_waves[1] or my_game.current_wave == low_net_waves[2]) then 
						give_lownet = 1
					end


					my_game:spawn_wave(i, number_wave, go_boss, necro, give_lownet)

					


					if  towers[i] ~= nil and my_game.current_wave < 25 and my_game.current_wave > 1 then 
 						towers[i]:AddNewModifier(players[i], nil, "modifier_tower_level", {})
					end
				end
			end

			if my_game.go_wave == #waves then my_game.go_wave = 0 end
		else 

			duel_prepair = false
			duel_in_progress = true
			Destroy_Wave_Creeps()	

			MaxTimer = duel_timer_progress

			Duel_round = Duel_round + 1

			if field == 0 then 
				field = RandomInt(1, #duel_fields)
			end

			local start_points = {}
			start_points[1] = Vector(duel_fields[field][1],duel_fields[field][2],duel_fields[field][3])
			start_points[2] = Vector(duel_fields[field][4],duel_fields[field][5],duel_fields[field][6])
			local x_max = duel_fields[field][7]
			local x_min = duel_fields[field][8]
			local y_max = duel_fields[field][9]
			local y_min = duel_fields[field][10]
			local z_coord = duel_fields[field][11]

			local wall_start = {}
			local wall_end = {}

			wall_start[1] =  Vector(x_max,y_min,z)
			wall_end[1] = Vector(x_min,y_min,z)
			wall_start[2] = Vector(x_max,y_max,z)
			wall_end[2] = Vector(x_min,y_max,z)
			wall_start[3] = Vector(x_max,y_min,z)
			wall_end[3] = Vector(x_max,y_max,z)
			wall_start[4] = Vector(x_min,y_min,z)
			wall_end[4] = Vector(x_min,y_max,z)



			for w = 1, 4 do 

				if wall_particle[w] ~= nil then 
					ParticleManager:DestroyParticle(wall_particle[w], false)
					ParticleManager:ReleaseParticleIndex(wall_particle[w])
				end

				wall_particle[w] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(wall_particle[w], 0, wall_start[w])
				ParticleManager:SetParticleControl(wall_particle[w], 1, wall_end[w])

			end


			local n = 0

			for _,i in pairs(players) do
				if i ~= nil then	
					n = n + 1


					i.x_max = x_max
					i.x_min = x_min
					i.y_max = y_max
					i.y_min = y_min
					i.z = z_coord

					Destroy_All_Units(i)



    				local name = "spawn".. i:GetTeamNumber()
   					local spawner =  Entities:FindByName( nil, name )
    
    				spawner:SetAbsOrigin(start_points[n])

					if not i:IsAlive() then 
						i:RespawnHero(false, false)
					end


					i:Stop()
					i:SetAbsOrigin(start_points[n])
					FindClearSpaceForUnit(i, start_points[n], true)	
					PlayerResource:SetCameraTarget(i:GetPlayerID(), i)

					
					i:AddNewModifier(i, nil, "modifier_final_duel", {}) 


					if i:HasModifier("modifier_duel_finish") then
						i:RemoveModifierByName("modifier_duel_finish")
					end

				

					if n == 1 then 
                 		i:SetForwardVector(start_points[2] - start_points[1])
					else 
						
                 		i:SetForwardVector(start_points[1] - start_points[2])
					end

				end
			end


		end

	else 
		finish_duel()
	end


	timer = 0
end 


local next_boss = false
local next_wave_number = 0

for n = 1,#Wave_boss_number do 

	if my_game.current_wave + 1 == Wave_boss_number[n] then
		next_boss = true
		break

	end 
end


if next_boss then 
	next_wave_number = my_game.go_boss_number + 1
else 
	next_wave_number = my_game.go_wave + 1
end




local next_wave = my_game:GetWave(next_wave_number, next_boss)
local skills = my_game:GetSkills(next_wave_number, next_boss)
local mkb = my_game:GetMkb(next_wave_number, next_boss)
	


for id = 0,24 do 

	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0   then  

		local can_display = false 
		local givegold = false
		local reward = 0
		local necro = 0
		local upgrade = 0

		if PlayerResource:GetSelectedHeroEntity(id) ~= nil then 

			local team = PlayerResource:GetSelectedHeroEntity(id):GetTeamNumber()

			if players[team] ~= nil then 

				players[team].reward  = 1

				if (my_game.current_wave + 1) == Purple_Wave[1] or (my_game.current_wave + 1) == Purple_Wave[2]  then players[team].reward = 3  end

				local second_orange = 0

				if players[team].orange_count < 2 then 

					second_orange =  Wave_boss_number[2]
					if players[team]:HasModifier("modifier_up_orangepoints") and my_game.current_wave < Wave_boss_number[2] then 
					
						if my_game.current_wave + 1 < upgrade_orange then 
							second_orange = upgrade_orange
						else 
							second_orange = my_game.current_wave + 1
						end
					end
				end

				if (my_game.current_wave + 1) == Wave_boss_number[1] or (my_game.current_wave + 1) == second_orange then players[team].reward = 4  end


				reward = players[team].reward
				givegold = players[team].givegold
				can_display = players[team].ActiveWave == nil
				necro = players[team].necro_wave
				upgrade = players[team].creeps_upgrade
			else 
				can_display = true
			end

		else 
			can_display = true
		end

		if ( can_display == true and not duel_in_progress) or duel_prepair then 

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'timer_progress',  {upgrade = upgrade, necro = necro ,units = -1, units_max = -1,  time = timer, max = MaxTimer, name = next_wave, skills = skills, mkb = mkb, reward = reward, gold = givegold, number = my_game.current_wave + 1, hide = hide})
		end

		if duel_in_progress or duel_prepair or hide then 

			local hero = {'',''}
			local h = 0
			for j = 1,#Duel_Hero do 
				if Duel_Hero[j] ~= nil then 
					h = h + 1
					hero[h] = Duel_Hero[j]
				end
			end

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'duel_timer_progress',  {time = timer, max = MaxTimer, hide = false, prepair = duel_prepair, round = Duel_round, hero1 = hero[1]:GetUnitName(), wins1 = hero[1]:GetUpgradeStack("modifier_final_duel"), hero2 = hero[2]:GetUnitName() ,wins2 = hero[2]:GetUpgradeStack("modifier_final_duel") ,show = hide})
		end

	end 
end

	return 1
end







function my_game:destroy_tower( t , team )

local tower = nil
if t ~= nil then 
	tower = t
end

if team ~= nil and towers[team] ~= nil then 
	tower = towers[team]
end


local fillers = FindUnitsInRadius(tower:GetTeamNumber(), tower:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
for _,i in ipairs(fillers) do
	if i ~= tower and i ~= teleports[tower:GetTeamNumber()] then 
		i:ForceKill(false)
	end
end

if teleports[tower:GetTeamNumber()] ~= nil then
	teleports[tower:GetTeamNumber()]:AddNewModifier(nil, nil, "modifier_invulnerable", {})
end

if team ~= nil then 

	if towers[team] ~= nil and towers[team]:IsAlive() then 
		towers[team]:ForceKill(false)
	end
	towers[team] = nil
end



end

function my_game:CheckParty(id)

local p = PartyTable[id]


if p == nil or p == '0' then return false end

for i,party in pairs(PartyTable) do 
	
	if party == p and i ~= id then  
		local hero = PlayerResource:GetSelectedHeroEntity(i)

		if hero ~= nil then 

			if players[hero:GetTeamNumber()] ~= nil then 
				return true
			end

		end

	end
end

return false
end


function my_game:GiveGlobalVision(kv)
	if kv.PlayerID == nil then return end

local team = PlayerResource:GetTeam(kv.PlayerID)

if my_game:CheckParty(kv.PlayerID) == true then
 CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(kv.PlayerID), "CreateIngameErrorMessage", {message = "teammate_alive"})
 return
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(kv.PlayerID), 'EndScreenClose', {})


AddFOWViewer(team,Vector(0,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(0,5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(0,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,5000,0), 10000, 99999, false) 

end
function my_game:SetPlace(player)
    if not IsServer() then return end

    local server_player = FindPlayerServerData(player:GetPlayerID())
    local rating_diff = 0
    local rating_before = 1000
    if server_player ~= nil then
        rating_before = server_player.rating
        rating_diff = rating_before - avg_rating
    end

    local change = Rating_Table[player.place]
    if not Server_data.is_match_made then
        change = 0
    end

    if not GameRules:IsCheatMode() and Http:IsValidGame(PlayerCount) then
        player.rating_change = math.floor(change)
    end

    if player.place > 2 then 
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerID()), 'EndScreenShow', {
            team = player:GetTeamNumber(),
            place = player.place,
            rating_before = rating_before,
            rating_change = player.rating_change
        })
    end
end
function my_game:destroy_player(p)
	if players[p] == nil then
		return
	end
	for _, mod in pairs(players[p]:FindAllModifiers()) do
		if mod:GetName() == "modifier_ember_spirit_fire_remnant_custom_timer" then
			mod:Destroy()
		end
	end

	if players[p]:HasModifier("modifier_aegis_custom") then
		players[p]:RemoveModifierByName("modifier_aegis_custom")
	end

	local all_illusions =
		FindUnitsInRadius(
		p,
		players[p]:GetAbsOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
		FIND_ANY_ORDER,
		false
	)

	for _, i in ipairs(all_illusions) do
		if i ~= players[p] then
			local mod = i:AddNewModifier(players[p], nil, "modifier_death", {})
			i:ForceKill(false)
			if mod then
				mod:Destroy()
			end
		end
	end

	if players[p]:IsAlive() then
		local mod = players[p]:AddNewModifier(players[p], nil, "modifier_death", {})

		for i = 0, 5 do
			local item = players[p]:GetItemInSlot(i)

			if item and item:GetName() == "item_aegis" then
				item:Destroy()
			end
		end

		players[p]:Kill(nil, nil)
	end

	--players[p]:SetUnitCanRespawn(false)
	players[p]:SetTimeUntilRespawn(-1)
	players[p]:SetBuyBackDisabledByReapersScythe(true)
	--players[p]:SetRespawnsDisabled(false)
	players[p].on_streak = false

	local id = players[p]:GetPlayerID()

	CustomNetTables:SetTableValue(
		"networth_players",
		tostring(id),
		{
			net = PlayerResource:GetNetWorth(id),
			damages = players[p].damages,
			purple = players[p].purple,
			streak = players[p].on_streak
		}
	)


  if players[p].place == -1 then
        _G.Deaths = _G.Deaths + 1
        players[p].place = PlayerCount - Deaths + 1
    end

	Deaths_Players[id] = {
		items = {},
		player = players[p]
	}
	players[p].defeated = true

	my_game:SetPlace(players[p])

    if PlayerCount == 1 then
        my_game:WinTeam(players[p])
    end

	for i = 0, 5 do
		local item = players[p]:GetItemInSlot(i)
		local name = ""
		if item then
			name = item:GetName()
		end
		Deaths_Players[id].items[#Deaths_Players[id].items + 1] = name
	end

	End_net[id] = PlayerResource:GetNetWorth(id)

	local icon_name = players[p]:GetUnitName() .. "_icon"

	local allunits =
		FindUnitsInRadius(
		DOTA_TEAM_NOTEAM,
		Vector(0, 0, 0),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE +
			DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
		0,
		false
	)

	for _, icon in ipairs(allunits) do
		if icon and not icon:IsNull() then
			if icon ~= players[p] and not icon:IsCourier() and icon:GetUnitName() ~= "npc_teleport" then
				for _, mod in pairs(icon:FindAllModifiers()) do
					if mod:GetCaster() then
						if mod:GetCaster():GetTeamNumber() == players[p]:GetTeamNumber() then
							mod:Destroy()
						end
					end
				end

				if not icon:IsNull() and icon:GetUnitName() == icon_name then
					icon:ForceKill(false)
				end
			end
		end

		if
			not icon:IsNull() and
				((icon:IsCourier() or (icon:GetUnitName() == "npc_dota_companion") or
					(icon:GetUnitName() == "npc_dota_treant_eyes")) and
					icon:GetTeamNumber() == players[p]:GetTeamNumber())
		 then
			icon:Destroy()
		end
	end

	local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

	for _, thinker in pairs(thinkers) do
		if thinker:GetTeamNumber() == players[p]:GetTeamNumber() then
			UTIL_Remove(thinker)
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("pause_end", {id = id})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "hide_pause_info_timer", {})

	

	local count = 0
	local team = {}

	for i = 1, 11 do
		if i ~= p and players[i] ~= nil then
			players[i].Players_Died = players[i].Players_Died + 1

			table.insert(team, i)
			count = count + 1
		end
	end

	if count == 3 then


		CustomGameEventManager:Send_ServerToAllClients( 'destroy_tower', {} )

		local dire_count = 0
		local radiant_count = 0

		for i = 1, 11 do
			if i ~= p and players[i] ~= nil then
				for j = 1, 11 do
					if players[j] ~= nil and j ~= p and j ~= i then
						local team_viewer = tonumber(teleports[j]:GetName())

						local Vector_fow =
							Vector(vision_abs[team_viewer][1], vision_abs[team_viewer][2], vision_abs[team_viewer][3])
						AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][4], 99999, true)

						Vector_fow =
							Vector(vision_abs[team_viewer][5], vision_abs[team_viewer][6], vision_abs[team_viewer][7])
						AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][8], 99999, true)

						Vector_fow = towers[j]:GetAbsOrigin()
						AddFOWViewer(i, Vector_fow, 1000, 99999, true)
					end
				end

				if players[i]:HasModifier("modifier_target") then
					players[i]:RemoveModifierByName("modifier_target")
				end
				local team_viewer = tonumber(teleports[i]:GetName())

				if team_viewer == 3 or team_viewer == 8 or team_viewer == 9 then
					dire_count = dire_count + 1
				else
					radiant_count = radiant_count + 1
				end
			end
		end

		if radiant_count > dire_count then
			my_game.patrol_dontgo_radiant = true
		else
			my_game.patrol_dontgo_dire = true
		end

		if dire_count == 3 then
			my_game.patrol_dontgo_radiant = true
		end

		if radiant_count == 3 then
			my_game.patrol_dontgo_dire = true
		end
	end

	if count == 2 then
		init_duel = true
		local n = 0

		for i = 1, 11 do
			if i ~= p and players[i] ~= nil then
				n = n + 1
				players[i].damages = {0, 0, 0, 0, 0, 0, 0, 0}
				towers[i]:AddNewModifier(players[i], nil, "modifier_duel_finish", {})
				CustomGameEventManager:Send_ServerToPlayer(
					PlayerResource:GetPlayer(players[i]:GetPlayerOwnerID()),
					"Attack_Base",
					{sound = "FinalDuel.Start"}
				)
				Duel_Hero[n] = players[i]
			end
		end
	end

	 if count == 1 then 
        local winner = players[team[1]]
        winner.place = 1
        my_game:SetPlace(winner)
        my_game:WinTeam(winner)
    end

    my_game:UpdateMatch(true)
    players[p] = nil
end


function my_game:start_duel()
if not IsServer() then return end
init_duel = true
	local n = 0

 local t = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_CLOSEST, false)

 for _,i in pairs(t) do 
			n = n + 1
    	 	Duel_Hero[n] = i
	end
end



_G.SelectedHeroes = {}

local couriers_spawned = {}
function check_death()
for id = 0,24 do 
 	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then 
		if not couriers_spawned[id] and SelectedHeroes[id] ~= nil then 
			local player = PlayerResource:GetPlayer(id)
			if player ~= nil then
				player:SpawnCourierAtPosition(COUR_POSITION[LOBBY_PLAYERS[id].select_base])
				couriers_spawned[id] = true
			end
		end
 	end
end

if GameRules:GetDOTATime(false, false) < 2 then return 0 end


my_game:AsyncSpawn()

for i = 1,11 do
	local tower = towers[i]
	local player = players[i]


	if tower ~= nil and player ~= nil then 

		local state = PlayerResource:GetConnectionState(player:GetPlayerID())

		if not tower:IsAlive() or state == DOTA_CONNECTION_STATE_ABANDONED or player.banned then 

			if not tower:IsAlive() then 
			 	Timers:CreateTimer(0.5, function()


					local hero_won = ''
			 		if tower.killer ~= nil then 
			 			hero_won = tower.killer:GetUnitName() 
			 		end
			 		

					CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 0, hero2 = hero_won, hero = player:GetUnitName()} )
				 end)
			else 

				if player.banned then    	
					CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 1, abbandon = 0, hero2 = '', hero = player:GetUnitName()} )
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerID()), 'banned', {reports = player.reports, id = player.teammate} )
				else
					if state == DOTA_CONNECTION_STATE_ABANDONED and player.left_game == false then 
						my_game:UpdateMatch(true)
						player.left_game = true 

						if GameRules:GetDOTATime(false, false) < LowPriorityTime and Http:IsValidGame(PlayerCount) then 

 							player.left_game = true
 						end
   		   				CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 1, hero2 = '', hero = player:GetUnitName()} )
					end
				end
			end

   		
			if player.left_game_timer < 1 or player.banned == true or not tower:IsAlive() then  
				my_game:destroy_player(i)
				my_game:destroy_tower(tower,tower:GetTeamNumber())
			end
		end




	end

end




return 0
end

function my_game:WinTeam(player)
    _G.Game_end = true
    local last_id = player:GetPlayerID()

    End_net[last_id] = PlayerResource:GetNetWorth(last_id)
    Deaths_Players[last_id] = {
        player = player,
        items = {}
    }

    for i = 0,5 do
        local item = player:GetItemInSlot(i)
        local name = ""
        if item then     
            name = item:GetName()
        end
        table.insert(Deaths_Players[last_id].items, name)
    end

    for id = 0, 24 do
        if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and Deaths_Players[id] ~= nil then
            local server_player = FindPlayerServerData(id)
            local rating = 0
            if server_player ~= nil then
                rating = server_player.rating
            end

            local r_change = Deaths_Players[id].player.rating_change
            CustomNetTables:SetTableValue(
                "networth_players",
                tostring(id),
                {
                    net = r_change,
                    purple = 0,
                    streak = false,
                    rating_before = rating,
                    rating_change = r_change,
                    items = Deaths_Players[id].items,
                    end_net = End_net[id],
                    damages = Deaths_Players[id].player.damages
                }
            )
        end
    end

    CustomNetTables:SetTableValue("networth_players", "", {game_ended = true})
end


function my_game:GetHeroType( player )
if not IsServer() then return end

if player:GetUnitName() == "npc_dota_hero_juggernaut" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_phantom_assassin" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_terrorblade" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_nevermore" then return {"mage"}  end 
if player:GetUnitName() == "npc_dota_hero_puck" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_queenofpain" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_huskar" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_bristleback" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_legion_commander" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_void_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ember_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_pudge" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_hoodwink" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_skeleton_king" then return {"melle"} end
if player:GetUnitName() == "npc_dota_hero_lina" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_troll_warlord" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_axe" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_alchemist" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ogre_magi" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_antimage" then return {"melle"} end 
if player:GetUnitName() == "npc_dota_hero_primal_beast" then return {"melle","mage"} end 
end

function my_game:GetTowerDamage( player )
if not IsServer() then return end

if player:GetUnitName() == "npc_dota_hero_juggernaut" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_phantom_assassin" then return -20  end 
if player:GetUnitName() == "npc_dota_hero_terrorblade" then return -40  end 
if player:GetUnitName() == "npc_dota_hero_nevermore" then return -20  end 
if player:GetUnitName() == "npc_dota_hero_puck" then return 10 end 
if player:GetUnitName() == "npc_dota_hero_queenofpain" then return 0 end 
if player:GetUnitName() == "npc_dota_hero_huskar" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_bristleback" then return -60 end 
if player:GetUnitName() == "npc_dota_hero_legion_commander" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_void_spirit" then return 10 end 
if player:GetUnitName() == "npc_dota_hero_ember_spirit" then return 20 end 
if player:GetUnitName() == "npc_dota_hero_pudge" then return 10 end 
if player:GetUnitName() == "npc_dota_hero_hoodwink" then return 30 end 
if player:GetUnitName() == "npc_dota_hero_skeleton_king" then return 0 end 
if player:GetUnitName() == "npc_dota_hero_lina" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_troll_warlord" then return -50 end 
if player:GetUnitName() == "npc_dota_hero_axe" then return 20 end 
if player:GetUnitName() == "npc_dota_hero_alchemist" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_ogre_magi" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_antimage" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_primal_beast" then return -20 end 

end





LinkLuaModifier( "modifier_no_vision", "modifiers/modifier_no_vision", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unselect", "modifiers/modifier_unselect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ward_stack", "modifiers/modifier_ward_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mob_thinker", "modifiers/modifier_mob_thinker", LUA_MODIFIER_MOTION_NONE )






local icons_abs = 
{
	{},
	{-6695,-6750,119},
	{6770,6706,95},
	{},
	{},
	{-6297,2778,103},
	{2849,-6383,95},
	{-2648,6426,103},
	{6520,-2632,95},

}
function CreateDamageData()
    return {
        dealt_pre_reduction = { 0, 0, 0, 0 },
        dealt_post_reduction = { 0, 0, 0, 0 },
        received_pre_reduction = { 0, 0, 0, 0 },
        received_post_reduction = { 0, 0, 0, 0 },
    }
end

function my_game:initiate_player(oplayer, pause)
    oplayer:Stop()
    players[oplayer:GetTeamNumber()] = oplayer
    oplayer.choise = {}
    oplayer.HeroType = my_game:GetHeroType(oplayer)
    oplayer.upgrades = {}
    oplayer.ban_skills = {}
    oplayer.IsChoosing = false
    oplayer.bluepoints = 0
    oplayer.purplepoints = 0
    oplayer.death = 0
    oplayer.purple = 0
    oplayer.chosen_skill = 0
    oplayer.givegold = false
    oplayer.respawn_mod = nil
    oplayer.place = -1
    oplayer.rating_change = 0
    oplayer.NeutraItems = {0, 0, 0, 0, 0}
    oplayer.bluemax = StartBlue
    oplayer.purplemax = StartPurple
    oplayer.on_streak = false
    oplayer.ActiveWave = nil
    oplayer.choise_table = {}
    oplayer.Players_Died = 0
    oplayer.banned = false
    oplayer.can_refresh_choise = false
    oplayer.no_purple = 0
    oplayer.necro_wave = false
    oplayer.active_necro = false
    oplayer.give_lownet = 0
    oplayer.lowest_net = 0

    oplayer.no_buyback = 0

    oplayer.creeps_upgrade = 0

    oplayer.left_game = false
    oplayer.left_game_timer = 60

    oplayer.pause_time = pause
    oplayer.pause = -1

    oplayer.x_min = -8100
    oplayer.x_max = 8100
    oplayer.y_min = -8100
    oplayer.y_max = 8100
    oplayer.z = 215


    oplayer.orange_count = 0

    oplayer.patrol_kills = 0
    oplayer.seconds_dead = 0
    oplayer.obs_placed = 0
    oplayer.sentry_placed = 0
    oplayer.obs_kills = 0
    oplayer.sentry_kills = 0
    oplayer.defeated = false

    oplayer.abilities = {}

    oplayer.creep_damage = CreateDamageData()
    oplayer.tower_damage = CreateDamageData()
    oplayer.hero_damage = CreateDamageData()

    oplayer.damages = {}

    oplayer.hero_kills = {}

   -- oplayer:SetBuybackCooldownTime(99999)


    for id = 0, 24 do
        if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
            oplayer.damages[id] = 0
            CustomNetTables:SetTableValue("TipsType", tostring(id), {type = FindPlayerServerData(id).tips_type})
        end
    end

    if oplayer:GetUnitName() == "npc_dota_hero_pudge" then
        local ability = oplayer:FindAbilityByName("custom_pudge_flesh_heap")
        oplayer:AddNewModifier(oplayer, ability, "modifier_custom_pudge_flesh_heap", {})
    end

    if oplayer:HasModifier("modifier_tower_damage") then
        oplayer:RemoveModifierByName("modifier_tower_damage")
    end
    oplayer:AddNewModifier(oplayer, nil, "modifier_tower_damage", {})

    oplayer.damages[0] = 0
    oplayer.damages[1] = 0
    oplayer.damages[2] = 0
    oplayer.damages[3] = 0

    oplayer:AddNewModifier(nil, nil, "modifier_no_vision", {})
    oplayer:AddNewModifier(nil, nil, "modifier_on_respawn", {})
    oplayer:AddNewModifier(nil, nil, "modifier_player_damage", {})

    local tp_item = CreateItem("item_tpscroll_custom", oplayer, oplayer)
    oplayer:AddItem(tp_item)

    CustomGameEventManager:Send_ServerToPlayer(
        PlayerResource:GetPlayer(oplayer:GetPlayerID()),
        "kill_progress",
        {blue = oplayer.bluepoints, purple = oplayer.purplepoints, max = StartBlue, max_p = StartPurple}
    )
    CustomNetTables:SetTableValue("custom_items_button", tostring(oplayer:GetPlayerID()), {observer = 0, sentry = 0})
end









function my_game:initiate_tower()
  local t = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)

 
  for _,otower in ipairs(t) do
  	if otower and not otower:IsNull() then 

		if (otower:GetUnitName() == "npc_towerdire" or otower:GetUnitName() == "npc_towerradiant")  then

			if otower:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_6 then 

				towers[otower:GetTeamNumber()] = otower	
				towers[otower:GetTeamNumber()]:AddNewModifier(otower, nil, "modifier_tower_level", {})	

			else 
				local j = otower
				self:destroy_tower(otower)
				j:Destroy()

			end

    	 end
    end
  end

	LinkLuaModifier("modifier_mid_teleport", "modifiers/modifier_mid_teleport", LUA_MODIFIER_MOTION_NONE)
	local j = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, 0, 0, false)	
    for _,teleport in ipairs(j) do
     	if teleport:GetUnitName() == "npc_teleport"  then

			teleport:AddNewModifier(nil, nil, "modifier_mid_teleport", {})
			teleports[teleport:GetTeamNumber()] = teleport 

			if teleport:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_6 then 

				local number = tonumber(teleport:GetName())

				local Vector_fow = Vector(vision_abs[number][1],vision_abs[number][2],vision_abs[number][3])
				AddFOWViewer(teleport:GetTeamNumber(), Vector_fow, vision_abs[number][4], 99999, true)

				Vector_fow = Vector(vision_abs[number][5],vision_abs[number][6],vision_abs[number][7])
				AddFOWViewer(teleport:GetTeamNumber(), Vector_fow, vision_abs[number][8], 99999, true)

			else 

				teleport:AddNewModifier(nil, nil, "modifier_invulnerable", {})
			end

		end
     end



	for _,tower in pairs(towers) do

		if players[tower:GetTeamNumber()] ~= nil then 



 			for _,tt in pairs(towers) do 
 				if tt:GetTeamNumber() ~= tower:GetTeamNumber() then 
			   		local name = SelectedHeroes[players[tower:GetTeamNumber()]:GetPlayerID()] .. '_icon'
			   	    local vector = Vector(icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][1],icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][2],icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][3])
					local hero_icon = CreateUnitByName(name, tower:GetAbsOrigin(), false, nil, nil, tt:GetTeamNumber())
					hero_icon:AddNewModifier(nil, nil, "modifier_unselect", {})
				end
			end

		end
	end



end




function my_game:IsSphere( item )
if item:GetName() == "item_legendary_upgrade" or 
	item:GetName() == "item_gray_upgrade" or
	item:GetName() == "item_blue_upgrade" or 
	item:GetName() == "item_purple_upgrade_shop" or 
	item:GetName() == "item_purple_upgrade" then 
		return true end 
return false 
end

function my_game:ExecuteOrderFilterCustom( ord )



	local target = ord.entindex_target ~= 0 and EntIndexToHScript(ord.entindex_target) or nil
	local player = PlayerResource:GetPlayer(ord["issuer_player_id_const"])

	if player and player:GetAssignedHero() then 
		if player:GetAssignedHero():HasModifier("modifier_final_duel_start") then return false end 
	end


 	local unit


    if ord.units and ord.units["0"] then
        unit = EntIndexToHScript(ord.units["0"])
    end


    local orders = {
        DOTA_UNIT_ORDER_CAST_POSITION,
        DOTA_UNIT_ORDER_CAST_TARGET,
        DOTA_UNIT_ORDER_CAST_TARGET_TREE, 
        DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        DOTA_UNIT_ORDER_MOVE_TO_TARGET,
        DOTA_UNIT_ORDER_ATTACK_MOVE,
        DOTA_UNIT_ORDER_ATTACK_TARGET,
    }

    if unit and unit:HasModifier("modifier_custom_ability_teleport") then
        for _, order in pairs(orders) do
            if ord.order_type == order then
                return false
            end
        end
    end


    if ord.order_type == DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN then
    	local item_ward = EntIndexToHScript(ord["entindex_ability"])	
    	if item_ward and item_ward:GetName() == "item_observer_stackable" then 
    		return false
    	end
    end 
    


    if ord.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then

            local item = EntIndexToHScript(ord["entindex_target"])

            if item then
            		

                local pickedItem = item:GetContainedItem()
                if not pickedItem then return true end
                if pickedItem:IsNeutralDrop() then return true end
                if players[unit:GetTeamNumber()] == nil then return false end


                if my_game:IsSphere(pickedItem) and players[unit:GetTeamNumber()].IsChoosing then return false end


                if unit:IsCourier() and pickedItem:GetPurchaser() ~= players[unit:GetTeamNumber()]
                and (pickedItem:GetName() ~= "item_roshan_necro") and (pickedItem:GetName() ~= "item_gem") then
					CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#wrong_sphere"})
				 return false end


                if (pickedItem:GetPurchaser() ~= unit) and (pickedItem:GetName() ~= "item_rapier") and (pickedItem:GetName() ~= "item_aegis")
                and (pickedItem:GetName() ~= "item_refresher_shard") and (pickedItem:GetName() ~= "item_roshan_necro") and (pickedItem:GetName() ~= "item_gem")
                and not unit:IsCourier() then

					CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#wrong_sphere"})
                    return false
                end
            end
    end



    if not player then return false end

    local hero = player:GetAssignedHero()


    if not hero then return end

    if ord.order_type == DOTA_UNIT_ORDER_BUYBACK and not hero:IsReincarnating() then 
    	
    	Timers:CreateTimer(1, function() 
    		if hero and not hero:IsNull() then 
    			hero.no_buyback = 1
    			hero:SetBuybackCooldownTime(99999)
    		end
   		 end)
    	
    end


    if ord.order_type == DOTA_UNIT_ORDER_CAST_TARGET and hero:GetUnitName() == "npc_dota_hero_alchemist" then
    	local item = EntIndexToHScript(ord.entindex_ability)
    	if item and item:GetName() == "item_ultimate_scepter" then 
			CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#alch_scepter"})
    		return false
    	end
    end

    if hero:HasModifier("modifier_final_duel") and not hero:IsAlive() and (ord.order_type == DOTA_UNIT_ORDER_MOVE_ITEM
    or ord.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM) then 
    	return false
    end





     if ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE then 


     	local ability = EntIndexToHScript(ord.entindex_ability)

     	if ability and ability:GetName() == "custom_puck_phase_shift" and hero:HasModifier("modifier_custom_puck_phase_shift_cooldown") then

     		return false 
     	end

     	if ability and not ability:IsFullyCastable() and ability:GetName() ~= "custom_puck_phase_shift" then 
     		return false
     	end

     end

    if ord.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM and players[hero:GetTeamNumber()] ~= nil and ord.shop_item_name == "item_purple_upgrade_shop" then 

    	if not players[hero:GetTeamNumber()].got_purple then 

    		players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
    		players[hero:GetTeamNumber()].got_purple = true
    	else 
    		return false
    	end
    end


    if hero and hero:HasModifier("modifier_mid_teleport_cast") and ord.order_type ~= DOTA_UNIT_ORDER_HOLD_POSITION
    and ord.order_type ~= DOTA_UNIT_ORDER_PURCHASE_ITEM and ord.order_type ~= DOTA_UNIT_ORDER_MOVE_ITEM
    and ord.order_type ~= DOTA_UNIT_ORDER_SELL_ITEM  then 
     return false end


    if hero and hero:HasModifier("modifier_bristle_spray_legendary") and hero:IsAlive() and ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then 
    	local ability = EntIndexToHScript(ord.entindex_ability)
    	if ability and ability:GetName() == "bristleback_quill_spray_custom" then 
    		local mod = hero:FindModifierByName("modifier_custom_bristleback_quill_spray_legendary")
    		if not mod then 
    			hero:AddNewModifier(hero, ability, "modifier_custom_bristleback_quill_spray_legendary", {})
    		else 
    			mod:Destroy()
    		end
    	end
    end



    if hero and hero:HasModifier("modifier_lina_array_legendary") and hero:IsAlive() and ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then 
    	local ability = EntIndexToHScript(ord.entindex_ability)
    	if ability and ability:GetName() == "lina_light_strike_array_custom" then 
    		local mod = hero:FindModifierByName("modifier_lina_light_strike_array_custom_legendary")
    		if not mod then 
    			hero:AddNewModifier(hero, ability, "modifier_lina_light_strike_array_custom_legendary", {})
    		else 
    			mod:Destroy()
    		end
    	end
    end




	if ord.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or ord.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET  then


	if target and not target:IsNull() and  target:IsBaseNPC() and target:GetUnitName() == "npc_teleport" and unit:IsRealHero() then

		if target:GetTeamNumber() ~= hero:GetTeamNumber() then return false end

		if teleport_range >= ( hero:GetOrigin() - target:GetOrigin() ):Length2D() then 

			 if not hero:HasModifier("modifier_mid_teleport_cd") then
     			 hero:Interrupt() 
     			 hero:Stop()
    		     hero:AddAbility("mid_teleport")
      			local ability = hero:FindAbilityByName("mid_teleport")
     			 ability:SetLevel(1)
     			 ability.roshan = Active_Roshan
    			 hero:CastAbilityNoTarget(ability, hero:GetPlayerID())

    		else 
				CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#midteleport_cd"})
    		end
		else 
			CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#midteleport_distance"})
		end

		return false
	  end
	end



	if ord.order_type == DOTA_UNIT_ORDER_CAST_TARGET  then
		if target:GetUnitName() == "npc_teleport" then 
			return false
		end
	end




	local ability = EntIndexToHScript(ord.entindex_ability)

	if not ability or not ability.GetBehaviorInt then return true end
	local behavior = ability:GetBehaviorInt()

	-- check if the ability exists and if it is Vector targeting
	if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) ~= 0  then

		if ord.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
			ability.vectorTargetPosition2 = Vector(ord.position_x, ord.position_y, 0)
		end

		if ord.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
			ability.vectorTargetPosition = Vector(ord.position_x, ord.position_y, 0)
			local position = ability.vectorTargetPosition
			local position2 = ability.vectorTargetPosition2
			local direction = (position2 - position):Normalized()

			--Change direction if just clicked on the same position
			if position == position2 then
				direction = (position - unit:GetAbsOrigin()):Normalized()
			end
			direction = Vector(direction.x, direction.y, 0)
			ability.vectorTargetDirection = direction

			local function OverrideSpellStart(self, position, direction)
				self:OnVectorCastStart(position, direction)
			end
			ability.OnSpellStart = function(self) return OverrideSpellStart(self, position, direction) end
		end
	end



	return true
end

function my_game:DamageFilter( dmg )
	local target = EntIndexToHScript(dmg["entindex_victim_const"])
	local damage = dmg["damage"]
	if dmg["entindex_attacker_const"] == nil then return true end
	local attacker = EntIndexToHScript(dmg["entindex_attacker_const"])

	if target:GetUnitName() == "npc_teleport" then
		return false
	end
	

	if target and target:IsCourier() then 
		if attacker and 
			(attacker:GetUnitName() == "patrol_melee_bad" or attacker:GetUnitName() == "patrol_melee_good" 
				or attacker:GetUnitName() == "patrol_range_bad" or attacker:GetUnitName() == "patrol_range_good")
			then
				return false
			end
	end

	return true
end


function my_game:HealingFilter( h )

if h["entindex_target_const"] == nil then return healing end
if h["entindex_healer_const"] == nil then return healing end
if h["heal"] == nil then return healing end

local heal = h["heal"]
local target = EntIndexToHScript(h["entindex_target_const"])
local healer = EntIndexToHScript(h["entindex_healer_const"])

	return healing
end



local first_think = true
function my_game:OnThink()
	my_game:UpdateMatch(first_think)
	first_think = false
	return 0
end


function my_game:AddPlayer(team)
if not IsInToolsMode() then return end

local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM,Vector(0, 0, 0),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

for _,player in pairs(p) do 
	if player:GetTeamNumber() == team then 
		my_game:initiate_player(player, 30)
	end
end

end

--Convars:RegisterCommand('set_winner', function(_,team) my_game:WinTeam(tonumber(team)) end, '', 0)


Convars:RegisterCommand('add_player', function(_,team) my_game:AddPlayer(tonumber(team)) end, '', 0)

--Convars:RegisterCommand('start_duel', function() my_game:start_duel() end, '', 0)
--Convars:RegisterCommand('destroy_tower', function(_,team) my_game:destroy_tower(nil, tonumber(team) ) end, '', 0)
