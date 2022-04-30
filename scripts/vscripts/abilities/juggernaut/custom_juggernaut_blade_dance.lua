LinkLuaModifier("modifier_custom_juggernaut_blade_dance", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_stack", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_buff", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_legendary_run", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_parry", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_speed", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_mortal", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_anim", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_slow", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_dance_move", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_bladedance_double_no", "abilities/juggernaut/custom_juggernaut_blade_dance.lua", LUA_MODIFIER_MOTION_NONE)



custom_juggernaut_blade_dance = class({})

custom_juggernaut_blade_dance.damage_init = 0
custom_juggernaut_blade_dance.damage_inc = 20

custom_juggernaut_blade_dance.mortal_init = 25
custom_juggernaut_blade_dance.mortal_inc = 25
custom_juggernaut_blade_dance.mortal_duration = 6
custom_juggernaut_blade_dance.mortal_health = 25

custom_juggernaut_blade_dance.speed_init = 0
custom_juggernaut_blade_dance.speed_inc = 10
custom_juggernaut_blade_dance.speed_duration = 3
custom_juggernaut_blade_dance.speed_max = 3

custom_juggernaut_blade_dance.chance_init = 6
custom_juggernaut_blade_dance.chance_inc = -1

custom_juggernaut_blade_dance.parry_duration = 1
custom_juggernaut_blade_dance.parry_reduction = 0.5

custom_juggernaut_blade_dance.heal_heal = 0.05
custom_juggernaut_blade_dance.heal_duration = 3
custom_juggernaut_blade_dance.heal_move = 20

custom_juggernaut_blade_dance.legendary_cd = 60
custom_juggernaut_blade_dance.legendary_range = 400
custom_juggernaut_blade_dance.legendary_slow_duration = 3
custom_juggernaut_blade_dance.legendary_slow = -80
custom_juggernaut_blade_dance.legendary_duration = 8
custom_juggernaut_blade_dance.legendary_resist = 50



function custom_juggernaut_blade_dance:GetIntrinsicModifierName() return "modifier_custom_juggernaut_blade_dance" end

function custom_juggernaut_blade_dance:GetBehavior()
  if self:GetCaster():HasModifier("modifier_juggernaut_bladedance_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end
function custom_juggernaut_blade_dance:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_bladedance_legendary") then return self.legendary_cd end  
end

function custom_juggernaut_blade_dance:OnSpellStart()
if not IsServer() then return end


 
  local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_dance_anim")
  if mod then mod:Destroy() end

  self:GetCaster():EmitSound("Hero_Juggernaut.ArcanaTrigger")
  local sound_cast = "Juggernaut.ShockWave"
  self:GetCaster():EmitSound(sound_cast)

  local range = self.legendary_range
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,   0,  false )


  local origin = self:GetCaster():GetOrigin()
  local cast_direction = (self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*range - origin):Normalized()
  local cast_angle = VectorToAngles( cast_direction ).y
  local angle = 140 / 2

  -- for each units
  local caught = false

  for _,enemy in pairs(enemies) do
    -- check within cast angle
    local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
    local enemy_angle = VectorToAngles( enemy_direction ).y
    local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

    if angle_diff <= angle and not enemy:IsMagicImmune() then
 
      

      enemy:EmitSound("BB.Warpath_proc")
      enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_slow", {duration = self.legendary_slow_duration})
      
    local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_crit_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
    ParticleManager:SetParticleControl( effect, 0, enemy:GetOrigin() )
    ParticleManager:SetParticleControl( effect, 1, enemy:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect )


    end
end


    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(range,range,range) )
    ParticleManager:SetParticleControlForward( effect_cast, 0, cast_direction )
    ParticleManager:ReleaseParticleIndex( effect_cast )



  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_legendary", {duration = self.legendary_duration})
  self:UseResources(false, false, true)

end


function custom_juggernaut_blade_dance:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_dance_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end
modifier_custom_juggernaut_blade_dance_anim = class({})
function modifier_custom_juggernaut_blade_dance_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_dance_anim:GetActivityTranslationModifiers() return "ti8" end

