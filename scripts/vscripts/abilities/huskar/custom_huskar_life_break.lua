LinkLuaModifier("modifier_custom_huskar_life_break", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_huskar_life_break_charge", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_slow", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_taunt", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_legendary", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_tracker", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_immune", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_resist", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_heal", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_damage_tracker", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_damage", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_lowhp_tracker", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)


custom_huskar_life_break                  = class({})
modifier_custom_huskar_life_break             = class({})
modifier_custom_huskar_life_break_charge          = class({})
modifier_custom_huskar_life_break_slow          = class({})
modifier_custom_huskar_life_break_taunt         = class({})
modifier_custom_huskar_life_break_legendary     = class({})
modifier_custom_huskar_life_break_tracker        = class({})
modifier_custom_huskar_life_break_immune           = class({})
modifier_custom_huskar_life_break_resist        = class({})
modifier_custom_huskar_life_heal        = class({})



custom_huskar_life_break.creep_reduce = 0.33

custom_huskar_life_break.cd_init = 0
custom_huskar_life_break.cd_inc = -1

custom_huskar_life_break.lowhp_health = 40
custom_huskar_life_break.lowhp_damage_init = 0
custom_huskar_life_break.lowhp_damage_inc = 5
custom_huskar_life_break.lowhp_duration = 5

custom_huskar_life_break.damage_tracker = 3
custom_huskar_life_break.damage_init = 0
custom_huskar_life_break.damage_inc = 0.2

custom_huskar_life_break.bkb_duration = 4

custom_huskar_life_break.heal_init = 5
custom_huskar_life_break.heal_inc = 5
custom_huskar_life_break.heal_duration = 5

custom_huskar_life_break.legendary_duration = 2.5
custom_huskar_life_break.legendary_damage = -80

custom_huskar_life_break.aoe_range = 300
custom_huskar_life_break.aoe_root = 2






function custom_huskar_life_break:GetCastPoint()
if self:GetCaster():HasModifier("modifier_huskar_leap_legendary")
 then return 0
else return 0.3 end end

function custom_huskar_life_break:GetCooldown(iLevel)
 
local upgrade = 0
if self:GetCaster():HasModifier("modifier_huskar_leap_cd") then 
  upgrade = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_leap_cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + upgrade

end

function custom_huskar_life_break:GetBehavior()
  if self:GetCaster():HasModifier("modifier_huskar_leap_resist") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
      end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 
end


function custom_huskar_life_break:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_huskar_leap_resist") then 
  return self.aoe_range
end
return 0
end



function custom_huskar_life_break:GetCastRange(vLocation, hTarget)
local upgrade = 0
if self:GetCaster():HasScepter() then 
  upgrade = 300
end
 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function custom_huskar_life_break:GetIntrinsicModifierName() return "modifier_custom_huskar_life_break_tracker" end

function custom_huskar_life_break:OnSpellStart(target)
  if not IsServer() then return end

  if target == nil then 
    enemy = self:GetCursorTarget()
  else 
    enemy = target
  end

  self:GetCaster():EmitSound("Hero_Huskar.Life_Break")

 
  self:GetCaster():Purge(false, true, false, false, false)

   local life_break_charge_max_duration = 5
  

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_life_break", {ent_index = enemy:entindex()})
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_life_break_charge", {duration = life_break_charge_max_duration})
end



function modifier_custom_huskar_life_break:IsHidden()   return true end
function modifier_custom_huskar_life_break:IsPurgable() return false end

function modifier_custom_huskar_life_break:OnCreated(params)
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()

  self.health_cost_percent  = self.ability:GetSpecialValueFor("health_cost_percent")
  self.health_damage      = self.ability:GetSpecialValueFor("health_damage")
  self.health_damage_scepter  = self.ability:GetSpecialValueFor("health_damage_scepter")
  self.charge_speed     = self.ability:GetSpecialValueFor("charge_speed")
  self.taunt_duration       = self.ability:GetSpecialValueFor("taunt_duration")






if not IsServer() then return end

self.target     = EntIndexToHScript(params.ent_index)
self.break_range  = 1450

if self:ApplyHorizontalMotionController() == false then
   self:Destroy()
end

self.damage_tracker = 0
for _,mod in pairs(self:GetParent():FindAllModifiers()) do 
  if mod:GetName() == "modifier_custom_huskar_life_damage_tracker" then
    self.damage_tracker = self.damage_tracker + mod:GetStackCount()
    mod:Destroy()
  end
end

if self:GetParent():HasModifier("modifier_huskar_leap_resist") then 

  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self.target:GetOrigin(), nil, self:GetAbility().aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0,  false )
  for _,enemy in pairs(enemies) do 
     enemy:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_life_break_resist", {duration = self:GetAbility().aoe_root * (1 - enemy:GetStatusResistance() ) })
  end
