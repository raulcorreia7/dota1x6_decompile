LinkLuaModifier("modifier_golem_craggy", "abilities/neutral_golem_craggy", LUA_MODIFIER_MOTION_NONE)




neutral_golem_craggy = class({})

function neutral_golem_craggy:GetIntrinsicModifierName() return "modifier_golem_craggy" end 


modifier_golem_craggy = class({})

function modifier_golem_craggy:IsPurgable() return false end

function modifier_golem_craggy:IsHidden() return true end

function modifier_golem_craggy:OnCreated(table)
if not IsServer() then return end
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_golem_craggy:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_golem_craggy:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() == params.target then 
  local random = RollPseudoRandomPercentage(self.chance,12,self:GetParent())
  if random then 
    params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.duration*(1 - params.attacker:GetStatusResistance())})
    ApplyDamage({victim = params.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetParent(),  ability = self:GetAbility()})
         
  end
end
end