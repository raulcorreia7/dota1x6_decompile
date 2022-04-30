LinkLuaModifier( "modifier_phantom_assassin_phantom_blur", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_smoke", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )LinkLuaModifier( "modifier_phantom_assassin_phantom_cd", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_reduction", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_silence", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_stun", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_stunready", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_lowhp", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blur_slow", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_cd", "abilities/phantom_assassin/custom_phantom_assassin_blur", LUA_MODIFIER_MOTION_NONE )


    
custom_phantom_assassin_blur = class({})

custom_phantom_assassin_blur.legendary_duration = 1.2
custom_phantom_assassin_blur.legendary_hit = 1

custom_phantom_assassin_blur.chance_inc = 10

custom_phantom_assassin_blur.lowhp_hp = 30
custom_phantom_assassin_blur.lowhp_cd = 40

custom_phantom_assassin_blur.stun_ready = 2
custom_phantom_assassin_blur.stun_stun = 1
custom_phantom_assassin_blur.stun_silence = 1

custom_phantom_assassin_blur.evasion = 1
custom_phantom_assassin_blur.evasion_chance_init = 7
custom_phantom_assassin_blur.evasion_chance_inc = -2

custom_phantom_assassin_blur.move_regen_init = 2
custom_phantom_assassin_blur.move_regen_inc = 1
custom_phantom_assassin_blur.move_speed_init = 4
custom_phantom_assassin_blur.move_speed_inc = 4

custom_phantom_assassin_blur.delay_inc = 0.5


function custom_phantom_assassin_blur:GetIntrinsicModifierName() return "modifier_phantom_assassin_phantom_blur" end

function custom_phantom_assassin_blur:GetCooldown(iLevel)
if self:GetCaster():HasScepter() then return 18 end
return self.BaseClass.GetCooldown( self, iLevel )
end

function custom_phantom_assassin_blur:GetBehavior()
 if self:GetCaster():HasScepter() then return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
end

function custom_phantom_assassin_blur:OnSpellStart()
if not IsServer() then return end
  
  if self:GetCaster():HasScepter() then 
   self:GetCaster():Purge(false, true, false, false, false)
end

   local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_start.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
   ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())


  ProjectileManager:ProjectileDodge(self:GetCaster())
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_smoke", { duration = self:GetSpecialValueFor("duration")})

  if (self:GetCaster():HasModifier("modifier_phantom_assassin_blur_legendary"))then  
   
    if self:GetCaster():HasModifier("modifier_phantom_assassin_phantom_reduction") then 
      self:GetCaster():RemoveModifierByName("modifier_phantom_assassin_phantom_reduction")
    end

    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_reduction", {})

end

  local enemy = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)
    for _,i in ipairs(enemy) do
        i:AddNewModifier(self:GetCaster(), self, "modifier_blur_slow", {duration = 3})
    end
end



modifier_phantom_assassin_phantom_blur = class({})



function modifier_phantom_assassin_phantom_blur:OnCreated( kv )

  self.caster = self:GetCaster()
  self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
  self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
  self.interval = 0.2

 if not IsServer() then return end
  self:StartIntervalThink( self.interval )
end

function modifier_phantom_assassin_phantom_blur:OnRefresh(table)
  self:OnCreated(table)
  end


function modifier_phantom_assassin_phantom_blur:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_EVASION_CONSTANT, 
      MODIFIER_EVENT_ON_TAKEDAMAGE,

MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
 MODIFIER_EVENT_ON_DEATH
  }

end

function modifier_phantom_assassin_phantom_blur:OnDeath( params )
if not IsServer() or not self:GetParent():HasScepter() then return end
if params.attacker == self:GetParent() and params.unit:IsRealHero() then

  for i = 0,23 do
    local ability_search = self:GetParent():GetAbilityByIndex(i)
    if ability_search ~= nil then
      ability_search:EndCooldown()
  end
end
end
end

function modifier_phantom_assassin_phantom_blur:OnTakeDamage(params)
if not IsServer() then return end
if (self:GetParent() ~= params.unit ) then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blur_reduction") then return end
if (self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_hp)  then return end
if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_cd") then  return end
if self:GetParent():PassivesDisabled() then return end
        
  self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_phantom_assassin_phantom_cd", {duration = self:GetAbility().lowhp_cd})
  self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_phantom_assassin_phantom_lowhp", {})

  self:GetAbility():OnSpellStart()

end




function modifier_phantom_assassin_phantom_blur:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blur_blood") then return end
if params.target ~= self:GetParent() then return end


local chance = self:GetParent():GetEvasion()*100


