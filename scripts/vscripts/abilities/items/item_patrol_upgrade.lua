--LinkLuaModifier("", "abilities/items/item_patrol_upgrade", LUA_MODIFIER_MOTION_NONE)

item_patrol_upgrade                = class({})



function item_patrol_upgrade:OnSpellStart()
if not IsServer() then return end

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

CustomGameEventManager:Send_ServerToAllClients('UpgradeCreeps',  {id = player:GetPlayerID(), victim = player:GetUnitName()})

player.creeps_upgrade = player.creeps_upgrade + 1

self:SpendCharge()




end