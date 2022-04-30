LinkLuaModifier("modifier_abbadon_attack", "abilities/npc_abbadon_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abbadon_proc", "abilities/npc_abbadon_proc.lua", LUA_MODIFIER_MOTION_NONE)

npc_abbadon_proc = class({})


function npc_abbadon_proc:GetIntrinsicModifierName() return "modifier_abbadon_attack" end
 
modifier_abbadon_attack = class ({})

function modifier_abbadon_attack:IsHidden() return true end


function modifier_abbadon_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end


function modifier_abbadon_attack:OnDeath(params)
if not IsServer() then end 
if params.unit ~= self:GetParent() then return end
if not params.attacker then return end

params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_abbadon_proc", {duration = self:GetAbility():GetSpecialValueFor("duration")})
self:GetParent():EmitSound("Hero_Visage.SoulAssumption.Cast")
params.attacker:EmitSound("Hero_Visage.SoulAssumption.Target")

end


modifier_abbadon_proc = class({})
function modifier_abbadon_proc:IsHidden() return false end
function modifier_abbadon_proc:IsPurgable() return false end

function modifier_abbadon_proc:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
self.damage = self:GetAbility():GetSpecialValueFor("damage")

if not IsServer() then return end
self:SetStackCount(1)
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end


function modifier_abbadon_proc:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end


function modifier_abbadon_proc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end



function modifier_abbadon_proc:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end

function modifier_abbadon_proc:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end