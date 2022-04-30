LinkLuaModifier("modifier_custom_bristleback_warpath", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_buff", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_buff_count", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_legendary_crit", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_rampage", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_rampage_cd", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_lowhp_cd", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_lowhp", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_armor", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_slow", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_double", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_count", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_no", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_warpath_resist", "abilities/bristleback/bristleback_warpath_custom", LUA_MODIFIER_MOTION_NONE)


bristleback_warpath_custom              = class({})

bristleback_warpath_custom.damage_init = 4
bristleback_warpath_custom.damage_inc = 2

bristleback_warpath_custom.resist_attack = 4
bristleback_warpath_custom.resist_max = 10
bristleback_warpath_custom.resist_duration = 5

bristleback_warpath_custom.legendary_radius = 200
bristleback_warpath_custom.legendary_crit = 400
bristleback_warpath_custom.legendary_stun = 1.5
bristleback_warpath_custom.legendary_cd = 15
bristleback_warpath_custom.legendary_cd_miss = 4
bristleback_warpath_custom.legendary_cd_stack = 2

bristleback_warpath_custom.double_hit = {7, 6, 5}
bristleback_warpath_custom.double_delay = 0.2

bristleback_warpath_custom.rampage_damage = 20
bristleback_warpath_custom.rampage_heal = 0.4
bristleback_warpath_custom.rampage_chance_init = 5
bristleback_warpath_custom.rampage_chance_inc = 10
bristleback_warpath_custom.rampage_duration = 4

bristleback_warpath_custom.lowhp_cd = 40
bristleback_warpath_custom.lowhp_stack = 3
bristleback_warpath_custom.lowhp_duration = 4
bristleback_warpath_custom.lowhp_health = 30

bristleback_warpath_custom.pierce_armor = -0.2
bristleback_warpath_custom.pierce_duration = 0.3
bristleback_warpath_custom.pierce_slow = -80
bristleback_warpath_custom.pierce_chance_init = 2
bristleback_warpath_custom.pierce_chance_inc = 1


function bristleback_warpath_custom:GetIntrinsicModifierName() return "modifier_custom_bristleback_warpath" end


function bristleback_warpath_custom:GetCooldown(iLevel)
  if self:GetCaster():HasModifier("modifier_bristle_warpath_legendary") then
    return self.legendary_cd end
 return 0
end

function bristleback_warpath_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bristle_warpath_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function bristleback_warpath_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():EmitSound("BB.Warpath_legendary_swing")

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_VICTORY, 1.26)

self.timer =  Timers:CreateTimer(0.55,function() 
self:GetCaster():EmitSound("BB.Warpath_legendary_swing")

  
self.timer =  Timers:CreateTimer(0.55,function() 
self:GetCaster():EmitSound("BB.Warpath_legendary_swing") end)

end)

return true 
end

function bristleback_warpath_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)
if self.timer == nil then return end


Timers:RemoveTimer(self.timer)


end



function bristleback_warpath_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)
if self.timer ~= nil then
  Timers:RemoveTimer(self.timer)
end

local origin = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*150

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
ParticleManager:SetParticleControl(particle, 0, origin)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("BB.Warpath_legendary")

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), origin, nil, self.legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

if #enemies == 0 then 
  self:EndCooldown()
  self:StartCooldown(self.legendary_cd_miss)
end

local crit = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_bristleback_warpath_legendary_crit", {})
local cleave = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_tidehunter_anchor_smash_caster", {})

for _,enemy in ipairs(enemies) do 

    self:GetCaster():PerformAttack(enemy, false, true, true, true, false, false, true)

    enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.legendary_stun*(1 - enemy:GetStatusResistance())})
end 
if crit then crit:Destroy() end
if cleave then cleave:Destroy() end






end

modifier_custom_bristleback_warpath_legendary_crit = class({})

function modifier_custom_bristleback_warpath_legendary_crit:IsHidden() return true end
function modifier_custom_bristleback_warpath_legendary_crit:IsPurgable() return false end
function modifier_custom_bristleback_warpath_legendary_crit:GetCritDamage() return self:GetAbility().legendary_crit end
function modifier_custom_bristleback_warpath_legendary_crit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end
function modifier_custom_bristleback_warpath_legendary_crit:GetModifierPreAttack_CriticalStrike() return self:GetAbility().legendary_crit end