end


if self:GetParent():HasModifier("modifier_huskar_leap_double") and self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_life_damage", {duration = self:GetAbility().lowhp_duration})
end

end

function modifier_custom_huskar_life_break:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end
  
  me:FaceTowards(self.target:GetOrigin())

  local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
  me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
  
  if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self.break_range or self.parent:IsHexed() or self.parent:IsNightmared() or self.parent:IsStunned() then
    self:Destroy()
  end

end


function modifier_custom_huskar_life_break:OnHorizontalMotionInterrupted()
  self:Destroy()
end

function modifier_custom_huskar_life_break:OnDestroy()
  if not IsServer() then return end

  self.parent:RemoveHorizontalMotionController( self )

  if self.parent:HasModifier("modifier_custom_huskar_life_break_charge") then
    self.parent:RemoveModifierByName("modifier_custom_huskar_life_break_charge")
  end

  if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() <= 128 then
    if self.target:TriggerSpellAbsorb(self.ability) then
      return nil
    end

    if self.parent:GetName() == "npc_dota_hero_huskar" then
      self.parent:StartGesture(ACT_DOTA_CAST_LIFE_BREAK_END)
    end

    self.target:EmitSound("Hero_Huskar.Life_Break.Impact")

    local damageTable_self = {
      victim      = self.parent,
      attacker    = self.parent,
      damage      = self.health_cost_percent * self.parent:GetHealth(),
      damage_type   = DAMAGE_TYPE_MAGICAL,
      ability     = self.ability,
      damage_flags  = DOTA_DAMAGE_FLAG_NON_LETHAL
    }
    local self_damage = ApplyDamage(damageTable_self)


    if self.parent:HasModifier("modifier_huskar_leap_legendary") then 
      self.parent:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_life_break_legendary", {duration = self:GetAbility().legendary_duration })
    end

    if self:GetParent():HasModifier("modifier_huskar_leap_damage") then 
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_life_heal", {duration = self:GetAbility().heal_duration})
    end

    if self.parent:HasModifier("modifier_huskar_leap_immune")  then

      self.parent:EmitSound("Huskar.Leap_Bkb")
      local duration_bkb = self:GetAbility().bkb_duration * (1 - self.parent:GetHealthPercent()/100)
      self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_huskar_life_break_immune", {duration = duration_bkb})
    end

    if self.parent:HasModifier("modifier_huskar_leap_resist") then 
       local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self.target:GetOrigin(), nil, self:GetAbility().aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0,  false )
       for _,enemy in pairs(enemies) do 
          self:ImpactEnemy(enemy)
       end
    else
      self:ImpactEnemy(self.target)
    end



    self.parent:MoveToTargetToAttack( self.target )
  end
end


function modifier_custom_huskar_life_break:ImpactEnemy(target)
if not IsServer() then return end


    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    local enemy_damage_to_use = self.health_damage
    if not target:IsHero() then enemy_damage_to_use = enemy_damage_to_use*self:GetAbility().creep_reduce end

    local enemy_damage = enemy_damage_to_use * target:GetHealth()
    if self:GetParent() ~= target then 
      enemy_damage = enemy_damage + self.damage_tracker
    end


    local damageTable_enemy = {
      victim      = target,
      attacker    = self.parent,
      damage      =  enemy_damage,
      damage_type   = DAMAGE_TYPE_MAGICAL,
      ability     = self.ability,
      damage_flags  = DOTA_DAMAGE_FLAG_NONE
    }
   
    
    if target ~= self:GetParent() then 
      local enemy_damage = ApplyDamage(damageTable_enemy)

      if self.damage_tracker ~= 0 then 

         SendOverheadEventMessage(target, 6, target, self.damage_tracker, nil)
      end
    end

   
    
    local duration = self.ability:GetDuration()

    if target ~= self:GetParent() then 
      target:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_life_break_slow", {duration = duration * (1 - target:GetStatusResistance() ) })
    end




    
    if self.caster:HasScepter() and self.caster ~= target and target:IsHero() then

      target:AddNewModifier(self.caster, self.ability, "modifier_custom_huskar_life_break_taunt", {duration = (1 - target:GetStatusResistance())*self.taunt_duration})


    end

    

