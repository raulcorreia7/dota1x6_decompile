LinkLuaModifier( "modifier_lina_dragon_slave_custom_stack", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )

lina_dragon_slave_custom = class({})

lina_dragon_slave_custom.shard_damage = 10

lina_dragon_slave_custom.damage_init = 0
lina_dragon_slave_custom.damage_inc = 40

lina_dragon_slave_custom.heal_health = 0.1
lina_dragon_slave_custom.heal_mana = 0.1
lina_dragon_slave_custom.heal_chance_init = 10
lina_dragon_slave_custom.heal_chance_inc = 10

lina_dragon_slave_custom.stack_duration = 10
lina_dragon_slave_custom.stack_stun = 1.2
lina_dragon_slave_custom.stack_max = 3

lina_dragon_slave_custom.legendary_cd = 1
lina_dragon_slave_custom.legendary_chance = 35
lina_dragon_slave_custom.legendary_duration = 6

lina_dragon_slave_custom.time_cast = 0.3
lina_dragon_slave_custom.time_cd = 1

lina_dragon_slave_custom.cd_init = 0.05
lina_dragon_slave_custom.cd_inc = 0.05

lina_dragon_slave_custom.burn_duration = 3
lina_dragon_slave_custom.burn_init = 0.01
lina_dragon_slave_custom.burn_inc = 0.01
lina_dragon_slave_custom.burn_interval = 1
lina_dragon_slave_custom.burn_creep = 0.33


function lina_dragon_slave_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 
  return self.time_cast
end

return 0.45
end



function lina_dragon_slave_custom:GetCooldown(iLevel)

local k = 1
if self:GetCaster():HasModifier("modifier_lina_dragon_3") then 
  k = k - self.cd_init - self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_3")
end

if self:GetCaster():HasModifier("modifier_lina_dragon_slave_custom_legendary") then 
  return self.legendary_cd*k
end

 return self.BaseClass.GetCooldown(self, iLevel)*k

end

function lina_dragon_slave_custom:GetIntrinsicModifierName()
return "modifier_lina_dragon_slave_custom_tracker"
end

function lina_dragon_slave_custom:OnSpellStart(new_target)
  if not IsServer() then return end
  local caster = self:GetCaster()

  local target = self:GetCursorTarget()
  if new_target ~= nil then 
    target = new_target
  end

  local point = self:GetCursorPosition()


  if target then point = target:GetAbsOrigin()  end

  if point == self:GetCaster():GetAbsOrigin() then 
    point = point + self:GetCaster():GetForwardVector()*10
  end

  local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
  local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
  local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
  local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

  local direction = point-caster:GetAbsOrigin()
  direction.z = 0
  local projectile_normalized = direction:Normalized()


  if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 

    for i = 0, 8 do
        local current_item = self:GetCaster():GetItemInSlot(i)
  

        if current_item and current_item:GetName() ~= "item_aeon_disk" then  
          local cd = current_item:GetCooldownTimeRemaining()
          current_item:EndCooldown()
          if cd > self.time_cd then 
            current_item:StartCooldown(cd - self.time_cd)
          end
 
        end
    end

  end

  local info = {
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetAbsOrigin(),
      bDeleteOnHit = false,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
      EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
      fDistance = projectile_distance,
      fStartRadius = projectile_start_radius,
      fEndRadius = projectile_end_radius,
      vVelocity = projectile_normalized * projectile_speed,
      bProvidesVision = false,
  }

  ProjectileManager:CreateLinearProjectile(info)
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave.Cast")
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave")


  if self:GetCaster():HasModifier("modifier_lina_dragon_2") then 

    local chance = self.heal_chance_init + self.heal_chance_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_2")

    local random = RollPseudoRandomPercentage(chance,123,self:GetCaster())


    if random then 
      local heal = self:GetCaster():GetMaxHealth()*self.heal_health
      local mana = self:GetCaster():GetMaxMana()*self.heal_mana

      
      local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
      ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetAbsOrigin() )
      ParticleManager:ReleaseParticleIndex( particle )
      self:GetCaster():EmitSound("Lina.Dragon_heal")

      self:GetCaster():Heal(heal, self)
      self:GetCaster():GiveMana(mana)
      SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)



    end


  end

end