modifier_custom_bristleback_warpath = class({})

function modifier_custom_bristleback_warpath:IsHidden() return true end
function modifier_custom_bristleback_warpath:IsPurgable() return false end



function modifier_custom_bristleback_warpath:DeclareFunctions()
return {
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end


function modifier_custom_bristleback_warpath:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

if self:GetParent():HasModifier("modifier_bristle_warpath_max") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_resist", {duration = self:GetAbility().resist_duration})
end



if params.target:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_bristle_warpath_resist") then return end
if self:GetParent():HasModifier("modifier_custom_bristleback_warpath_no") then return end
if self:GetParent():HasModifier("modifier_custom_bristleback_warpath_legendary_crit") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_count", {})

local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath_count")

if mod and mod:GetStackCount() >= self:GetAbility().double_hit[self:GetParent():GetUpgradeStack("modifier_bristle_warpath_resist")] then 
  mod:Destroy()
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_double", {duration = self:GetAbility().double_delay})
end


end



function modifier_custom_bristleback_warpath:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if not self:GetParent():HasModifier("modifier_bristle_warpath_pierce") then return end
if self:GetParent():PassivesDisabled() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath_buff")

if not mod then return end

local chance =  mod:GetStackCount()*(self:GetAbility().pierce_chance_init + self:GetAbility().pierce_chance_inc*self:GetParent():GetUpgradeStack("modifier_bristle_warpath_pierce"))

local random = RollPseudoRandomPercentage(chance,126,self:GetParent())


if not random then return end

 params.target:EmitSound("BB.Warpath_proc")
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_slow", {duration = self:GetAbility().pierce_duration})
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_armor", {})

end






function modifier_custom_bristleback_warpath:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():HasModifier("modifier_bristle_warpath_lowhp") then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health then return end
if self:GetParent():HasModifier("modifier_custom_bristleback_warpath_lowhp_cd") or self:GetParent():HasModifier("modifier_custom_bristleback_warpath_lowhp")
 then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_lowhp", {duration = self:GetAbility().lowhp_duration})

self:GetParent():Purge(false, true, false, true, false)

for i = 1,self:GetAbility().lowhp_stack do 
  self:IncStacks()
end


end


function modifier_custom_bristleback_warpath:OnAbilityFullyCast(keys)
if not keys.ability then return end 
if keys.unit ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if keys.ability:IsItem() or keys.ability:GetName() == "mid_teleport" 
or keys.ability:GetName() == "custom_ability_observer" or keys.ability:GetName() == "custom_ability_sentry" 
or keys.ability:GetName() == "custom_ability_smoke"  then return end


if self:GetParent():HasModifier("modifier_bristle_warpath_bash")  then 

  local chance = self:GetAbility().rampage_chance_init + self:GetAbility().rampage_chance_inc*self:GetParent():GetUpgradeStack("modifier_bristle_warpath_bash")

  local random = RollPseudoRandomPercentage(chance,137,self:GetParent())

  if random then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_rampage", {duration = self:GetAbility().rampage_duration})
  end


end



local do_stacks = 1
local duration = self:GetAbility():GetSpecialValueFor("stack_duration")


local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff", {duration = duration})

if not mod then return end


for i = 1,do_stacks do
  self:IncStacks()
end


end



function modifier_custom_bristleback_warpath:IncStacks()
 if not IsServer() then return end

self.max_stacks       = self:GetAbility():GetSpecialValueFor("max_stacks")
local duration = self:GetAbility():GetSpecialValueFor("stack_duration")

 local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff", {duration = duration})


if not mod then return end

if  mod:GetStackCount() < self.max_stacks then 


    mod:IncrementStackCount() 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff_count", {duration = duration})


else 

    for _,all_counts in ipairs(self:GetParent():FindAllModifiersByName("modifier_custom_bristleback_warpath_buff_count")) do 
      all_counts:Destroy()
      mod:IncrementStackCount() 
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_buff_count", {duration = duration})
      break
    end

end





end



modifier_custom_bristleback_warpath_buff = class({})
function modifier_custom_bristleback_warpath_buff:IsHidden() return false end
function modifier_custom_bristleback_warpath_buff:IsPurgable() return false end
function modifier_custom_bristleback_warpath_buff:GetEffectName() return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf" end



function modifier_custom_bristleback_warpath_buff:OnCreated()
    

  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  self.RemoveForDuel = true
  
  self.damage_per_stack   = self.ability:GetSpecialValueFor("damage_per_stack")
  self.move_speed_per_stack = self.ability:GetSpecialValueFor("move_speed_per_stack")
  


  
end





function modifier_custom_bristleback_warpath_buff:DeclareFunctions()
    return {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_MODEL_SCALE
    }
end



function modifier_custom_bristleback_warpath_buff:GetModifierPreAttack_BonusDamage()
if self.parent:IsIllusion() then return end

self.damage_per_stack   = self.ability:GetSpecialValueFor("damage_per_stack") 
    
if self:GetParent():HasModifier("modifier_bristle_warpath_damage") then 
    self.damage_per_stack = self.damage_per_stack + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_bristle_warpath_damage")
end

return self.damage_per_stack * self:GetStackCount()

end




function modifier_custom_bristleback_warpath_buff:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility():GetSpecialValueFor("move_speed_per_stack") * self:GetStackCount()
end

function modifier_custom_bristleback_warpath_buff:GetModifierModelScale()
  return self:GetStackCount() * 3
end





modifier_custom_bristleback_warpath_buff_count = class({})
function modifier_custom_bristleback_warpath_buff_count:IsHidden() return true end
function modifier_custom_bristleback_warpath_buff_count:IsPurgable() return false end
function modifier_custom_bristleback_warpath_buff_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_bristleback_warpath_buff_count:GetEffectName() return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf" end



function modifier_custom_bristleback_warpath_buff_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end

function modifier_custom_bristleback_warpath_buff_count:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath_buff")

if mod then 
  mod:DecrementStackCount()
end

end

    


modifier_custom_bristleback_warpath_rampage = class({})

function modifier_custom_bristleback_warpath_rampage:IsHidden() return false end
function modifier_custom_bristleback_warpath_rampage:IsPurgable() return false end
function modifier_custom_bristleback_warpath_rampage:GetTexture() return "buffs/warpath_rampage" end
function modifier_custom_bristleback_warpath_rampage:GetStatusEffectName()
  return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end
function modifier_custom_bristleback_warpath_rampage:StatusEffectPriority()
    return 12
end


function modifier_custom_bristleback_warpath_rampage:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("BB.Warpath_rampage")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)

