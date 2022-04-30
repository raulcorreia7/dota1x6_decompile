LinkLuaModifier("modifier_npc_necro_melle_passive", "abilities/npc_necro_melle_passive", LUA_MODIFIER_MOTION_NONE)

npc_necro_melle_passive = class({})

function npc_necro_melle_passive:GetIntrinsicModifierName() 
return "modifier_npc_necro_melle_passive"
end

modifier_npc_necro_melle_passive = class({})

function modifier_npc_necro_melle_passive:IsHidden() return true end
function modifier_npc_necro_melle_passive:IsPurgable() return false end

function modifier_npc_necro_melle_passive:OnCreated(table)
if not IsServer() then return end

self.damage = self:GetAbility():GetSpecialValueFor("damage")/100
self.stun = self:GetAbility():GetSpecialValueFor("stun")

end

function modifier_npc_necro_melle_passive:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_DEATH
}

end

function modifier_npc_necro_melle_passive:CheckState()
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_npc_necro_melle_passive:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if not params.attacker then return end
if params.attacker:IsBuilding() then return end

local damage = params.attacker:GetMaxHealth()*self.damage

params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - params.attacker:GetStatusResistance())*self.stun})

local damageTable = 
{
    victim      = params.attacker,
    damage      = damage,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
    attacker    = self:GetParent(),
    ability     = self:GetAbility()
}

ApplyDamage(damageTable)

local effect_target = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
ParticleManager:SetParticleControl( effect_target, 0, params.attacker:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_target )
params.attacker:EmitSound("Hero_DoomBringer.InfernalBlade.PreAttack")


end