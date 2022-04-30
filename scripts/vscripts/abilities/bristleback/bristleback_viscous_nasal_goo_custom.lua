LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_custom", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_tracker", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_damage", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_stack", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_stack_cd", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_ground_tracker", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_ground_poison", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)

bristleback_viscous_nasal_goo_custom              = class({})

bristleback_viscous_nasal_goo_custom.max_init = 0
bristleback_viscous_nasal_goo_custom.max_inc = 1

bristleback_viscous_nasal_goo_custom.proc_inc = 0
bristleback_viscous_nasal_goo_custom.proc_init = 5

bristleback_viscous_nasal_goo_custom.legendary_chance = 2.5
bristleback_viscous_nasal_goo_custom.legendary_stun = 0.4

bristleback_viscous_nasal_goo_custom.damage_health = 0.02
bristleback_viscous_nasal_goo_custom.damage_interval = 1
bristleback_viscous_nasal_goo_custom.damage_interval = 1
bristleback_viscous_nasal_goo_custom.damage_init = 3
bristleback_viscous_nasal_goo_custom.damage_inc = 1

bristleback_viscous_nasal_goo_custom.status = -4

bristleback_viscous_nasal_goo_custom.stacks_stacks = 4
bristleback_viscous_nasal_goo_custom.stacks_cd = 25
bristleback_viscous_nasal_goo_custom.stacks_duration = 1

bristleback_viscous_nasal_goo_custom.ground_duration = 8
bristleback_viscous_nasal_goo_custom.ground_damage = 50
bristleback_viscous_nasal_goo_custom.ground_radius = 150
bristleback_viscous_nasal_goo_custom.ground_chance = {20,30,40}
bristleback_viscous_nasal_goo_custom.ground_interval = 1



function bristleback_viscous_nasal_goo_custom:GetIntrinsicModifierName() return "modifier_bristleback_viscous_nasal_goo_tracker" end



function bristleback_viscous_nasal_goo_custom:GetBehavior()
  if self:GetCaster():HasScepter() then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  else
    return self.BaseClass.GetBehavior(self)
  end
end

function bristleback_viscous_nasal_goo_custom:GetCastRange(location, target)
  if self:GetCaster():HasScepter() then
    return self:GetSpecialValueFor("radius_scepter") - self:GetCaster():GetCastRangeBonus()
  else
    return self.BaseClass.GetCastRange(self, location, target)
  end
end

function bristleback_viscous_nasal_goo_custom:OnSpellStart(target, unit)

  if target == nil then 
    enemy = self:GetCursorTarget()
    if self:GetCaster():HasScepter() then 
       self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end

  else 
    enemy = target
  end

  if unit == nil then 
    self.location = self:GetCaster():GetAbsOrigin()
    self.source_caster = self:GetCaster()
  else 
    self.location = unit:GetAbsOrigin()
    self.source_caster = unit
  end




  self.caster = self:GetCaster()

  self.goo_speed          = self:GetSpecialValueFor("goo_speed")
  self.goo_duration       = self:GetSpecialValueFor("goo_duration")
  self.goo_duration_creep     = self:GetSpecialValueFor("goo_duration_creep")
  self.radius_scepter       = self:GetSpecialValueFor("radius_scepter")


  local projectile = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf"
  local more_stacks = false
  if self:GetCaster():HasModifier("modifier_bristleback_viscous_nasal_goo_stack") and not self:GetCaster():HasModifier("modifier_bristleback_viscous_nasal_goo_stack_cd") then 
  
    projectile = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf"
    more_stacks = true
 
  end

  local stacks_cd = false 

  if not IsServer() then return end

  self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")

  if self.caster:HasScepter() and unit == nil then
    local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

    if #enemies > 0 and more_stacks == true then 
      stacks_cd = true
    end

    for _, enemy in pairs(enemies) do
      local projectile =
      {
        Target        = enemy,
        Source        = self.caster,
        Ability       = self,
        EffectName      = projectile,
        iMoveSpeed      = self.goo_speed,
        vSourceLoc      = self.caster:GetAbsOrigin(),
        bDrawsOnMinimap   = false,
        bDodgeable      = true,
        bIsAttack       = false,
        bVisibleToEnemies = true,
        bReplaceExisting  = false,
        flExpireTime    = GameRules:GetGameTime() + 10,
        bProvidesVision   = false,
        iVisionRadius     = 0,
        iVisionTeamNumber   = self.caster:GetTeamNumber(),
        ExtraData = {more_stacks = more_stacks}
      }

      ProjectileManager:CreateTrackingProjectile(projectile)
    end
  else
    self.target = enemy

    if more_stacks == true then 
      stacks_cd = true 
    end

    local projectile =
    {
      Target        = self.target,
      Source        = self.source_caster,
      Ability       = self,
      EffectName      = projectile,
      iMoveSpeed      = self.goo_speed,
      vSourceLoc      = self.location,
      bDrawsOnMinimap   = false,
      bDodgeable      = true,
      bIsAttack       = false,
      bVisibleToEnemies = true,
      bReplaceExisting  = false,
      flExpireTime    = GameRules:GetGameTime() + 10,
      bProvidesVision   = false,
      ExtraData = {more_stacks = more_stacks}
    }
    
    ProjectileManager:CreateTrackingProjectile(projectile)
  end
    
  if stacks_cd == true then 
    
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_stack_cd", {duration = self.stacks_cd})
  end

  if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
    self.caster:EmitSound("bristleback_bristle_nasal_goo_0"..math.random(1,7))
  end