function lina_dragon_slave_custom:OnProjectileHitHandle( target, location, projectile )
  if not IsServer() then return end
  if not target then return end

  local damage = self:GetAbilityDamage()


  if self:GetCaster():HasModifier("modifier_lina_dragon_1") then 
    damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_1")
  end

  if self:GetCaster():HasShard() then 
    local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
    if mod then 
      damage = damage + mod:GetStackCount()*self.shard_damage
    end
  end

  if target:IsBuilding() then 
    damage = damage*self:GetSpecialValueFor("building_damage")/100
  end


  if self:GetCaster():HasModifier("modifier_lina_dragon_6") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_stack", {duration = self.stack_duration})
  end

  if self:GetCaster():HasModifier("modifier_lina_dragon_4") and not target:IsBuilding() then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_burn", {duration = self.burn_duration})
  end

  ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self } )

  local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
  direction.z = 0
  direction = direction:Normalized()

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
  ParticleManager:SetParticleControlForward( particle, 1, direction )
  ParticleManager:ReleaseParticleIndex( particle )
end



modifier_lina_dragon_slave_custom_stack = class({})
function modifier_lina_dragon_slave_custom_stack:IsHidden() return false end
function modifier_lina_dragon_slave_custom_stack:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_stack:GetTexture() return "buffs/dragon_stack" end
function modifier_lina_dragon_slave_custom_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_lina_dragon_slave_custom_stack:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().stack_max then 

  local stun = self:GetAbility().stack_stun

  self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex(self.effect_cast)
  self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.Target")

  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun*(1 - self:GetParent():GetStatusResistance())})

  self:Destroy()

end

end


function modifier_lina_dragon_slave_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/lina_stack_stun.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end


function modifier_lina_dragon_slave_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_lina_dragon_slave_custom_stack:OnTooltip()
return self:GetAbility().stack_max
end

modifier_lina_dragon_slave_custom_legendary = class({})
function modifier_lina_dragon_slave_custom_legendary:IsHidden() return false end
function modifier_lina_dragon_slave_custom_legendary:IsPurgable() return false end 
function modifier_lina_dragon_slave_custom_legendary:GetEffectName() return "particles/huskar_spears_legen.vpcf" end
function modifier_lina_dragon_slave_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end
function modifier_lina_dragon_slave_custom_legendary:StatusEffectPriority() return
11111
end

function modifier_lina_dragon_slave_custom_legendary:OnCreated(table)
self.RemoveForDuel = true

self:GetParent():EmitSound("Lina.Dragon_legendary")
  --self.hands = ParticleManager:CreateParticle("particles/huskar_hands.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
 -- ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
  --self:AddParticle(self.hands,true,false,0,false,false)

end


modifier_lina_dragon_slave_custom_tracker = class({})
function modifier_lina_dragon_slave_custom_tracker:IsHidden() return true end
function modifier_lina_dragon_slave_custom_tracker:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED
}
end


function modifier_lina_dragon_slave_custom_tracker:OnAbilityExecuted( params )
  if not IsServer() then return end
  if params.unit~=self:GetParent() then return end
  if not params.ability then return end
  if self:GetParent():HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
  if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then return end
  if params.ability:IsItem() or params.ability:IsToggle() then return end
  if params.ability:GetName() == "mid_teleport" 
  or params.ability:GetName() == "custom_ability_observer" or params.ability:GetName() == "custom_ability_sentry"
  or params.ability:GetName() == "custom_ability_smoke"   then return end


  local chance = self:GetAbility().legendary_chance

  local random = RollPseudoRandomPercentage(chance,127,self:GetCaster())

  if random then 
    if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
      self:GetAbility():EndCooldown()
    end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_dragon_slave_custom_legendary", {duration = self:GetAbility().legendary_duration})
  end
end




modifier_lina_dragon_slave_custom_burn = class({})
function modifier_lina_dragon_slave_custom_burn:IsHidden() return false end
function modifier_lina_dragon_slave_custom_burn:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_dragon_slave_custom_burn:GetTexture() return "buffs/dragon_burn" end
function modifier_lina_dragon_slave_custom_burn:GetEffectName()
return "particles/roshan_meteor_burn_.vpcf"
end

function modifier_lina_dragon_slave_custom_burn:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().burn_interval)
end

function modifier_lina_dragon_slave_custom_burn:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetParent():GetMaxHealth()*(self:GetAbility().burn_init + self:GetAbility().burn_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_4"))
if not self:GetParent():IsHero() then 
  damage = damage*self:GetAbility().burn_creep
end

 ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() } )

  SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)

end