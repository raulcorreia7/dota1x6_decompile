LinkLuaModifier( "modifier_lina_fiery_soul_custom", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_proc", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_proc_slow", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_fiery_soul_custom_legendary", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_lina_fiery_soul_custom_knockback", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_lina_fiery_soul_custom_heal", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_heal_cd", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_armor", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_armor_count", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_soul_custom_cast", "abilities/lina/lina_fiery_soul_custom", LUA_MODIFIER_MOTION_NONE)




lina_fiery_soul_custom = class({})

lina_fiery_soul_custom.shard_damage = 10

lina_fiery_soul_custom.base_speed_init = 0 
lina_fiery_soul_custom.base_speed_inc = 5
lina_fiery_soul_custom.base_move_init = 0 
lina_fiery_soul_custom.base_move_inc = 0.5

lina_fiery_soul_custom.spell_init = 0.5
lina_fiery_soul_custom.spell_inc = 0.5

lina_fiery_soul_custom.max_speed = 650
lina_fiery_soul_custom.max_stack = 2

lina_fiery_soul_custom.proc_chance_init = 5
lina_fiery_soul_custom.proc_chance_inc = 10
lina_fiery_soul_custom.proc_damage = 20
lina_fiery_soul_custom.proc_slow = -80
lina_fiery_soul_custom.proc_duration = 1
lina_fiery_soul_custom.proc_buf_duration = 3

lina_fiery_soul_custom.legendary_duration = 0.4
lina_fiery_soul_custom.legendary_distance = 100
lina_fiery_soul_custom.legendary_range = 400
lina_fiery_soul_custom.legendary_damage = 1.5
lina_fiery_soul_custom.legendary_cast = 3
lina_fiery_soul_custom.legendary_cd = 2
lina_fiery_soul_custom.legendary_mana = 100

lina_fiery_soul_custom.heal_duration = 5
lina_fiery_soul_custom.heal_cd = 45
lina_fiery_soul_custom.heal_heal = 0.4
lina_fiery_soul_custom.heal_negative = 0.4
lina_fiery_soul_custom.heal_interval = 1

lina_fiery_soul_custom.armor_init = 1
lina_fiery_soul_custom.armor_inc = 0.5
lina_fiery_soul_custom.armor_duration = 12


function lina_fiery_soul_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_lina_soul_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function lina_fiery_soul_custom:GetManaCost(iLevel)
  if self:GetCaster():HasModifier("modifier_lina_soul_legendary") then
    return self.legendary_mana
  end
 return 0
end

function lina_fiery_soul_custom:OnUpgrade()
if self:GetCaster():HasModifier("modifier_lina_soul_legendary") and self:GetLevel() == 1 then
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_fiery_soul_custom_cast", {duration = self.legendary_cast})
  
end    

end



function lina_fiery_soul_custom:GetCooldown(iLevel)
  if self:GetCaster():HasModifier("modifier_lina_soul_legendary") then
    return  self.legendary_cd
  end
 return 
end


function lina_fiery_soul_custom:GetIntrinsicModifierName()
  return "modifier_lina_fiery_soul_custom"
end


function lina_fiery_soul_custom:OnSpellStart()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_lina_soul_legendary") then return end

self:GetCaster():RemoveModifierByName("modifier_lina_fiery_soul_custom_cast")

self:GetCaster():EmitSound("Lina.Soul_Active")

local damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self.legendary_damage


if self:GetCaster():HasShard() then 
  local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
  if mod then 
    damage = damage + mod:GetStackCount()*self.shard_damage
  end
end
local particle = ParticleManager:CreateParticle("particles/lina_soul.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControl(particle, 1, Vector(self.legendary_range*0.8, 0, 0))
ParticleManager:SetParticleControl(particle, 3, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.legendary_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do 

  local damageTable = {
    victim      = enemy,
    damage      = damage,
    damage_type   = DAMAGE_TYPE_MAGICAL,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self
  }
    
  ApplyDamage(damageTable)


  enemy:EmitSound("Lina.Soul_Active_target")
  enemy:AddNewModifier(self:GetCaster(), self, "modifier_lina_fiery_soul_custom_knockback", {duration = self.legendary_duration * (1 - enemy:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
end

end

modifier_lina_fiery_soul_custom = class({})

function modifier_lina_fiery_soul_custom:IsHidden()
  return self:GetStackCount()==0
end

function modifier_lina_fiery_soul_custom:IsPurgable()
  return false
end

function modifier_lina_fiery_soul_custom:DestroyOnExpire()
  return false
end

function modifier_lina_fiery_soul_custom:OnCreated( kv )
  self.as_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
  self.ms_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
  self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
  self.duration = self:GetAbility():GetSpecialValueFor( "fiery_soul_stack_duration" )


  if not IsServer() then return end
  self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )
  self:AddParticle( self.particle, false, false, -1, false, false  )
end

function modifier_lina_fiery_soul_custom:OnRefresh( kv )
  self.as_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_attack_speed_bonus" )
  self.ms_bonus = self:GetAbility():GetSpecialValueFor( "fiery_soul_move_speed_bonus" )
  self.max_stacks = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )
  self.duration = self:GetAbility():GetSpecialValueFor( "fiery_soul_stack_duration" )


end

function modifier_lina_fiery_soul_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_MIN_HEALTH

  }

  return funcs
end

function modifier_lina_fiery_soul_custom:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_lina_soul_6") then return end
if self:GetParent():HasModifier("modifier_lina_fiery_soul_custom_heal_cd") then return end

return 1
end


function modifier_lina_fiery_soul_custom:OnTakeDamage(params)
if not IsServer() then return end

if self:GetParent() == params.attacker and 
  params.inflictor ~= nil and 
  (params.inflictor:GetName() == "lina_light_strike_array_custom" 
    or params.inflictor:GetName() == "lina_dragon_slave_custom" 
    or params.inflictor:GetName() == "lina_laguna_blade_custom"
    or params.inflictor:GetName() == "lina_fiery_soul_custom") then

   
    local max = self.max_stacks
    if self:GetCaster():HasModifier("modifier_lina_soul_5") then 
      max = max + self:GetAbility().max_stack
    end
    if self:GetStackCount()<max then
      self:IncrementStackCount()
    end

  self:SetDuration( self.duration, true )
  self:StartIntervalThink( self.duration )
  ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )

end





if params.unit ~= self:GetParent() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_lina_soul_6") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_lina_fiery_soul_custom_heal_cd") then return end

self:GetParent():SetHealth(self:GetParent():GetMaxHealth() * self:GetAbility().heal_heal)

local max = self:GetAbility():GetSpecialValueFor( "fiery_soul_max_stacks" )

if self:GetCaster():HasModifier("modifier_lina_soul_5") then 
   max = max + self:GetAbility().max_stack
end

self:SetStackCount(max)
self:SetDuration( self.duration, true )
self:StartIntervalThink( self.duration )




 local particle = ParticleManager:CreateParticle( "particles/lina_lowhp.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )

self:GetParent():EmitSound("Lina.Soul_lowhp")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_fiery_soul_custom_heal_cd", {duration = self:GetAbility().heal_cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_fiery_soul_custom_heal", {duration = self:GetAbility().heal_duration})

end

function modifier_lina_fiery_soul_custom:GetModifierIgnoreMovespeedLimit( params )
if self:GetCaster():HasModifier("modifier_lina_soul_5") then 
  return 1
end
    return 0
end

function modifier_lina_fiery_soul_custom:GetModifierMoveSpeed_Max( params )
if self:GetCaster():HasModifier("modifier_lina_soul_5") then 
  return self:GetAbility().max_speed
end

return 
end


function modifier_lina_fiery_soul_custom:GetModifierMoveSpeed_Limit()
if self:GetCaster():HasModifier("modifier_lina_soul_5") then 
  return self:GetAbility().max_speed
end

return 
end


function modifier_lina_fiery_soul_custom:GetModifierSpellAmplify_Percentage()
  local bonus = 0
  if self:GetCaster():HasModifier("modifier_lina_soul_2") then 
    bonus = self:GetAbility().spell_init + self:GetAbility().spell_inc*self:GetCaster():GetUpgradeStack("modifier_lina_soul_2")
  end


  return bonus*self:GetStackCount()
end



function modifier_lina_fiery_soul_custom:GetModifierMoveSpeedBonus_Percentage( params )
  local bonus = 0
  if self:GetCaster():HasModifier("modifier_lina_soul_1") then 
    bonus = self:GetAbility().base_move_init + self:GetAbility().base_move_inc*self:GetCaster():GetUpgradeStack("modifier_lina_soul_1")
  end


  return self:GetStackCount() * (self.ms_bonus + bonus)
end

function modifier_lina_fiery_soul_custom:GetModifierAttackSpeedBonus_Constant( params )
  local bonus = 0
  if self:GetCaster():HasModifier("modifier_lina_soul_1") then 
    bonus = self:GetAbility().base_speed_init + self:GetAbility().base_speed_inc*self:GetCaster():GetUpgradeStack("modifier_lina_soul_1")
  end

  return self:GetStackCount() * (self.as_bonus + bonus)
end

function modifier_lina_fiery_soul_custom:OnAbilityExecuted( params )
  if not IsServer() then return end
  if params.unit~=self:GetParent() then return end
  if self:GetParent():PassivesDisabled() then return end
  if not params.ability then return end
  if params.ability:IsItem() or params.ability:IsToggle() then return end
  if params.ability:GetName() == "mid_teleport" 
  or params.ability:GetName() == "custom_ability_observer" or params.ability:GetName() == "custom_ability_sentry"
  or params.ability:GetName() == "custom_ability_smoke"  then return end


  if params.ability ~= self:GetAbility() and self:GetCaster():HasModifier("modifier_lina_soul_legendary") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_fiery_soul_custom_cast", {duration = self:GetAbility().legendary_cast})
  end


  if self:GetCaster():HasModifier("modifier_lina_soul_4") then 

    local chance = self:GetAbility().proc_chance_init + self:GetAbility().proc_chance_inc*self:GetCaster():GetUpgradeStack("modifier_lina_soul_4")

    local random = RollPseudoRandomPercentage(chance,76,self:GetCaster())


    if random then 

      self:GetParent():EmitSound("Lina.Soul_proc")
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_fiery_soul_custom_proc", {duration = self:GetAbility().proc_buf_duration})
    end


  end

  if self:GetCaster():HasModifier("modifier_lina_soul_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_fiery_soul_custom_armor",{duration = self:GetAbility().armor_duration})
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_fiery_soul_custom_armor_count",{duration = self:GetAbility().armor_duration})
  end

end

function modifier_lina_fiery_soul_custom:OnIntervalThink()
  self:StartIntervalThink( -1 )
  self:SetStackCount( 0 )
  ParticleManager:SetParticleControl( self.particle, 1, Vector( self:GetStackCount(), 0, 0 ) )
end


modifier_lina_fiery_soul_custom_proc = class({})
function modifier_lina_fiery_soul_custom_proc:IsHidden() return false end
function modifier_lina_fiery_soul_custom_proc:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_proc:GetTexture() return "buffs/soul_proc" end
function modifier_lina_fiery_soul_custom_proc:GetEffectName()
 return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end


function modifier_lina_fiery_soul_custom_proc:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end



function modifier_lina_fiery_soul_custom_proc:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function modifier_lina_fiery_soul_custom_proc:GetModifierDamageOutgoing_Percentage()
  return self:GetAbility().proc_damage

end





function modifier_lina_fiery_soul_custom_proc:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_fiery_soul_custom_proc_slow", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().proc_duration})


end



modifier_lina_fiery_soul_custom_proc_slow = class({})
function modifier_lina_fiery_soul_custom_proc_slow:IsHidden() return false end
function modifier_lina_fiery_soul_custom_proc_slow:IsPurgable() return true end
function modifier_lina_fiery_soul_custom_proc_slow:GetTexture() return "buffs/soul_proc" end
function modifier_lina_fiery_soul_custom_proc_slow:GetEffectName()
 return "particles/lina_attack_slow.vpcf" end



function modifier_lina_fiery_soul_custom_proc_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_lina_fiery_soul_custom_proc_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().proc_slow
end





modifier_lina_fiery_soul_custom_knockback = class({})

function modifier_lina_fiery_soul_custom_knockback:IsHidden() return true end

function modifier_lina_fiery_soul_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.legendary_duration

  self.knockback_distance   = math.max((self.ability.legendary_distance + self.ability.legendary_range)  - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(),  self:GetAbility().legendary_distance)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_lina_fiery_soul_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_lina_fiery_soul_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_lina_fiery_soul_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_lina_fiery_soul_custom_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end



modifier_lina_fiery_soul_custom_heal_cd = class({})

function modifier_lina_fiery_soul_custom_heal_cd:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_heal_cd:IsHidden() return false end
function modifier_lina_fiery_soul_custom_heal_cd:IsDebuff() return true end
function modifier_lina_fiery_soul_custom_heal_cd:RemoveOnDeath() return false end
function modifier_lina_fiery_soul_custom_heal_cd:GetTexture()
  return "buffs/soul_heal" end
function modifier_lina_fiery_soul_custom_heal_cd:OnCreated(table)
  self.RemoveForDuel = true
end



modifier_lina_fiery_soul_custom_heal = class({})
function modifier_lina_fiery_soul_custom_heal:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_heal:IsHidden() return false end
function modifier_lina_fiery_soul_custom_heal:IsDebuff() return true end
function modifier_lina_fiery_soul_custom_heal:GetEffectName()
return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end

function modifier_lina_fiery_soul_custom_heal:GetTexture()
  return "buffs/soul_heal" end
function modifier_lina_fiery_soul_custom_heal:OnCreated(table)
if not IsServer() then return end 
  self.RemoveForDuel = true

  self.heal = self:GetAbility().heal_negative / self:GetAbility().heal_duration

  self:StartIntervalThink(self:GetAbility().heal_interval)
end


function modifier_lina_fiery_soul_custom_heal:OnIntervalThink()
if not IsServer() then return end

self:GetParent():EmitSound("Lina.Soul_lowhp_burn")
self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - self:GetParent():GetMaxHealth()*self.heal))

