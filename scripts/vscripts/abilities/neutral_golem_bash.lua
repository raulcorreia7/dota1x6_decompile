LinkLuaModifier("modifier_golem_bash", "abilities/neutral_golem_bash", LUA_MODIFIER_MOTION_NONE)




neutral_golem_bash = class({})

function neutral_golem_bash:GetIntrinsicModifierName() return "modifier_golem_bash" end 


modifier_golem_bash = class({})

function modifier_golem_bash:IsPurgable() return false end

function modifier_golem_bash:IsHidden() return true end

function modifier_golem_bash:OnCreated(table)
if not IsServer() then return end
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_golem_bash:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_golem_bash:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() == params.attacker then 
  local random = RollPseudoRandomPercentage(self.chance,12,self:GetParent())
  if random then 
    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.duration*(1 - params.target:GetStatusResistance())})
    ApplyDamage({victim = params.target, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetParent(),  ability = self:GetAbility()})
         
  end
end
end