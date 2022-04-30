LinkLuaModifier("modifier_contract_vision", "abilities/items/item_contract", LUA_MODIFIER_MOTION_NONE)

item_contract                = class({})


function item_contract:OnAbilityPhaseStart()

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

if player == nil then return false end


if not player:IsAlive() then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerID()), "CreateIngameErrorMessage", {message = "#dead_contract"}) 
    return false
end


return true 

end


function item_contract:OnSpellStart()
if not IsServer() then return end

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

EmitSoundOnEntityForPlayer("Hero_BountyHunter.Target", self:GetCaster(),  self:GetCaster():GetPlayerOwnerID())

if not player then return end


player:AddNewModifier(self:GetCaster(), self, "modifier_contract_vision", {duration = self:GetSpecialValueFor("duration")})

self:SpendCharge()

end

modifier_contract_vision = class({})
function modifier_contract_vision:IsHidden() return true end
function modifier_contract_vision:IsPurgable() return false end
function modifier_contract_vision:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end

function modifier_contract_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false)
end