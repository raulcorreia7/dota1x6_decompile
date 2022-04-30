LinkLuaModifier("modifier_custom_huskar_berserkers_blood", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_active", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_lowhp", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_armor", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_legendary_attack", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_berserkers_blood_grave_cd", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)


custom_huskar_berserkers_blood              = class({})
modifier_custom_huskar_berserkers_blood         = class({})
modifier_custom_huskar_berserkers_blood_active         = class({})
modifier_custom_huskar_berserkers_blood_lowhp          = class({})
modifier_custom_huskar_berserkers_blood_armor           = class({})

custom_huskar_berserkers_blood.regen_inc = 10
custom_huskar_berserkers_blood.regen_init = 10

custom_huskar_berserkers_blood.speed_init = 15
custom_huskar_berserkers_blood.speed_inc = 15

custom_huskar_berserkers_blood.crit_init = 100
custom_huskar_berserkers_blood.crit_inc = 30
custom_huskar_berserkers_blood.crit_chance = 35

custom_huskar_berserkers_blood.armor_health = 50
custom_huskar_berserkers_blood.armor_resist = 15

custom_huskar_berserkers_blood.grave_init = 0
custom_huskar_berserkers_blood.grave_inc = 1
custom_huskar_berserkers_blood.grave_cd = 40


custom_huskar_berserkers_blood.lowhp_health = 30
custom_huskar_berserkers_blood.lowhp_duration = 5
custom_huskar_berserkers_blood.lowhp_move = 20
custom_huskar_berserkers_blood.lowhp_resist = 40

custom_huskar_berserkers_blood.legendary_damage = 0.5
custom_huskar_berserkers_blood.legendary_duration = 12
custom_huskar_berserkers_blood.legendary_attack = 0.06
custom_huskar_berserkers_blood.legendary_heal = 30
custom_huskar_berserkers_blood.legendary_cd = 8




function custom_huskar_berserkers_blood:GetIntrinsicModifierName()
  return "modifier_custom_huskar_berserkers_blood"
end

function custom_huskar_berserkers_blood:GetBehavior()
  if self:GetCaster():HasModifier("modifier_huskar_passive_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function custom_huskar_berserkers_blood:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_huskar_passive_legendary") then return self.legendary_cd end  
end



function custom_huskar_berserkers_blood:OnSpellStart()
if not IsServer() then return end

local damage = self:GetCaster():GetMaxHealth()*self.legendary_damage


self:GetCaster():SetHealth(math.max(self:GetCaster():GetHealth() - damage, 1))


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_berserkers_blood_legendary_attack", {duration = self.legendary_duration})

end




function modifier_custom_huskar_berserkers_blood:IsHidden() return true end
function modifier_custom_huskar_berserkers_blood:IsPurgable() return false end

  
function modifier_custom_huskar_berserkers_blood:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
  self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen")
  self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
  self.maximum_resistance     = self.ability:GetSpecialValueFor("maximum_resistance")
  
  self.range          = 100 - self.hp_threshold_max
  self.max_size = 35
  
  if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_huskar_berserkers_blood:OnRefresh()
  self.maximum_attack_speed   = self.ability:GetSpecialValueFor("maximum_attack_speed")
  self.maximum_health_regen   = self.ability:GetSpecialValueFor("maximum_health_regen") 
  self.hp_threshold_max       = self.ability:GetSpecialValueFor("hp_threshold_max")
  self.range            = 100 - self.hp_threshold_max
end

function modifier_custom_huskar_berserkers_blood:OnIntervalThink()
  if not IsServer() then return end
  
  self:SetStackCount(self.parent:GetStrength())
  if self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health
    and self:GetParent():HasModifier("modifier_huskar_passive_lowhp") then

      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_lowhp", {duration = self:GetAbility().lowhp_duration})
    end




end

function modifier_custom_huskar_berserkers_blood:OnDestroy()
  if not IsServer() then return end

  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)

end

function modifier_custom_huskar_berserkers_blood:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_PROPERTY_MIN_HEALTH
  }

  return funcs
end


function modifier_custom_huskar_berserkers_blood:GetMinHealth()
if not self:GetParent():HasModifier("modifier_huskar_passive_active") then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end

return 1
end

function modifier_custom_huskar_berserkers_blood:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_huskar_passive_active") then return end
if params.unit ~= self:GetParent() then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave_cd") then return end
if self:GetParent():HasModifier("modifier_custom_huskar_berserkers_blood_grave") then return end
if self:GetParent():PassivesDisabled() then return end

local duration = self:GetAbility().grave_init + self:GetAbility().grave_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_active")
self:GetParent():EmitSound("Huskar.Passive_Legendary")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave", {duration = duration})

end


function modifier_custom_huskar_berserkers_blood:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_huskar_passive_damage") then return end

local damage = self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_damage")

local chance = (1 - self:GetParent():GetHealthPercent()/100)*self:GetAbility().crit_chance

local random = RollPseudoRandomPercentage(chance,52,self:GetParent())
if not random then return end

self.record = params.record
return damage

end



