LinkLuaModifier("modifier_bristleback_bristleback_custom", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_legendary_active", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_reflect_cd", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_reflect_ready", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_damage_tracker", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_damage", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_damage_count", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_ground_timer", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_ground", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_heal", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_bristleback_custom  = class({})

bristleback_bristleback_custom.quill_init = -5
bristleback_bristleback_custom.quill_inc = -5

bristleback_bristleback_custom.legendary_cd = 3
bristleback_bristleback_custom.legendary_spray = -20
bristleback_bristleback_custom.legendary_move = 200

bristleback_bristleback_custom.reflect_cd = 8

bristleback_bristleback_custom.damage_init = 270
bristleback_bristleback_custom.damage_inc = -60
bristleback_bristleback_custom.damage_duration = 10
bristleback_bristleback_custom.damage_spell = 2
bristleback_bristleback_custom.damage_speed = 15

bristleback_bristleback_custom.heal_damage = 0.25
bristleback_bristleback_custom.heal_init = 0
bristleback_bristleback_custom.heal_inc = 10
bristleback_bristleback_custom.heal_duration = 6

bristleback_bristleback_custom.return_init = 0
bristleback_bristleback_custom.return_inc = 0.01

bristleback_bristleback_custom.ground_timer = 3
bristleback_bristleback_custom.ground_timer_after = 3
bristleback_bristleback_custom.ground_reduce = 10
bristleback_bristleback_custom.ground_regen = 3



function bristleback_bristleback_custom:IsStealable()       return false end
function bristleback_bristleback_custom:ResetToggleOnRespawn()  return true end





function bristleback_bristleback_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bristle_back_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function bristleback_bristleback_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_bristle_back_legendary") then return self.legendary_cd end  
end



function bristleback_bristleback_custom:OnToggle() 
  local caster = self:GetCaster()
  local modifier = caster:FindModifierByName( "modifier_bristleback_bristleback_legendary_active" )

  if self:GetToggleState() then
    if not modifier then
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_legendary_active", {})
      self:StartCooldown(self.legendary_cd)
    end
  else
    if modifier then
      self:StartCooldown(self.legendary_cd)
      modifier:Destroy()
    end
  end
end







function bristleback_bristleback_custom:GetIntrinsicModifierName()
  return "modifier_bristleback_bristleback_custom"
end


modifier_bristleback_bristleback_custom = class({})

function modifier_bristleback_bristleback_custom:IsPurgable() return false end
function modifier_bristleback_bristleback_custom:IsHidden() return true end


function modifier_bristleback_bristleback_custom:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.heal_count = 0
  self.front_damage_reduction   = 0

  self.side_angle         = self.ability:GetSpecialValueFor("side_angle")
  self.back_angle         = self.ability:GetSpecialValueFor("back_angle")
  
  self.cumulative_damage      = self.cumulative_damage or 0
end

function modifier_bristleback_bristleback_custom:OnRefresh()
  self:OnCreated()
end

function modifier_bristleback_bristleback_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }
end

function modifier_bristleback_bristleback_custom:GetAbsorbSpell(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_bristle_back_reflect") then return end
if self:GetParent():PassivesDisabled() then return end

local forwardVector     = self:GetParent():GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self:GetParent():GetAbsOrigin() - params.ability:GetCaster():GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then
    if not self:GetParent():HasModifier("modifier_bristleback_bristleback_reflect_cd") then 
         
       local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix_ball_sphere_rings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)

        self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_reflect_cd", {duration = self:GetAbility().reflect_cd})
        return 1
    end
end


end



function modifier_bristleback_bristleback_custom:GetModifierIncomingDamage_Percentage(keys)
  if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

  local forwardVector     = self.caster:GetForwardVector()
  local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
      
  local reverseEnemyVector  = (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
  local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

  local difference = math.abs(forwardAngle - reverseEnemyAngle)

    self.front_damage_reduction   = 0
    if self:GetParent():HasModifier("modifier_bristleback_bristleback_heal") then 
      self.front_damage_reduction = self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_heal")
    end

    self.side_damage_reduction    = self.ability:GetSpecialValueFor("side_damage_reduction")
    self.back_damage_reduction    = self.ability:GetSpecialValueFor("back_damage_reduction")

    if self:GetParent():HasModifier("modifier_bristleback_bristleback_ground") then 

         self.side_damage_reduction    = self.side_damage_reduction + self:GetAbility().ground_reduce
         self.back_damage_reduction    = self.back_damage_reduction + self:GetAbility().ground_reduce
    end

  
  if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1))) or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active") then

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
  
    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle2)
    
    self.parent:EmitSound("Hero_Bristleback.Bristleback")

    return self.back_damage_reduction * (-1)


  elseif (difference <= (self.side_angle)) or (difference >= (360 - (self.side_angle))) then 

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    return self.side_damage_reduction * (-1)
  else
    return self.front_damage_reduction * (-1)
  end


