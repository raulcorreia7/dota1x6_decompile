LinkLuaModifier("modifier_lich_frostbite", "abilities/npc_lich_frostbite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_blast", "abilities/npc_lich_frostbite", LUA_MODIFIER_MOTION_NONE)

npc_lich_frostbite = class({})


function npc_lich_frostbite:GetIntrinsicModifierName() return "modifier_lich_frostbite" end



modifier_lich_frostbite = class({})
function modifier_lich_frostbite:IsHidden() return true end
function modifier_lich_frostbite:IsPurgable() return true end

function modifier_lich_frostbite:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_lich_frostbite:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if (not params.attacker:IsAlive()) then return end
if (params.attacker ~= self:GetParent()) then return end
local blast = self:GetParent():FindAbilityByName("npc_lich_blast") 
local ulti = self:GetParent():FindAbilityByName("npc_lich_ulti") 

if params.inflictor == blast or params.inflictor == ulti and params.unit:GetTeamNumber() ~= params.attacker:GetTeamNumber() 
then 
	params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lich_blast", {})
end

end






modifier_lich_blast = class({})
function modifier_lich_blast:IsHidden() return false end
function modifier_lich_blast:IsPurgable() return false end
function modifier_lich_blast:OnCreated(table)
self.heal = -1*self:GetAbility():GetSpecialValueFor("heal")
self.slow = -1*self:GetAbility():GetSpecialValueFor("slow")
self.speed = -1*self:GetAbility():GetSpecialValueFor("speed")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_lich_blast:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_lich_blast:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_EVENT_ON_DEATH
}

end

function modifier_lich_blast:OnDeath(params)
if not IsServer() then return end
if self:GetCaster() ~= params.unit then return end
	self:Destroy()
end




function modifier_lich_blast:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()*self.slow end

function modifier_lich_blast:GetStatusEffectName()
  return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_lich_blast:GetModifierAttackSpeedBonus_Constant() return self.speed*self:GetStackCount() end
function modifier_lich_blast:GetModifierHealAmplify_PercentageTarget() return self.heal*self:GetStackCount()  end
function modifier_lich_blast:GetModifierHPRegenAmplify_Percentage() return self.heal*self:GetStackCount() end


function modifier_lich_blast:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetParent() ~= params.unit then return end
if params.inflictor == self:GetAbility() then return end

 local damage = self:GetStackCount()*self:GetAbility():GetSpecialValueFor("damage_stack") 
  SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(),damage, nil)
   local damageTable = {victim = self:GetParent(),  damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetCaster(), ability = self:GetAbility()}
 

  local actualy_damage = ApplyDamage(damageTable)

end