function custom_juggernaut_blade_dance:OnAbilityPhaseInterrupted()


self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_dance_anim")
if mod then mod:Destroy() end
  end


modifier_custom_juggernaut_blade_dance_legendary = class({})


function modifier_custom_juggernaut_blade_dance_legendary:IsHidden() return false end

function modifier_custom_juggernaut_blade_dance_legendary:IsPurgable() return false end

function modifier_custom_juggernaut_blade_dance_legendary:GetTexture() return "buffs/Blade_dance_legendary" end

function modifier_custom_juggernaut_blade_dance_legendary:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end

function modifier_custom_juggernaut_blade_dance_legendary:OnCreated(table)
  self.anim = "ti8"
self.RemoveForDuel = true
if not IsServer() then return end
 local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_ABSORIGIN, self:GetParent())
            ParticleManager:ReleaseParticleIndex(trail_pfx)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_legendary_run", {duration = self:GetRemainingTime()})
end


function modifier_custom_juggernaut_blade_dance_legendary:DeclareFunctions()
  return
{ 
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end


function modifier_custom_juggernaut_blade_dance_legendary:GetModifierStatusResistanceStacking() return self:GetAbility().legendary_resist end

function modifier_custom_juggernaut_blade_dance_legendary:OnAttackLanded(params)
if self.anim == "ti8" then 
  self.anim = "favor"
else 
  self.anim = "ti8"
end

end
function modifier_custom_juggernaut_blade_dance_legendary:GetActivityTranslationModifiers() return self.anim end
function modifier_custom_juggernaut_blade_dance_legendary:GetModifierBaseAttackTimeConstant() return self:GetAbility().legendary_bva end



function modifier_custom_juggernaut_blade_dance_legendary:GetEffectName() return "particles/jugger_legendary.vpcf" end
 
function modifier_custom_juggernaut_blade_dance_legendary:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end




modifier_custom_juggernaut_blade_dance_legendary_run = class({})
function modifier_custom_juggernaut_blade_dance_legendary_run:IsHidden() return true end
function modifier_custom_juggernaut_blade_dance_legendary_run:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_legendary_run:DeclareFunctions()
  return
  {


    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS

} end



function modifier_custom_juggernaut_blade_dance_legendary_run:GetActivityTranslationModifiers() return "chase" end









modifier_custom_juggernaut_blade_dance = class({})


function modifier_custom_juggernaut_blade_dance:IsHidden() return true end

function modifier_custom_juggernaut_blade_dance:GetCritDamage()
local damage = self:GetAbility():GetSpecialValueFor("damage")
if self:GetParent():HasModifier("modifier_juggernaut_bladedance_chance") then 
  damage = damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladedance_chance")
end
 return damage
end
 
function modifier_custom_juggernaut_blade_dance:DeclareFunctions() return {

MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,

} end

function modifier_custom_juggernaut_blade_dance:OnCreated(table)

      self.chance = self:GetAbility():GetSpecialValueFor("chance")
      self.target = nil
      self.damage = self:GetAbility():GetSpecialValueFor("damage")
      self.record = nil
      if not IsServer() then return end
    
end




function modifier_custom_juggernaut_blade_dance:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

self.chance = self:GetAbility():GetSpecialValueFor("chance")

self.chance = self.chance 
        
self.damage = self:GetAbility():GetSpecialValueFor("damage") 


if self:GetParent():HasModifier("modifier_juggernaut_bladedance_chance") then 
  local bonus = 0
  bonus = self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladedance_chance")
  self.damage = self.damage + bonus
end
        



local random = RollPseudoRandomPercentage(self.chance,12,self:GetParent())
if random or self:GetParent():HasModifier("modifier_custom_juggernaut_blade_dance_legendary") then
  self.record = params.record

  return self.damage
end

end



function modifier_custom_juggernaut_blade_dance:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
  if self.record and self.record == params.record then

  self.record = nil



  if self:GetParent():HasModifier("modifier_juggernaut_bladedance_lowhp") then 

    local chance = self:GetAbility().mortal_chance

      params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_mortal", { duration = self:GetAbility().mortal_duration*(1 - params.target:GetStatusResistance())})

  end
            
            
  if self:GetParent():HasModifier("modifier_juggernaut_bladedance_speed") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_speed", { duration = self:GetAbility().speed_duration})
  end
            
  if self:GetParent():HasModifier("modifier_juggernaut_bladedance_double") then 
    local heal = (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self:GetAbility().heal_heal
    self:GetParent():Heal(heal, self:GetAbility())
    SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_move", {duration = self:GetAbility().heal_duration})

  end

  if self:GetParent():HasModifier("modifier_juggernaut_bladedance_parry") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_parry", { duration = self:GetAbility().parry_duration})
  end

  if self:GetParent():HasModifier("modifier_juggernaut_bladedance_stack") and not self:GetParent():HasModifier("modifier_juggernaut_bladedance_double_no") then
    local mod = self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_dance_stack")

    local max = self:GetAbility().chance_init + self:GetAbility().chance_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladedance_stack")

    if not mod then 
      mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_dance_stack", {})   
    end

    mod:IncrementStackCount()

    if mod:GetStackCount() >= max  then 
      if params.target and not params.target:IsNull() and params.target:IsAlive() then 

          local particle = ParticleManager:CreateParticle( "particles/jugger_double.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
          ParticleManager:SetParticleControl( particle, 1, params.target:GetAbsOrigin() )
          ParticleManager:ReleaseParticleIndex( particle )

          local no = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_juggernaut_bladedance_double_no", {})

          self:GetParent():PerformAttack(params.target, true, true, true, false, false, false, false)

          if no then no:Destroy() end

          if params.target and not params.target:IsNull() and params.target:IsAlive() then 

              local particle = ParticleManager:CreateParticle("particles/jugg_double_.vpcf", PATTACH_CUSTOMORIGIN, nil)
              ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin() )
              ParticleManager:SetParticleControl(particle, 1, params.target:GetAbsOrigin() )
              ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_CUSTOMORIGIN, "attach_hitloc", params.target:GetAbsOrigin(), true)
          
              ParticleManager:ReleaseParticleIndex(particle)

              local sound_cast = "Juggernaut.Double"
              Timers:CreateTimer(0.15, function()
                if params.target and not params.target:IsNull() and params.target:IsAlive() then 
                     params.target:EmitSound("Hero_Juggernaut.Attack")
                end
              end)
              params.target:EmitSound(sound_cast)
          end
        end
      mod:Destroy()
    end
 
  end
  

   local sound_cast = "Hero_Juggernaut.BladeDance"

  if params.target and not params.target:IsNull() then 
    params.target:EmitSound(sound_cast)
  end

  end
end



modifier_custom_juggernaut_blade_dance_stack = class({})

function modifier_custom_juggernaut_blade_dance_stack:IsPurgable() return false end
function modifier_custom_juggernaut_blade_dance_stack:GetTexture() return "buffs/blade_dance_double" end

function modifier_custom_juggernaut_blade_dance_stack:DeclareFunctions()

return 
{
      MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_juggernaut_blade_dance_stack:OnTooltip()

return self:GetAbility().chance_init + self:GetAbility().chance_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladedance_stack")

end









 modifier_custom_juggernaut_blade_dance_parry = class({})

  function modifier_custom_juggernaut_blade_dance_parry:IsHidden() return true end
  function modifier_custom_juggernaut_blade_dance_parry:IsPurgable() return false end
  function modifier_custom_juggernaut_blade_dance_parry:GetTexture() return  "buffs/Blade_dance_parry" end

  function modifier_custom_juggernaut_blade_dance_parry:DeclareFunctions()
    return
{
MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
}
  end

function modifier_custom_juggernaut_blade_dance_parry:GetModifierPhysical_ConstantBlock( params )
if not IsServer() then return end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  self:GetParent():EmitSound("Juggernaut.Parry")
  local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetParent():GetAbsOrigin(), true )
    ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

self:Destroy()
end
return params.damage*self:GetAbility().parry_reduction
  end



-----------------------------------------ТАЛАНТ СКОРОСТЬ-----------------------------------------------

modifier_custom_juggernaut_blade_dance_speed = class({})

function modifier_custom_juggernaut_blade_dance_speed:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_speed:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_speed:GetTexture() return  "buffs/Blade_dance_speed" end
function modifier_custom_juggernaut_blade_dance_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end 

function modifier_custom_juggernaut_blade_dance_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().speed_max then 
  self:IncrementStackCount()
end
end 

function modifier_custom_juggernaut_blade_dance_speed:DeclareFunctions()
    return
{
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
  end




function modifier_custom_juggernaut_blade_dance_speed:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()*(self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladedance_speed"))
 end


modifier_custom_juggernaut_blade_dance_move = class({})


function modifier_custom_juggernaut_blade_dance_move:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_move:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_move:GetTexture() return  "buffs/Blade_dance_move" end
function modifier_custom_juggernaut_blade_dance_move:GetEffectName() return "particles/items3_fx/blink_swift_buff.vpcf" end
function modifier_custom_juggernaut_blade_dance_move:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_custom_juggernaut_blade_dance_move:DeclareFunctions()
    return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
  end



function modifier_custom_juggernaut_blade_dance_move:GetModifierMoveSpeedBonus_Percentage() 
return self:GetAbility().heal_move
end






----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------ТАЛАНТ СМЕРТЕЛЬНАЯ РАНА--------------------------------------------------

modifier_custom_juggernaut_blade_dance_mortal = class({})

function modifier_custom_juggernaut_blade_dance_mortal:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_mortal:IsPurgable() return false end

function modifier_custom_juggernaut_blade_dance_mortal:GetTexture() return  "buffs/Blade_dance_mortal" end

function modifier_custom_juggernaut_blade_dance_mortal:OnCreated(table)
if not IsServer() then return end
  
  self.RemoveForDuel = true
  self.ability = self:GetAbility()
  self.caster = self:GetCaster()

  if self.caster:IsIllusion() then 
     self.caster = self.caster.owner
  end

  self:SetStackCount(1)
  self.damage = self:GetAbility().mortal_init + self:GetAbility().mortal_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladedance_lowhp")
  self:StartIntervalThink(0.1)
end


function modifier_custom_juggernaut_blade_dance_mortal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end

function modifier_custom_juggernaut_blade_dance_mortal:OnDestroy()
if not IsServer() then return end

      local parent = self:GetParent()

     local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

     local trail_pfx = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self:GetParent())

        ParticleManager:SetParticleControlEnt(trail_pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt( trail_pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(trail_pfx)
         self:GetParent():EmitSound("DOTA_Item.Daedelus.Crit")
        ApplyDamage({ victim = self:GetParent(), attacker = self.caster, ability = self.ability, damage = self.damage*self:GetStackCount(), damage_type = DAMAGE_TYPE_MAGICAL})
         self:Destroy()
  end

function modifier_custom_juggernaut_blade_dance_mortal:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().mortal_health then return end
self:Destroy()
end



function modifier_custom_juggernaut_blade_dance_mortal:DeclareFunctions()
 return 

  {
    MODIFIER_PROPERTY_TOOLTIP

  } 
end



function modifier_custom_juggernaut_blade_dance_mortal:OnTooltip()
return (self:GetAbility().mortal_init + self:GetAbility().mortal_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladedance_lowhp"))*self:GetStackCount() 

end



modifier_custom_juggernaut_blade_dance_slow = class({})
function modifier_custom_juggernaut_blade_dance_slow:IsHidden() return false end
function modifier_custom_juggernaut_blade_dance_slow:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end

function modifier_custom_juggernaut_blade_dance_slow:IsPurgable() return true end
function modifier_custom_juggernaut_blade_dance_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_juggernaut_blade_dance_slow:GetModifierMoveSpeedBonus_Percentage() 
return self:GetAbility().legendary_slow
end



----------------------------------------------------------------------------------------------------------------------------------

modifier_juggernaut_bladedance_double_no = class({})
function modifier_juggernaut_bladedance_double_no:IsHidden() return true end
function modifier_juggernaut_bladedance_double_no:IsPurgable() return false end
