--LinkLuaModifier("", "abilities/items/item_roshan_necro", LUA_MODIFIER_MOTION_NONE)

item_roshan_necro                = class({})


function item_roshan_necro:OnAbilityPhaseStart()

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

if player == nil then return false end


if player.active_necro == false then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#active_necro"}) 
    return false
end



if player.necro_wave == true then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#cant_necro"}) 
    return false
end

return true 

end


function item_roshan_necro:OnSpellStart()
if not IsServer() then return end

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

CustomGameEventManager:Send_ServerToAllClients('NecroAttack',  {id = player:GetPlayerID(), victim = player:GetUnitName(), attacker = self:GetCaster():GetUnitName()})

player.necro_wave = true

self:SpendCharge()




end