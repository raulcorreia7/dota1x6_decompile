LinkLuaModifier( "modifier_lina_light_strike_array_custom", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_slow", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_fire", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_legendary", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_triple", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_after", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_blink", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )

lina_light_strike_array_custom = class({})

lina_light_strike_array_custom.shard_damage = 10

lina_light_strike_array_custom.range_radius_init = 0
lina_light_strike_array_custom.range_radius_inc = 20
lina_light_strike_array_custom.range_range_init = 50
lina_light_strike_array_custom.range_range_inc = 50

lina_light_strike_array_custom.slow_move_init = -10
lina_light_strike_array_custom.slow_move_inc = -10
lina_light_strike_array_custom.slow_speed_init = -15
lina_light_strike_array_custom.slow_speed_inc = -15
lina_light_strike_array_custom.slow_speed_duration = 3

lina_light_strike_array_custom.fire_duration = 10
lina_light_strike_array_custom.fire_damage_init = 20
lina_light_strike_array_custom.fire_damage_inc = 20
lina_light_strike_array_custom.fire_damage_interval = 0.5
lina_light_strike_array_custom.fire_damage_building = 0.25

lina_light_strike_array_custom.legendary_cd = 0

lina_light_strike_array_custom.triple_max = 4
lina_light_strike_array_custom.triple_cd = 2

lina_light_strike_array_custom.double_radius = 300
lina_light_strike_array_custom.double_duration = 3
lina_light_strike_array_custom.double_init = 0.1
lina_light_strike_array_custom.double_inc = 0.1
lina_light_strike_array_custom.double_creeps = 0.25


function lina_light_strike_array_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_lina_array_legendary") then
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end



function lina_light_strike_array_custom:GetCastPoint()
if self:GetCaster():GetUpgradeStack("modifier_lina_light_strike_array_custom_triple") == self.triple_max - 1 then 
  return 0
end

return 0.45
end


function lina_light_strike_array_custom:GetCooldown(iLevel)
local cd = 0
if self:GetCaster():HasModifier("modifier_lina_array_legendary") and self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_legendary") then 
  cd = self.legendary_cd
end
return self.BaseClass.GetCooldown(self, iLevel) + cd

end


function lina_light_strike_array_custom:GetCastRange(vLocation, hTarget)
local bonus = 0

if self:GetCaster():HasModifier("modifier_lina_array_2") then 
  bonus = self.range_range_init + self.range_range_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_2")
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end


function lina_light_strike_array_custom:GetAOERadius()
local bonus = 0 

if self:GetCaster():HasModifier("modifier_lina_array_2") then 
  bonus = self.range_radius_init + self.range_radius_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_2")
end

    return self:GetSpecialValueFor( "light_strike_array_aoe" ) + bonus
end