end



function modifier_custom_bristleback_warpath_rampage:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_custom_bristleback_warpath_rampage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_TOOLTIP
}

end




function modifier_custom_bristleback_warpath_rampage:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end

local heal = params.damage*self:GetAbility().rampage_heal

self:GetParent():Heal(heal, self:GetParent())

  SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

end


function modifier_custom_bristleback_warpath_rampage:OnTooltip()
return self:GetAbility().rampage_heal*100
end


function modifier_custom_bristleback_warpath_rampage:GetModifierDamageOutgoing_Percentage()
  return self:GetAbility().rampage_damage
end





modifier_custom_bristleback_warpath_rampage_cd = class({})

function modifier_custom_bristleback_warpath_rampage_cd:IsHidden() return false end
function modifier_custom_bristleback_warpath_rampage_cd:IsPurgable() return false end
function modifier_custom_bristleback_warpath_rampage_cd:IsDebuff() return true end
function modifier_custom_bristleback_warpath_rampage_cd:GetTexture() return "buffs/warpath_rampage" end
function modifier_custom_bristleback_warpath_rampage_cd:RemoveOnDeath() return false end
function modifier_custom_bristleback_warpath_rampage_cd:OnCreated(table)
self.RemoveForDuel = true
end




modifier_custom_bristleback_warpath_lowhp_cd = class({})

function modifier_custom_bristleback_warpath_lowhp_cd:IsHidden() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:IsPurgable() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:IsDebuff() return true end
function modifier_custom_bristleback_warpath_lowhp_cd:GetTexture() return "buffs/warpath_lowhp" end
function modifier_custom_bristleback_warpath_lowhp_cd:RemoveOnDeath() return false end
function modifier_custom_bristleback_warpath_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_bristleback_warpath_lowhp = class({})