end

function bristleback_viscous_nasal_goo_custom:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
if hTarget == nil or not hTarget:IsAlive() or hTarget:IsMagicImmune() then return end

    if not self:GetCaster():HasScepter() then 
      if hTarget:TriggerSpellAbsorb(self) then return end
    end

    local duration = self.goo_duration
    if hTarget:IsCreep() then 
      duration = self.goo_duration_creep
    end

    if self:GetCaster():HasModifier("modifier_bristle_goo_stack") then 
      duration = duration + self.stacks_duration
    end

    local stacks = 1
    if ExtraData.more_stacks == 1 then 
      stacks = self.stacks_stacks
    end

    if self:GetCaster():HasModifier("modifier_bristle_goo_ground") then 


      local chance = self.ground_chance[self:GetCaster():GetUpgradeStack("modifier_bristle_goo_ground")]

      local random = RollPseudoRandomPercentage(chance,117,self:GetCaster())
     
      if random  then 
         CreateModifierThinker(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_ground_tracker", {duration = self.ground_duration}, hTarget:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
         hTarget:EmitSound("BB.Goo_poison")
         self.particle = ParticleManager:CreateParticle("particles/bristle_goo_ground.vpcf", PATTACH_WORLDORIGIN, nil)
         ParticleManager:SetParticleControl(self.particle, 1, hTarget:GetAbsOrigin())
         ParticleManager:SetParticleControl(self.particle, 3, hTarget:GetAbsOrigin())
         ParticleManager:ReleaseParticleIndex(self.particle)
      end
    end
   

    for i = 1,stacks do
       hTarget:AddNewModifier(self.caster, self, "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - hTarget:GetStatusResistance())})
    end

    hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")
    

    if self:GetCaster():HasModifier("modifier_bristle_goo_damage") then 
      hTarget:AddNewModifier(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_damage", {duration = self:GetCaster():GetUpgradeStack("modifier_bristle_goo_damage")})
    end

end

modifier_bristleback_viscous_nasal_goo_custom = class({})


function modifier_bristleback_viscous_nasal_goo_custom:GetEffectName()
  return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

function modifier_bristleback_viscous_nasal_goo_custom:GetStatusEffectName()
  return "particles/status_fx/status_effect_goo.vpcf"
end



function modifier_bristleback_viscous_nasal_goo_custom:StatusEffectPriority()
    return 10
end



function modifier_bristleback_viscous_nasal_goo_custom:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  self.RemoveForDuel = true
  
  self.base_armor       = self.ability:GetSpecialValueFor("base_armor")
  self.armor_per_stack    = self.ability:GetSpecialValueFor("armor_per_stack")
  self.base_move_slow     = self.ability:GetSpecialValueFor("base_move_slow")
  self.move_slow_per_stack  = self.ability:GetSpecialValueFor("move_slow_per_stack")
  self.stack_limit      = self.ability:GetSpecialValueFor("stack_limit")
  
  if self:GetCaster():HasScepter() then 
    self.stack_limit = self.ability:GetSpecialValueFor("stack_limit_scepter")
  end

  if self:GetCaster():HasModifier("modifier_bristle_goo_max") then 
    self.stack_limit = self.stack_limit + self:GetAbility().max_init + self:GetAbility().max_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_goo_max")
  end




  if not IsServer() then return end


  self:SetStackCount(1)
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
  self:AddParticle(self.particle, false, false, -1, false, false)
end




function modifier_bristleback_viscous_nasal_goo_custom:OnRefresh()
  if not IsServer() then return end

  if self:GetStackCount() < self.stack_limit then
    self:IncrementStackCount()
    ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
  end

end



function modifier_bristleback_viscous_nasal_goo_custom:DeclareFunctions()
    return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
    }
end


function modifier_bristleback_viscous_nasal_goo_custom:GetModifierMoveSpeedBonus_Percentage()
    return ((self.base_move_slow + (self.move_slow_per_stack * self:GetStackCount())) * (-1))
end

function modifier_bristleback_viscous_nasal_goo_custom:GetModifierPhysicalArmorBonus()
    return ((self.base_armor + (self.armor_per_stack * self:GetStackCount())) * (-1))
end


function modifier_bristleback_viscous_nasal_goo_custom:GetModifierStatusResistanceStacking()
if self:GetCaster():HasModifier("modifier_bristle_goo_status") then 
  return self:GetAbility().status*self:GetStackCount()
else 
  return 0
end


end

modifier_bristleback_viscous_nasal_goo_tracker = class({})
function modifier_bristleback_viscous_nasal_goo_tracker:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_tracker:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_bristleback_viscous_nasal_goo_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.unit:IsBuilding() then return end

if not self:GetParent():HasModifier("modifier_bristle_goo_legendary") then return end
if not params.unit:HasModifier("modifier_bristleback_viscous_nasal_goo_custom") then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end


local chance = params.unit:FindModifierByName("modifier_bristleback_viscous_nasal_goo_custom"):GetStackCount()*self:GetAbility().legendary_chance
local random = RollPseudoRandomPercentage(chance,112,self:GetParent())
if not  random  then return end 

params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self:GetAbility().legendary_stun*(1 - params.unit:GetStatusResistance())})
params.unit:EmitSound("BB.Goo_stun")     