chance = chance/(self:GetAbility().evasion_chance_init + self:GetAbility().evasion_chance_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_blood"))


local random = RollPseudoRandomPercentage(chance,76,self:GetParent())

if not random then return end

  self:GetParent():EmitSound("Hero_FacelessVoid.TimeDilation.Target") 

local trail_pfx = ParticleManager:CreateParticle("particles/pa_legendary_blur.vpcf", PATTACH_ABSORIGIN, self:GetParent())
   ParticleManager:ReleaseParticleIndex(trail_pfx)


return params.damage*self:GetAbility().evasion

end









function modifier_phantom_assassin_phantom_blur:GetModifierEvasion_Constant() if not self:GetParent():PassivesDisabled() then
    return self.evasion + self:GetAbility().chance_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_chance")
  end
end


function modifier_phantom_assassin_phantom_blur:IsHidden() return true end

function modifier_phantom_assassin_phantom_blur:IsDebuff() return false end

function modifier_phantom_assassin_phantom_blur:IsPurgable() return false end




modifier_phantom_assassin_phantom_smoke = class({})

function modifier_phantom_assassin_phantom_smoke:IsHidden()  return false end
function modifier_phantom_assassin_phantom_smoke:IsDebuff()  return false end
function modifier_phantom_assassin_phantom_smoke:IsPurgable() return false end



function modifier_phantom_assassin_phantom_smoke:GetEffectName()
  return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end

function modifier_phantom_assassin_phantom_smoke:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end






function modifier_phantom_assassin_phantom_smoke:OnCreated()
  if not self:GetAbility() then self:Destroy() return end
  self.RemoveForDuel = true

  self.vanish_radius = self:GetAbility():GetSpecialValueFor("radius")

  if IsServer() then

    self.delay = self:GetAbility():GetSpecialValueFor("delay") + self:GetAbility().delay_inc*my_game:GetUpgradeStack(self:GetParent(),"modifier_phantom_assassin_blur_delay")

    self:GetParent():EmitSound("Hero_PhantomAssassin.Blur")
    
    self.linger = false
    self:OnIntervalThink()
    self:StartIntervalThink(FrameTime())
  end
end

function modifier_phantom_assassin_phantom_smoke:OnRefresh()
  self:OnCreated()
end

function modifier_phantom_assassin_phantom_smoke:OnIntervalThink()
  if self.linger == true then return end
  
  local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.vanish_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false) 
    
  if #enemies > 0 then 

   for i = 1,#enemies do 
     if enemies[i] and enemies[i]:IsCourier() then 
        table.remove(enemies, i)
      end
    end
  end


  if #enemies > 0 then 
    self.linger = true
    self:SetDuration(self.delay, true)
    self:StartIntervalThink(-1)
    
  end

end


function modifier_phantom_assassin_phantom_smoke:OnDestroy()
  if IsServer() and (self:GetParent():IsConsideredHero() or self:GetParent():IsBuilding() or self:GetParent():IsCreep()) then
--------------------------------------------ТАЛАНТ УМЕНЬШЕНИЕ-----------------------------------------------
if (self:GetParent():HasModifier("modifier_phantom_assassin_blur_legendary"))then  
   
  local mod_legen = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_reduction")
    if mod_legen then 
      mod_legen:SetDuration(self:GetAbility().legendary_duration,true)
  end

end
----------------------------------------------------------------------------------------------------------------------------
    self:GetParent():EmitSound("Hero_PhantomAssassin.Blur.Break")
    if self:GetParent():HasModifier("modifier_phantom_assassin_blur_stun") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_stunready", {duration = self:GetAbility().stun_ready})
end

  end
end

function modifier_phantom_assassin_phantom_smoke:CheckState()
  return {
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true
  }
end

function modifier_phantom_assassin_phantom_smoke:GetPriority()
  return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_phantom_assassin_phantom_smoke:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
  }
end

function modifier_phantom_assassin_phantom_smoke:GetModifierInvisibilityLevel()
  return 1
end


function modifier_phantom_assassin_phantom_smoke:GetModifierMoveSpeedBonus_Percentage() 
local move = 0 
if self:GetParent():HasModifier("modifier_phantom_assassin_blur_heal") then 
  move = self:GetAbility().move_speed_init + self:GetAbility().move_speed_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_heal")
end

return move
end

function modifier_phantom_assassin_phantom_smoke:GetModifierHealthRegenPercentage() 

local heal = 0 
if self:GetParent():HasModifier("modifier_phantom_assassin_blur_heal") then 
  heal = self:GetAbility().move_regen_init + self:GetAbility().move_regen_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blur_heal")
end

return heal
end






---------------------------------------ТАЛАНТ ЛОУ ХП--------------------------------------------


modifier_phantom_assassin_phantom_reduction = class({})


