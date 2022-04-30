

modifier_legion_duel_damage = class({})


function modifier_legion_duel_damage:IsHidden() return true end
function modifier_legion_duel_damage:IsPurgable() return false end

function modifier_legion_duel_damage:IncDamage()
if not IsServer() then return end
local ability = self:GetParent():FindAbilityByName("custom_legion_commander_duel")
if not ability then return end
local mod
local count 

mod = self:GetParent():FindModifierByName("modifier_duel_damage")
if mod then 
	count = mod:GetStackCount()
	mod:SetStackCount(count + count*ability.damage_inc)
end

mod = self:GetParent():FindModifierByName("modifier_duel_legendary_health")
if mod then 
	count = mod:GetStackCount()
	mod:SetStackCount(count + count*ability.damage_inc)
end

mod = self:GetParent():FindModifierByName("modifier_duel_legendary_speed")
if mod then 
	count = mod:GetStackCount()
	mod:SetStackCount(count + count*ability.damage_inc)
end

mod = self:GetParent():FindModifierByName("modifier_duel_legendary_cdr")
if mod then 
	count = mod:GetStackCount()
	mod:SetStackCount(count + count*ability.damage_inc)
end

local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:GetParent():EmitSound("Hero_LegionCommander.Duel.Victory")

end

function modifier_legion_duel_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
 	self:IncDamage() 
end


function modifier_legion_duel_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
 	self:IncDamage() 
  
end

function modifier_legion_duel_damage:RemoveOnDeath() return false end