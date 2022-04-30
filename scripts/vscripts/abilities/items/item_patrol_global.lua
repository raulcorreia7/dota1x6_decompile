LinkLuaModifier("modifier_razor_tower", "abilities/items/item_patrol_global", LUA_MODIFIER_MOTION_NONE)

item_patrol_global                = class({})





function item_patrol_global:OnSpellStart()
if not IsServer() then return end


local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end


local damage = self:GetSpecialValueFor("damage")/100
local timer = 0.5
local caster = self:GetCaster()

self:GetCaster():EmitSound("DOTA_Item.MeteorHammer.Cast")

local i = 0

for _,tower in pairs(towers) do 
	if (tower:GetUnitName() == "npc_towerdire" or tower:GetUnitName() == "npc_towerradiant") and not tower:IsInvulnerable() then 

		self.particle3  = ParticleManager:CreateParticle("particles/roshan_meteor_spell_.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.particle3, 0, tower:GetAbsOrigin() + Vector(0, 0, 1200)) -- 1000 feels kinda arbitrary but it also feels correct
        ParticleManager:SetParticleControl(self.particle3, 1, tower:GetAbsOrigin())
        ParticleManager:SetParticleControl(self.particle3, 2, Vector(0.5, 0, 0))
        ParticleManager:ReleaseParticleIndex(self.particle3)
        i = i + 0.05

        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(players[tower:GetTeamNumber()]:GetPlayerID()), 'ravager_used',  {})


        Timers:CreateTimer(0.5 + i, function()
        	if tower and not tower:IsInvulnerable() then 
        		local tower_damage = tower:GetMaxHealth()*damage

        		if tower:GetHealth() > tower_damage then 
        			tower:SetHealth(tower:GetHealth() - tower_damage)
        		else 
        			tower:Kill(nil, caster)
        		end

        		--tower:EmitSound("DOTA_Item.MeteorHammer.Impact")
        	end
        end)
	end

end

self:SpendCharge()

end