end










function modifier_bristleback_viscous_nasal_goo_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_bristle_goo_proc") then return end

local target = nil

if params.attacker == self:GetParent() then 
  target = params.target
else
  if params.target == self:GetParent() then 
    target = params.attacker
  end
end

if target:IsBuilding() then return end
if target:IsMagicImmune() then return end


local chance = self:GetAbility().proc_init + self:GetAbility().proc_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_goo_proc")
local random = RollPseudoRandomPercentage(chance,72,self:GetCaster())


if not random then return end

local duration = self:GetAbility():GetSpecialValueFor("goo_duration")
if target:IsCreep() then 
    duration = self:GetAbility():GetSpecialValueFor("goo_duration_creep")
end

target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - target:GetStatusResistance())})
    
self:GetParent():EmitSound("Hero_Bristleback.ViscousGoo.Cast")
target:EmitSound("Hero_Bristleback.ViscousGoo.Target")

end




modifier_bristleback_viscous_nasal_goo_damage = class({})

function modifier_bristleback_viscous_nasal_goo_damage:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_damage:IsPurgable() return true end
function modifier_bristleback_viscous_nasal_goo_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_viscous_nasal_goo_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_bristleback_viscous_nasal_goo_damage:OnIntervalThink()
if not IsServer() then return end
  local damage = self:GetCaster():GetMaxHealth()*self:GetAbility().damage_health
                  
  ApplyDamage( {
        victim      = self:GetParent(),
        damage      = damage,
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self:GetCaster(),
        ability     = self:GetAbility()
       }
       )
end






modifier_bristleback_viscous_nasal_goo_stack = class({})
function modifier_bristleback_viscous_nasal_goo_stack:IsHidden() 
return self:GetParent():HasModifier("modifier_bristleback_viscous_nasal_goo_stack_cd") end
function modifier_bristleback_viscous_nasal_goo_stack:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_stack:GetTexture() return "buffs/goo_stack" end
function modifier_bristleback_viscous_nasal_goo_stack:RemoveOnDeath() return false end

modifier_bristleback_viscous_nasal_goo_stack_cd = class({})
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:GetTexture() return "buffs/goo_stack" end
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsDebuff() return true end
function modifier_bristleback_viscous_nasal_goo_stack_cd:RemoveOnDeath() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
end


modifier_bristleback_viscous_nasal_goo_ground_tracker = class({})
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsAura() return true end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraDuration() return 0.1 end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraRadius() return self:GetAbility().ground_radius
 end

function modifier_bristleback_viscous_nasal_goo_ground_tracker:OnCreated(table)
if not IsServer() then return end
end


function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetModifierAura() return "modifier_bristleback_viscous_nasal_goo_ground_poison" end


modifier_bristleback_viscous_nasal_goo_ground_poison = class({})
function modifier_bristleback_viscous_nasal_goo_ground_poison:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_ground_poison:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_ground_poison:GetTexture() return "buffs/goo_ground" end
function modifier_bristleback_viscous_nasal_goo_ground_poison:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:OnTooltip()
return self:GetAbility().ground_damage
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:GetStatusEffectName()
  return "particles/status_fx/status_effect_goo.vpcf"
end


function modifier_bristleback_viscous_nasal_goo_ground_poison:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetAbility().ground_damage
self:StartIntervalThink(self:GetAbility().ground_interval)
self:OnIntervalThink()
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:OnIntervalThink()
if not IsServer() then return end
  ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, ability = self:GetAbility()})

end