function modifier_custom_bristleback_warpath_lowhp:IsHidden() return false end
function modifier_custom_bristleback_warpath_lowhp:IsPurgable() return false end
function modifier_custom_bristleback_warpath_lowhp:GetTexture() return "buffs/warpath_lowhp" end
function modifier_custom_bristleback_warpath_lowhp:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end

function modifier_custom_bristleback_warpath_lowhp:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:GetParent():EmitSound("BB.Warpath_lowhp")
local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end

function modifier_custom_bristleback_warpath_lowhp:OnDestroy()
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_bristleback_warpath_lowhp_cd", {duration = self:GetAbility().lowhp_cd})
end
function modifier_custom_bristleback_warpath_lowhp:CheckState()
return
{
  [MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end




modifier_custom_bristleback_warpath_armor = class({})
function modifier_custom_bristleback_warpath_armor:IsHidden() return false end
function modifier_custom_bristleback_warpath_armor:IsPurgable() return true end
function modifier_custom_bristleback_warpath_armor:GetTexture() return "buffs/moment_armor" end
 

function modifier_custom_bristleback_warpath_armor:OnCreated(table)
if not IsServer() then return end

self.armor = self:GetParent():GetPhysicalArmorValue(false)
self.reduce = self:GetAbility().pierce_armor*self.armor

if self.reduce > 0 then 
  self.reduce = 0
end
end


function modifier_custom_bristleback_warpath_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_EVENT_ON_TAKEDAMAGE

}
end

function modifier_custom_bristleback_warpath_armor:OnTakeDamage(params)
if not IsServer() then return end
if self:GetCaster() == params.attacker and params.unit == self:GetParent() then 
self:Destroy()
end

end

function modifier_custom_bristleback_warpath_armor:GetModifierPhysicalArmorBonus() return 
self.reduce
end


modifier_custom_bristleback_warpath_slow = class({})
function modifier_custom_bristleback_warpath_slow:IsHidden() return true end
function modifier_custom_bristleback_warpath_slow:IsPurgable() return false end
function modifier_custom_bristleback_warpath_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_custom_bristleback_warpath_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().pierce_slow
end


modifier_custom_bristleback_warpath_double = class({})
function modifier_custom_bristleback_warpath_double:IsHidden() return true end
function modifier_custom_bristleback_warpath_double:IsPurgable() return false end
function modifier_custom_bristleback_warpath_double:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_bristleback_warpath_double:OnDestroy()
if not IsServer() then return end
if not self:GetCaster() then return end
if not self:GetCaster():IsAlive() then return end
if not self:GetParent():IsAlive() then return end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_bristleback_warpath_no", {})
self:GetCaster():PerformAttack(self:GetParent(), true, true, true, false, false, false, false)
if mod then 
  mod:Destroy()
end

end

modifier_custom_bristleback_warpath_count = class({})
function modifier_custom_bristleback_warpath_count:IsHidden() return false end
function modifier_custom_bristleback_warpath_count:IsPurgable() return false end
function modifier_custom_bristleback_warpath_count:RemoveOnDeath() return false end
function modifier_custom_bristleback_warpath_count:GetTexture() return "buffs/multi_attack" end

function modifier_custom_bristleback_warpath_count:OnCreated(table)

self.RemoveForDuel = true
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_custom_bristleback_warpath_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end


function modifier_custom_bristleback_warpath_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_bristleback_warpath_count:OnTooltip()
return self:GetAbility().double_hit[self:GetCaster():GetUpgradeStack("modifier_bristle_warpath_resist")]
end






modifier_custom_bristleback_warpath_resist = class({})
function modifier_custom_bristleback_warpath_resist:IsHidden() return false end
function modifier_custom_bristleback_warpath_resist:IsPurgable() return false end
function modifier_custom_bristleback_warpath_resist:GetTexture() return "buffs/Warpath_resist" end

function modifier_custom_bristleback_warpath_resist:OnCreated(table)

self.RemoveForDuel = true
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_custom_bristleback_warpath_resist:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().resist_max then return end
self:IncrementStackCount()


if self:GetStackCount() == self:GetAbility().resist_max then 
      
  self.particle = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
end

end


function modifier_custom_bristleback_warpath_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_custom_bristleback_warpath_resist:GetModifierStatusResistanceStacking()

  return self:GetAbility().resist_attack*self:GetStackCount()
end