function modifier_custom_huskar_berserkers_blood:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not self.record or self.record ~= params.record then return end

self.record = nil
params.target:EmitSound("DOTA_Item.Daedelus.Crit")
end








function modifier_custom_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
  if self.parent:PassivesDisabled() then return end

  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
  
  local bonus = 0
  if self:GetParent():HasModifier("modifier_huskar_passive_speed") then 
    bonus = self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_speed")
  end

  return (self.maximum_attack_speed + bonus) * (1 - pct) * (1 - pct)
end

function modifier_custom_huskar_berserkers_blood:GetModifierConstantHealthRegen()
  if self.parent:PassivesDisabled() then return end

  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
  
  return self:GetStackCount() * (self.maximum_health_regen  + (self:GetAbility().regen_init + self:GetAbility().regen_inc*self:GetParent():GetUpgradeStack("modifier_huskar_passive_regen")) )  * 0.01 * (1 - pct) * (1 - pct)
end

function modifier_custom_huskar_berserkers_blood:GetModifierModelScale()
  if not IsServer() then return end
  
  local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)

  ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
  
  self.parent:SetRenderColor(255, 255 * pct, 255 * pct)
  
  return self.max_size * (1 - pct)
end

function modifier_custom_huskar_berserkers_blood:GetActivityTranslationModifiers()
  return "berserkers_blood"
end







--------------------------------------------------------------ТАЛАНТ ЛОУ ХП-----------------------------------------------
function modifier_custom_huskar_berserkers_blood_lowhp:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_lowhp:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_lowhp:GetTexture() return "buffs/berserker_lowhp" end

function modifier_custom_huskar_berserkers_blood_lowhp:GetEffectName() return "particles/huskar_lowhp.vpcf" end
function modifier_custom_huskar_berserkers_blood_lowhp:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Passive_LowHp")
end

function modifier_custom_huskar_berserkers_blood_lowhp:DeclareFunctions()
  return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_custom_huskar_berserkers_blood_lowhp:GetModifierMoveSpeedBonus_Percentage() return self:GetAbility().lowhp_move
 end
function modifier_custom_huskar_berserkers_blood_lowhp:GetModifierStatusResistanceStacking() return self:GetAbility().lowhp_resist
 end
----------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------ТАЛАНТ БРОНЯ--------------------------------------------------------------------

function modifier_custom_huskar_berserkers_blood_armor:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_armor:RemoveOnDeath() return false end
function modifier_custom_huskar_berserkers_blood_armor:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_armor:IsDebuff() return self:GetParent():GetHealthPercent() > self:GetAbility().armor_health end
function modifier_custom_huskar_berserkers_blood_armor:GetTexture() return "buffs/berserker_armor" end


function modifier_custom_huskar_berserkers_blood_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_custom_huskar_berserkers_blood_armor:GetModifierIncomingDamage_Percentage()
local k = -1
if self:GetParent():GetHealthPercent() > self:GetAbility().armor_health then 
  k = 1
end
  return k*self:GetAbility().armor_resist
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
modifier_custom_huskar_berserkers_blood_legendary_attack = class({})
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_legendary_attack:GetTexture() return "buffs/berserker_active" end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnCreated(table)

self.health = self:GetAbility().legendary_heal/self:GetAbility().legendary_duration
self.damage = self:GetParent():GetMaxHealth()*self:GetAbility().legendary_damage*self:GetAbility().legendary_attack

if not IsServer() then return end

if self.effect_cast then 

  ParticleManager:DestroyParticle(self.effect_cast, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast ) 
end

self:GetCaster():EmitSound("Huskar.Passive_Active")
self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnRefresh(table)
self:OnCreated(table)
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.effect_cast, false )
 ParticleManager:ReleaseParticleIndex( self.effect_cast ) 
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:OnTooltip()
  return self.damage
end

function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierHealthRegenPercentage() return self.health end

function modifier_custom_huskar_berserkers_blood_legendary_attack:GetModifierProcAttack_BonusDamage_Physical(params)
if params.target:IsBuilding() then return end 
  return self.damage 
end


modifier_custom_huskar_berserkers_blood_grave = class({})

function modifier_custom_huskar_berserkers_blood_grave:GetEffectName() return "particles/huskar_grave.vpcf" end
function modifier_custom_huskar_berserkers_blood_grave:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_grave:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_grave:GetTexture() return "buffs/berserker_grave" end
function modifier_custom_huskar_berserkers_blood_grave:OnDestroy()
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_berserkers_blood_grave_cd", {duration = self:GetAbility().grave_cd})
end

modifier_custom_huskar_berserkers_blood_grave_cd = class({})
function modifier_custom_huskar_berserkers_blood_grave_cd:IsHidden() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:IsPurgable() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:RemoveOnDeath() return false end
function modifier_custom_huskar_berserkers_blood_grave_cd:IsDebuff() return true end
function modifier_custom_huskar_berserkers_blood_grave_cd:GetTexture() return "buffs/berserker_grave" end
function modifier_custom_huskar_berserkers_blood_grave_cd:OnCreated(table)
self.RemoveForDuel = true 
end