end





modifier_lina_fiery_soul_custom_armor = class({})
function modifier_lina_fiery_soul_custom_armor:IsHidden() return true end
function modifier_lina_fiery_soul_custom_armor:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_armor:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_fiery_soul_custom_armor:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_lina_fiery_soul_custom_armor:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_lina_fiery_soul_custom_armor_count")

if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


end

modifier_lina_fiery_soul_custom_armor_count = class({})
function modifier_lina_fiery_soul_custom_armor_count:IsHidden() return false end
function modifier_lina_fiery_soul_custom_armor_count:IsPurgable() return false end
function modifier_lina_fiery_soul_custom_armor_count:GetTexture() return "buffs/soul_armor" end
function modifier_lina_fiery_soul_custom_armor_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_lina_fiery_soul_custom_armor_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_lina_fiery_soul_custom_armor_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}

end

function modifier_lina_fiery_soul_custom_armor_count:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*(self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetCaster():GetUpgradeStack("modifier_lina_soul_3"))
end



modifier_lina_fiery_soul_custom_cast = class({})
function modifier_lina_fiery_soul_custom_cast:IsHidden() return true end
function modifier_lina_fiery_soul_custom_cast:IsPurgable() return false end

function modifier_lina_fiery_soul_custom_cast:OnCreated(table)
if not IsServer() then return end
self:GetAbility():SetActivated(true )
end

function modifier_lina_fiery_soul_custom_cast:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(false )
end