LinkLuaModifier("modifier_neutral_cast", "modifiers/modifier_neutral_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_manaburn", "abilities/neutral_satyr_manaburn", LUA_MODIFIER_MOTION_NONE)




neutral_satyr_manaburn = class({})

function neutral_satyr_manaburn:GetIntrinsicModifierName() return "modifier_satyr_manaburn" end 





modifier_satyr_manaburn = class({})

function modifier_satyr_manaburn:IsPurgable() return false end

function modifier_satyr_manaburn:IsHidden() return true end

function modifier_satyr_manaburn:OnCreated(table)
if not IsServer() then return end
self.mana = self:GetAbility():GetSpecialValueFor("mana")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_satyr_manaburn:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_satyr_manaburn:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() then return end

params.target:EmitSound("n_creep_SatyrSoulstealer.ManaBurn")
local effect = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
params.target:SpendMana(self.mana, self:GetAbility())

ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})



end