end

--------------------------------
-- LIFE BREAK CHARGE MODIFIER --
--------------------------------

--"This modifier turns him spell immune, disarms him, forces him to face the target and is responsible for the leap animation."
-- I'm gonna put the "forces him to face the target" in the other modifier cause it seems to make sense to just deal with that logic in the motion controller

function modifier_custom_huskar_life_break_charge:IsHidden()    return true end
function modifier_custom_huskar_life_break_charge:IsPurgable()  return false end

function modifier_custom_huskar_life_break_charge:CheckState()
  local state = {
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_DISARMED] = true,
  }

  return state
end

function modifier_custom_huskar_life_break_charge:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_huskar_life_break_charge:GetOverrideAnimation()
  return ACT_DOTA_CAST_LIFE_BREAK_START
end



function modifier_custom_huskar_life_break_charge:OnCreated()
  if IsServer() then

      self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
--      ParticleManager:SetParticleControl(self.pfx, 0, self:GetCaster():GetAbsOrigin())
    end
end

function modifier_custom_huskar_life_break_charge:OnDestroy()
  if IsServer() then
    if self.pfx then
      ParticleManager:DestroyParticle(self.pfx, false)
      ParticleManager:ReleaseParticleIndex(self.pfx)
    end
  end
end

------------------------------
-- LIFE BREAK SLOW MODIFIER --
------------------------------
function modifier_custom_huskar_life_break_slow:IsPurgable() 
return true end

function modifier_custom_huskar_life_break_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_custom_huskar_life_break_slow:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  -- AbilitySpecials
  self.movespeed  = self.ability:GetSpecialValueFor("movespeed")
end

function modifier_custom_huskar_life_break_slow:OnRefresh()
  self:OnCreated()
end

function modifier_custom_huskar_life_break_slow:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
 end


function modifier_custom_huskar_life_break_slow:GetModifierMoveSpeedBonus_Percentage()

    return self.movespeed * (-1)

end



-------------------------------------------
-- MODIFIER_custom_HUSKAR_LIFE_BREAK_TAUNT --
-------------------------------------------

function modifier_custom_huskar_life_break_taunt:IsPurgable() return false end

function modifier_custom_huskar_life_break_taunt:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_custom_huskar_life_break_taunt:OnCreated()
  if not IsServer() then return end
  
  self:GetParent():SetForceAttackTarget(self:GetCaster())
  self:GetParent():MoveToTargetToAttack(self:GetCaster())
  self:StartIntervalThink(0.1)
end

function modifier_custom_huskar_life_break_taunt:OnIntervalThink()
  self:GetParent():SetForceAttackTarget(self:GetCaster())
end

function modifier_custom_huskar_life_break_taunt:OnDestroy()
  if not IsServer() then return end
  
  self:GetParent():SetForceAttackTarget(nil)
end

function modifier_custom_huskar_life_break_taunt:CheckState()
  return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_TAUNTED] = true}

end


-------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ--------------------------------
function modifier_custom_huskar_life_break_legendary:IsHidden() return false end
function modifier_custom_huskar_life_break_legendary:IsPurgable() return true end
function modifier_custom_huskar_life_break_legendary:GetTexture() return "buffs/leap_shield" end
function modifier_custom_huskar_life_break_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
self:GetParent():EmitSound("Huskar.Leap_Legendary")