function modifier_phantom_assassin_phantom_reduction:IsPurgable() return true end
function modifier_phantom_assassin_phantom_reduction:IsHidden() return false end
function modifier_phantom_assassin_phantom_reduction:IsDebuff() return false end
function modifier_phantom_assassin_phantom_reduction:RemoveOnDeath() return true end

function modifier_phantom_assassin_phantom_reduction:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()

self.particle_ally_fx = ParticleManager:CreateParticle("particles/pa_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
    self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  
end


function modifier_phantom_assassin_phantom_reduction:GetTexture()
  return "buffs/Blur_reduction" end

function modifier_phantom_assassin_phantom_reduction:DeclareFunctions()
  return 
{ 
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_EVENT_ON_ATTACK_LANDED
  }
end

function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamagePure() return 1 end
function modifier_phantom_assassin_phantom_reduction:GetAbsoluteNoDamageMagical() return 1 end
function modifier_phantom_assassin_phantom_reduction:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

local cd = self:GetAbility():GetCooldownTimeRemaining()
self:GetAbility():EndCooldown()

if cd > self:GetAbility().legendary_hit then 
  self:GetAbility():StartCooldown(cd - self:GetAbility().legendary_hit)
end
end



modifier_phantom_assassin_phantom_cd = class({})

function modifier_phantom_assassin_phantom_cd:IsPurgable() return false end
function modifier_phantom_assassin_phantom_cd:IsHidden() return false end
function modifier_phantom_assassin_phantom_cd:IsDebuff() return true end
function modifier_phantom_assassin_phantom_cd:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_cd:GetTexture()
  return "buffs/Blur_cd" end

function modifier_phantom_assassin_phantom_cd:OnCreated(table)
  self.RemoveForDuel = true
end


modifier_phantom_assassin_phantom_lowhp = class({})

function modifier_phantom_assassin_phantom_lowhp:IsPurgable() return false end
function modifier_phantom_assassin_phantom_lowhp:IsHidden() return true end
-----------------------------------------------------------------------------------------------


modifier_phantom_assassin_phantom_stunready = class({})

function modifier_phantom_assassin_phantom_stunready:IsPurgable() return false end
function modifier_phantom_assassin_phantom_stunready:IsHidden() return false end
function modifier_phantom_assassin_phantom_stunready:GetTexture()
  return "buffs/Blur_silence" end

function modifier_phantom_assassin_phantom_stunready:DeclareFunctions()
  return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED

}
end

function modifier_phantom_assassin_phantom_stunready:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() == params.attacker and not params.target:IsBuilding() then 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_stun", {duration = self:GetAbility().stun_stun})
  self:Destroy()
end

end



----------------------------------------------ТАЛАНТ КОНТРОЛЬ-------------------------------------------------
modifier_phantom_assassin_phantom_stun = class({})

function modifier_phantom_assassin_phantom_stun:IsPurgable() return true end
function modifier_phantom_assassin_phantom_stun:IsHidden() return false end

function modifier_phantom_assassin_phantom_stun:IsStunDebuff() return true end
function modifier_phantom_assassin_phantom_stun:CheckState()

 return {[MODIFIER_STATE_STUNNED] = true } 
end

function modifier_phantom_assassin_phantom_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
 
function modifier_phantom_assassin_phantom_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_phantom_assassin_phantom_stun:OnCreated(table)
self:GetParent():EmitSound("DOTA_Item.SkullBasher")
end

function modifier_phantom_assassin_phantom_stun:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_phantom_assassin_phantom_stun:GetOverrideAnimation()
return ACT_DOTA_STUN_STATUE
end

function modifier_phantom_assassin_phantom_stun:GetTexture()
  return "buffs/Blur_silence" end


function modifier_phantom_assassin_phantom_stun:OnDestroy()
if not IsServer() then return end

self:GetParent():EmitSound("Phantom_Assassin.Silence")
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_phantom_assassin_phantom_silence", {duration = self:GetAbility().stun_silence})


end

modifier_phantom_assassin_phantom_silence = class({})


function modifier_phantom_assassin_phantom_silence:IsPurgable() return true end
function modifier_phantom_assassin_phantom_silence:IsHidden() return false end
function modifier_phantom_assassin_phantom_silence:IsDebuff() return true end

function modifier_phantom_assassin_phantom_silence:GetTexture()
  return "buffs/Blur_silence" end


function modifier_phantom_assassin_phantom_silence:CheckState()

 return {[MODIFIER_STATE_SILENCED] = true } 
end

function modifier_phantom_assassin_phantom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_phantom_assassin_phantom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end




------------------------------------------------------------------------------------------------------------------------------------------

modifier_blur_slow = class({})
function modifier_blur_slow:IsHidden() return false end
function modifier_blur_slow:IsPurgable() return true end
function modifier_blur_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_blur_slow:GetModifierMoveSpeedBonus_Percentage() return -50 end