function lina_light_strike_array_custom:OnSpellStart()
  if not IsServer() then return end
  local point = self:GetCursorPosition()
  local duration = self:GetSpecialValueFor( "light_strike_array_delay_time" )

  if self:GetCaster():HasModifier("modifier_lina_array_6") then
    local mod = self:GetCaster():FindModifierByName("modifier_lina_light_strike_array_custom_triple")
    if mod and mod:GetStackCount() == self.triple_max - 1 then
      local cd = self:GetCooldownTimeRemaining()
      self:EndCooldown()
      self:StartCooldown(cd - self.triple_cd)
      duration = 0
    end

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_light_strike_array_custom_triple", {})

  end

  if self:GetCaster():HasModifier("modifier_lina_array_legendary") and self:GetAutoCastState() == true then 
      local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
      ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_light_strike_array_custom_blink", {duration = duration})
  end


  if self:GetCaster():HasModifier("modifier_lina_array_4") then
    if self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_after") then 
      self:GetCaster():RemoveModifierByName("modifier_lina_light_strike_array_custom_after")
    end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_light_strike_array_custom_after", {duration = self.double_duration})
  end

  if self:GetCaster():HasModifier("modifier_lina_array_5") then 
      CreateModifierThinker( self:GetCaster(), self, "modifier_lina_light_strike_array_custom", { blink = false, time = duration, duration = duration }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
  end

  CreateModifierThinker( self:GetCaster(), self, "modifier_lina_light_strike_array_custom", { time = duration, blink = self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_legendary"), duration = duration }, point, self:GetCaster():GetTeamNumber(), false )
end





modifier_lina_light_strike_array_custom = class({})

function modifier_lina_light_strike_array_custom:IsHidden() return true end

function modifier_lina_light_strike_array_custom:IsPurgable() return false end

function modifier_lina_light_strike_array_custom:OnCreated( kv )
  if not IsServer() then return end
  self.stun_duration = self:GetAbility():GetSpecialValueFor( "light_strike_array_stun_duration" )
  self.damage = self:GetAbility():GetSpecialValueFor( "light_strike_array_damage" )
  self.radius = self:GetAbility():GetSpecialValueFor( "light_strike_array_aoe" )

  self.building_damage = self.damage*self:GetAbility():GetSpecialValueFor("building_damage")/100

  self.blink = kv.blink

  if self:GetCaster():HasModifier("modifier_lina_array_2") then 
   self.radius = self.radius + self:GetAbility().range_radius_init + self:GetAbility().range_radius_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_2")
  end
 
  if kv.time ~= 0 then 
  local particle = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
  ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
  ParticleManager:ReleaseParticleIndex( particle )
  EmitSoundOnLocationForAllies( self:GetParent():GetAbsOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )

  end
end

function modifier_lina_light_strike_array_custom:OnDestroy()
  if not IsServer() then return end

  GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.radius, false )

  if self:GetCaster():HasModifier("modifier_lina_array_1") then 

    local damage_burn = self:GetAbility().fire_damage_interval*(self:GetAbility().fire_damage_init + self:GetAbility().fire_damage_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_1"))


    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_lina_light_strike_array_custom_fire",
    {duration = self:GetAbility().fire_duration, interval = self:GetAbility().fire_damage_interval, radius = self.radius, damage = damage_burn}, 
    self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

  end


  if self:GetCaster():HasShard() then 
    local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
    if mod then 
      self.damage = self.damage + mod:GetStackCount()*self:GetAbility().shard_damage
    end
  end


  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 0, false )

  for _,enemy in pairs(enemies) do

    local damage = self.damage
    if enemy:IsBuilding() then 
      damage = self.building_damage
    end

    local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility() }

    damageTable.victim = enemy
    ApplyDamage( damageTable )
    enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration * (1 - enemy:GetStatusResistance()) } )



    if self:GetCaster():HasModifier("modifier_lina_array_3") then 
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_light_strike_array_custom_slow", {duration = self.stun_duration * (1 - enemy:GetStatusResistance()) + self:GetAbility().slow_speed_duration})
    end

  end

  local particle_end = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( particle_end, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:SetParticleControl( particle_end, 1, Vector( self.radius, 1, 1 ) )
  ParticleManager:ReleaseParticleIndex( particle_end )

  EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Ability.LightStrikeArray", self:GetCaster() )


  if self.blink == 1 then 
      local old_pos = self:GetCaster():GetAbsOrigin()
    



      FindClearSpaceForUnit(self:GetCaster(), self:GetParent():GetAbsOrigin(), true)
      ProjectileManager:ProjectileDodge(self:GetCaster())

      effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
      ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())

  end

  UTIL_Remove( self:GetParent() )
end





modifier_lina_light_strike_array_custom_slow = class({})
function modifier_lina_light_strike_array_custom_slow:IsHidden() return false end
function modifier_lina_light_strike_array_custom_slow:IsPurgable() return true end
function modifier_lina_light_strike_array_custom_slow:GetTexture() return "buffs/Blade_fury_slow" end
function modifier_lina_light_strike_array_custom_slow:GetEffectName()
  return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end
function modifier_lina_light_strike_array_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_lina_light_strike_array_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move_init + self:GetAbility().slow_move_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_3")
end 

function modifier_lina_light_strike_array_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_speed_init + self:GetAbility().slow_speed_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_3")
end 





modifier_lina_light_strike_array_custom_fire = class({})

function modifier_lina_light_strike_array_custom_fire:IsHidden() return true end

function modifier_lina_light_strike_array_custom_fire:IsPurgable() return false end