caster = self:GetParent()
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt( self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:SetParticleControl( self.particle, 1, Vector(5,0,0) )
ParticleManager:SetParticleControl( self.particle, 9, Vector(1,0,0) )
ParticleManager:SetParticleControl( self.particle, 10, Vector(1,0,0) )
ParticleManager:SetParticleControl( self.particle, 11, Vector(1,0,0) )
end

function modifier_custom_huskar_life_break_legendary:OnDestroy()
if not IsServer() then return end
if not self.particle then return end

  ParticleManager:DestroyParticle(self.particle, true)
  ParticleManager:ReleaseParticleIndex(self.particle) 
end


function modifier_custom_huskar_life_break_legendary:DeclareFunctions()
return
{
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_custom_huskar_life_break_legendary:GetModifierIncomingDamage_Percentage() return self:GetAbility().legendary_damage end
--------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------

function modifier_custom_huskar_life_break_tracker:IsHidden() return true end
function modifier_custom_huskar_life_break_tracker:IsPurgable() return false end
function modifier_custom_huskar_life_break_tracker:RemoveOnDeath() return false end

function modifier_custom_huskar_life_break_tracker:DeclareFunctions()
  return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_custom_huskar_life_break_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_huskar_leap_shield") then return  end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_life_damage_tracker", {duration = self:GetAbility().damage_tracker})
local damage = params.damage*(self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_huskar_leap_shield"))

if not mod then return end

mod:SetStackCount(damage)

end


--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------


function modifier_custom_huskar_life_break_immune:IsHidden() return false end
function modifier_custom_huskar_life_break_immune:IsPurgable() return false end
function modifier_custom_huskar_life_break_immune:GetTexture() return "buffs/leap_double" end
function modifier_custom_huskar_life_break_immune:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true } end

function modifier_custom_huskar_life_break_immune:OnCreated(table)
  self.RemoveForDuel = true
end
function modifier_custom_huskar_life_break_immune:GetEffectName() return "particles/huskar_bkb.vpcf" end

--------------------------------------------------------------------------------------------------------
-------------------------------------------------ТАЛАНТ РЕЗИСТ--------------------------------

function modifier_custom_huskar_life_break_resist:IsHidden() return false end
function modifier_custom_huskar_life_break_resist:IsPurgable()

  return true end
function modifier_custom_huskar_life_break_resist:GetTexture() return "buffs/leap_resist" end
function modifier_custom_huskar_life_break_resist:GetEffectName() return "particles/huskar_fire.vpcf" end
 
function modifier_custom_huskar_life_break_resist:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_huskar_life_break_resist:CheckState()
return
{[MODIFIER_STATE_ROOTED] = true}
end

modifier_custom_huskar_life_heal = class({})
function modifier_custom_huskar_life_heal:IsHidden() return false end
function modifier_custom_huskar_life_heal:IsPurgable() return true end
function modifier_custom_huskar_life_heal:GetTexture() return "buffs/lifebreak_heal" end
function modifier_custom_huskar_life_heal:OnCreated(table)
self.regen = (self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_huskar_leap_damage"))/self:GetRemainingTime()
end

function modifier_custom_huskar_life_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_custom_huskar_life_heal:GetModifierHealthRegenPercentage() return self.regen end



modifier_custom_huskar_life_damage_tracker = class({})
function modifier_custom_huskar_life_damage_tracker:IsHidden() return true end
function modifier_custom_huskar_life_damage_tracker:IsPurgable() return false end
function modifier_custom_huskar_life_damage_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


modifier_custom_huskar_life_damage = class({})
function modifier_custom_huskar_life_damage:IsHidden() return false end
function modifier_custom_huskar_life_damage:IsPurgable() return true end
function modifier_custom_huskar_life_damage:GetTexture() return "buffs/leap_bkb" end
function modifier_custom_huskar_life_damage:OnCreated(table)
  
    self:GetParent():EmitSound("Lc.Moment_Lowhp")
    self.particle = ParticleManager:CreateParticle( "particles/jugg_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
    ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() ) 
    self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_custom_huskar_life_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_custom_huskar_life_damage:GetModifierTotalDamageOutgoing_Percentage() 
return self:GetAbility().lowhp_damage_init + self:GetAbility().lowhp_damage_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_leap_double")
end

modifier_custom_huskar_life_lowhp_tracker = class({})

function modifier_custom_huskar_life_lowhp_tracker:IsHidden()
return self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health or self:GetParent():HasModifier("modifier_custom_huskar_life_damage")
end

function modifier_custom_huskar_life_lowhp_tracker:IsPurgable() return false end
function modifier_custom_huskar_life_lowhp_tracker:RemoveOnDeath() return false end
function modifier_custom_huskar_life_lowhp_tracker:GetTexture() return "buffs/leap_bkb" end