end




function modifier_bristleback_bristleback_custom:OnTakeDamage( keys )
if keys.attacker == nil then return end
if keys.unit ~= self.parent then return end
if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or not self.parent:HasAbility("bristleback_quill_spray_custom") or not self.parent:FindAbilityByName("bristleback_quill_spray_custom"):IsTrained() then return end
  
  
   self.quill_release_threshold  = self.ability:GetSpecialValueFor("quill_release_threshold")
   if self:GetParent():HasModifier("modifier_bristle_back_spray") then 
     self.quill_release_threshold = self.quill_release_threshold + self:GetAbility().quill_init + self:GetAbility().quill_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_spray")
   end

    if self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active") then 
      self.quill_release_threshold = self.quill_release_threshold + self:GetAbility().legendary_spray
    end



   local forwardVector     = self.caster:GetForwardVector()
    local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
    local reverseEnemyVector  = (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
    local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

    local difference = math.abs(forwardAngle - reverseEnemyAngle)

    if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then
      
      if self:GetParent():HasModifier("modifier_bristle_back_heal") then
        self.heal_count = self.heal_count + keys.damage

        local max = self:GetParent():GetMaxHealth()*self:GetAbility().heal_damage
        if self.heal_count >= max then 
          self.heal_count = 0
          self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_heal", {duration = self:GetAbility().heal_duration})
        end

      end


      if self:GetParent():HasModifier("modifier_bristle_back_damage") then 
        local tracker = self:GetParent():FindModifierByName("modifier_bristleback_bristleback_damage_tracker")
        tracker:SetStackCount(tracker:GetStackCount() + keys.damage)

        if tracker:GetStackCount() >= self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_damage") then 
            
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_damage", {duration = self:GetAbility().damage_duration})    
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_damage_count", {duration = self:GetAbility().damage_duration})
       
            tracker:SetStackCount(0)
        end

      end


      self:SetStackCount(self:GetStackCount() + keys.damage)
      
      local quill_spray_ability = self.parent:FindAbilityByName("bristleback_quill_spray_custom")
      
      if quill_spray_ability and quill_spray_ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
        quill_spray_ability:MakeSpray()

        self:SetStackCount(0)
      end
    end

end




function modifier_bristleback_bristleback_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end



local forwardVector     = self:GetParent():GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then




if self:GetParent():HasModifier("modifier_bristle_back_return") then

    local damage = self:GetParent():GetMaxHealth()*(self:GetAbility().return_init + self:GetAbility().return_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_return"))
    
    ApplyDamage( {
        victim      = params.attacker,
        damage      = damage,
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self:GetParent(),
        ability     = self:GetAbility()
       }
     )

end

end

end








modifier_bristleback_bristleback_legendary_active = class({})


function modifier_bristleback_bristleback_legendary_active:IsHidden() return false end
function modifier_bristleback_bristleback_legendary_active:IsPurgable() return false end
function modifier_bristleback_bristleback_legendary_active:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
function modifier_bristleback_bristleback_legendary_active:GetTexture() return "buffs/Blade_fury_shield" end




function modifier_bristleback_bristleback_legendary_active:OnCreated(table)
if not IsServer() then return end
self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end

function modifier_bristleback_bristleback_legendary_active:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
}

end


function modifier_bristleback_bristleback_legendary_active:GetModifierMoveSpeed_Absolute() return self:GetAbility().legendary_move end



modifier_bristleback_bristleback_reflect_ready = class({})
function modifier_bristleback_bristleback_reflect_ready:IsHidden() return
  self:GetParent():HasModifier("modifier_bristleback_bristleback_reflect_cd")
end
function modifier_bristleback_bristleback_reflect_ready:IsPurgable() return false end
function modifier_bristleback_bristleback_reflect_ready:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_reflect_ready:GetTexture() return "buffs/back_reflect" end



modifier_bristleback_bristleback_reflect_cd = class({})
function modifier_bristleback_bristleback_reflect_cd:IsHidden() return false end
function modifier_bristleback_bristleback_reflect_cd:GetTexture() return "buffs/back_reflect" end
function modifier_bristleback_bristleback_reflect_cd:IsPurgable() return false end
function modifier_bristleback_bristleback_reflect_cd:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_reflect_cd:IsDebuff() return true end
function modifier_bristleback_bristleback_reflect_cd:OnCreated(table)
self.RemoveForDuel = true 
end



modifier_bristleback_bristleback_damage_tracker = class({})
function modifier_bristleback_bristleback_damage_tracker:IsHidden() return true end
function modifier_bristleback_bristleback_damage_tracker:IsPurgable() return false end
function modifier_bristleback_bristleback_damage_tracker:RemoveOnDeath() return false end


modifier_bristleback_bristleback_damage_count = class({})
function modifier_bristleback_bristleback_damage_count:IsHidden() return false end
function modifier_bristleback_bristleback_damage_count:IsPurgable() return false end
function modifier_bristleback_bristleback_damage_count:GetTexture() return "buffs/back_damage" end


function modifier_bristleback_bristleback_damage_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end
function modifier_bristleback_bristleback_damage_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_bristleback_bristleback_damage_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end

function modifier_bristleback_bristleback_damage_count:GetModifierSpellAmplify_Percentage() return self:GetStackCount()*self:GetAbility().damage_spell end
function modifier_bristleback_bristleback_damage_count:GetModifierAttackSpeedBonus_Constant()
 return self:GetStackCount()*self:GetAbility().damage_speed end




modifier_bristleback_bristleback_damage = class({})
function modifier_bristleback_bristleback_damage:IsHidden() return true end
function modifier_bristleback_bristleback_damage:IsPurgable() return false end
function modifier_bristleback_bristleback_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_bristleback_damage_count:GetEffectName() return "particles/bristle_back_buff_.vpcf" end

function modifier_bristleback_bristleback_damage:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_bristleback_bristleback_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_bristleback_bristleback_damage_count")
if not mod then return end
mod:DecrementStackCount()

if mod:GetStackCount() == 0 then 
  mod:Destroy()
end
end


modifier_bristleback_bristleback_ground_timer = class({})
function modifier_bristleback_bristleback_ground_timer:IsHidden() return true end
function modifier_bristleback_bristleback_ground_timer:IsPurgable() return false end
function modifier_bristleback_bristleback_ground_timer:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_ground_timer:OnDestroy()
if not IsServer() then return end

  local mod = self:GetParent():FindModifierByName("modifier_bristleback_bristleback_ground")
  if mod then 
    mod:Destroy()
 end
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_ground", {})  


end

function modifier_bristleback_bristleback_ground_timer:OnCreated(table)
if not IsServer() then return end
self.location = self:GetParent():GetAbsOrigin()
self:StartIntervalThink(FrameTime())
end

function modifier_bristleback_bristleback_ground_timer:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_RESPAWN

}
end