function modifier_lina_light_strike_array_custom_fire:OnCreated(table)
if not IsServer() then return end
      
  self.start_pos = self:GetParent():GetAbsOrigin()
  self.damage = table.damage
  self.radius = table.radius

  self.nFXIndex = ParticleManager:CreateParticle("particles/dragon_fireball.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
    ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius, 0, 0))
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)

  self:AddParticle(self.nFXIndex,false,false,-1,false,false)

self:StartIntervalThink(table.interval)
end

function modifier_lina_light_strike_array_custom_fire:OnIntervalThink()
if not IsServer() then return end

local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)

for _,enemy in ipairs(tTargets) do

  local damage = self.damage
  if enemy:IsBuilding() then 
    damage = damage*self:GetAbility().fire_damage_building
  end

  ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
  SendOverheadEventMessage(enemy, 4, enemy, damage, nil)

end

end


modifier_lina_light_strike_array_custom_legendary = class({})

function modifier_lina_light_strike_array_custom_legendary:IsHidden() return false end
function modifier_lina_light_strike_array_custom_legendary:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_legendary:RemoveOnDeath() return false end


modifier_lina_light_strike_array_custom_triple = class({})
function modifier_lina_light_strike_array_custom_triple:IsHidden() return false end
function modifier_lina_light_strike_array_custom_triple:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_triple:GetTexture() return "buffs/array_triple" end
function modifier_lina_light_strike_array_custom_triple:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true



end

function modifier_lina_light_strike_array_custom_triple:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().triple_max - 1 then 
  
  self:GetParent():EmitSound("Lina.Array_triple")

    self.nFXIndex = ParticleManager:CreateParticle("particles/lina_array_triple.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())

  self:AddParticle(self.nFXIndex, false, false, 1, true, false)
end

if self:GetStackCount() >= self:GetAbility().triple_max then 
  self:Destroy()
end

end

function modifier_lina_light_strike_array_custom_triple:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_lina_light_strike_array_custom_triple:OnTooltip()
return self:GetAbility().triple_max
end


modifier_lina_light_strike_array_custom_after = class({})
function modifier_lina_light_strike_array_custom_after:IsHidden() return true end
function modifier_lina_light_strike_array_custom_after:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_after:GetTexture() return
"buffs/array_double"
end

function modifier_lina_light_strike_array_custom_after:OnCreated(table)
self.RemoveForDuel = true
self.damage = 0
self.t = -1
if not IsServer() then return end

self.timer = self:GetAbility().double_duration*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end

function modifier_lina_light_strike_array_custom_after:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1

local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
  decimal = 8
else 
  decimal = 1
end

local particleName = "particles/lina_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end







function modifier_lina_light_strike_array_custom_after:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_lina_light_strike_array_custom_after:OnTakeDamage(params)
if self:GetParent() ~= params.attacker then return end
if params.unit:IsBuilding() then return end

local damage = params.damage
if not params.unit:IsRealHero() then 
  damage = damage*self:GetAbility().double_creeps
end

self.damage = self.damage + damage


end


function modifier_lina_light_strike_array_custom_after:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

  self.damage = self.damage*(self:GetAbility().double_init + self:GetAbility().double_inc*self:GetCaster():GetUpgradeStack("modifier_lina_array_4"))

  local particle_end = ParticleManager:CreateParticle( "particles/lina_second_blast.vpcf", PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( particle_end, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:SetParticleControl( particle_end, 1, Vector( self:GetAbility().double_radius, 1, 1 ) )
  ParticleManager:ReleaseParticleIndex( particle_end )

  EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Ability.LightStrikeArray", self:GetCaster() )



  local damageTable = { attacker = self:GetCaster(), damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility() }

  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().double_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

  for _,enemy in pairs(enemies) do
    damageTable.victim = enemy
    ApplyDamage( damageTable )

  end

end


modifier_lina_light_strike_array_custom_blink = class({})
function modifier_lina_light_strike_array_custom_blink:IsHidden() return false end
function modifier_lina_light_strike_array_custom_blink:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_blink:CheckState() return
  {
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_UNTARGETABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true
  }
end

function modifier_lina_light_strike_array_custom_blink:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNoDraw()
end

function modifier_lina_light_strike_array_custom_blink:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveNoDraw()
end