function modifier_bristleback_bristleback_ground_timer:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
  self:SetDuration(self:GetAbility().ground_timer, true)
end

function modifier_bristleback_bristleback_ground_timer:OnIntervalThink()
if not self:GetParent():IsAlive() then 

  self:SetDuration(9999, true)
  return 
end

if self:GetParent():GetAbsOrigin() ~= self.location then 
  self:SetDuration(self:GetAbility().ground_timer, true)
  self.location = self:GetParent():GetAbsOrigin()
end 

end






modifier_bristleback_bristleback_ground = class({})
function modifier_bristleback_bristleback_ground:IsHidden() return false end
function modifier_bristleback_bristleback_ground:IsPurgable() return false end
function modifier_bristleback_bristleback_ground:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_ground:GetTexture() return "buffs/back_ground" end

function modifier_bristleback_bristleback_ground:OnCreated(table)
if not IsServer() then return end
self.moved = false
self.location = self:GetParent():GetAbsOrigin()

self:GetParent():EmitSound("BB.Back_ground")
self.ground_particle = ParticleManager:CreateParticle("particles/brist_ground_.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)

self:StartIntervalThink(FrameTime())
end

function modifier_bristleback_bristleback_ground:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_bristleback_bristleback_ground:GetModifierHealthRegenPercentage()
return
self:GetAbility().ground_regen
end

function modifier_bristleback_bristleback_ground:OnIntervalThink()
if not IsServer() then return end
if self.moved == true then return end
if not self:GetParent():IsAlive() then return end

if self:GetParent():GetAbsOrigin() ~= self.location then 
  self.location = self:GetParent():GetAbsOrigin()
  self.moved = true 
  self:SetDuration(self:GetAbility().ground_timer_after, true)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_ground_timer", { duration = self:GetAbility().ground_timer})
end 


end



modifier_bristleback_bristleback_heal = class({})
function modifier_bristleback_bristleback_heal:IsHidden() return false end
function modifier_bristleback_bristleback_heal:IsPurgable() return true end
function modifier_bristleback_bristleback_heal:GetTexture() return "buffs/back_shield" end
function modifier_bristleback_bristleback_heal:GetEffectName() return "particles/brist_shield.vpcf" end

function modifier_bristleback_bristleback_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_bristleback_bristleback_heal:OnTooltip()
return self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_heal")
end

function modifier_bristleback_bristleback_heal:OnCreated(table)
if not IsServer() then return end
  self:GetParent():EmitSound("BB.Back_shield")
end


