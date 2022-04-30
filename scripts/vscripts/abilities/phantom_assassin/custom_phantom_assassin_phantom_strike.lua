LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_buff", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_passive", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_vision", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_slow", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_legendary", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )

 
  
custom_phantom_assassin_phantom_strike = class({})

custom_phantom_assassin_phantom_strike.illusion_duration = 6
custom_phantom_assassin_phantom_strike.illusion_damage_init = 10
custom_phantom_assassin_phantom_strike.illusion_damage_inc = 10
custom_phantom_assassin_phantom_strike.illusion_health_init = 500
custom_phantom_assassin_phantom_strike.illusion_health_inc = -100

custom_phantom_assassin_phantom_strike.legendary_cd = 1.5
custom_phantom_assassin_phantom_strike.legendary_damage = 1.2
custom_phantom_assassin_phantom_strike.legendary_damage_illusion = 0.5

custom_phantom_assassin_phantom_strike.move_move_init = 10
custom_phantom_assassin_phantom_strike.move_move_inc = 10

custom_phantom_assassin_phantom_strike.blind_duration = 1
custom_phantom_assassin_phantom_strike.blind_damage = 30

custom_phantom_assassin_phantom_strike.blink_chance = 10

custom_phantom_assassin_phantom_strike.stats_init = 0
custom_phantom_assassin_phantom_strike.stats_inc = 5

custom_phantom_assassin_phantom_strike.duration_init = 0
custom_phantom_assassin_phantom_strike.duration_inc = 0.5

custom_phantom_assassin_phantom_strike.heal = 0.02
custom_phantom_assassin_phantom_strike.heal_range = 300


function custom_phantom_assassin_phantom_strike:GetCooldown(iLevel)

local upgrade_cooldown = 0
if false and self:GetCaster():HasModifier("modifier_phantom_assassin_blink_legendary") then 
  upgrade_cooldown = self.legendary_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end

function custom_phantom_assassin_phantom_strike:GetIntrinsicModifierName() 

  return "modifier_phantom_assassin_phantom_strike_passive" 
end

function custom_phantom_assassin_phantom_strike:GetBehavior()
  if false and self:GetCaster():HasModifier("modifier_phantom_assassin_blink_legendary") then
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end


function custom_phantom_assassin_phantom_strike:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "blink_range" )

local bonus = 0
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_blink") then 
  bonus = self.heal_range
end

return max_dist + bonus


end



--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_phantom_assassin_phantom_strike:CastFilterResultTarget( hTarget )
  if self:GetCaster() == hTarget then
    return UF_FAIL_CUSTOM
  end

  local result = UnitFilter(
    hTarget,  -- Target Filter
    DOTA_UNIT_TARGET_TEAM_BOTH, -- Team Filter
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, -- Unit Filter
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- Unit Flag
    self:GetCaster():GetTeamNumber()  -- Team reference
  )
  
  if result ~= UF_SUCCESS then
    return result
  end

  return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function custom_phantom_assassin_phantom_strike:GetCustomCastErrorTarget( hTarget )
  if self:GetCaster() == hTarget then
    return "#dota_hud_error_cant_cast_on_self"
  end

  return ""
end



function custom_phantom_assassin_phantom_strike:Blind_Line(origin, target)
if not IsServer() then return end
local caster = self:GetCaster()
local attack = FindUnitsInLine(caster:GetTeamNumber(), origin,target, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

  for _,i in ipairs(attack) do



    

    local particle = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt_bladekeeper.vpcf", PATTACH_ABSORIGIN_FOLLOW,i )
    ParticleManager:SetParticleControlEnt( particle, 0, i, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", i:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, i, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", i:GetAbsOrigin(), true )

    local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, i)
    ParticleManager:SetParticleControl(trail_pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(trail_pfx, 1, i:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(trail_pfx)


    local k = self.legendary_damage
    if caster:IsIllusion() then 
      k = self.legendary_damage_illusion
    end

    local damage = {
        victim = i,
        attacker = caster,
        damage = caster:GetAgility()*k,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self
    }
    ApplyDamage( damage )
  end


end






function custom_phantom_assassin_phantom_strike:GetCastAnimation()     
if false and self:GetCaster():HasModifier("modifier_phantom_assassin_blink_legendary") then 
 return ACT_DOTA_ATTACK_EVENT
end 
 return ACT_DOTA_CAST_ABILITY_2 
end





function custom_phantom_assassin_phantom_strike:OnSpellStart()
local caster = self:GetCaster()
local origin = caster:GetOrigin()
self.duration = self:GetSpecialValueFor("duration") 
local target = self:GetCursorTarget()

if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_duration") then 
  local bonus = self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_duration")
  self.duration = self.duration  + bonus 
end



if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_move") then 

  local end_pos

  if self:GetCursorTarget() ~= nil then 
    end_pos = self:GetCursorTarget():GetAbsOrigin()
  else 
    end_pos = self:GetCursorPosition()
  end

  local slow_units = FindUnitsInLine(caster:GetTeamNumber(), origin,end_pos, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE)

  for _,slow_unit in pairs(slow_units) do
    slow_unit:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_slow", {duration = self.duration*(1 - slow_unit:GetStatusResistance())})
  end
end

--------------------------------------------------------------------ТАЛАНТ ДЛИТЕЛЬНОСТЬ -------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------



  if target:GetTeamNumber()~=caster:GetTeamNumber() then
    if target:TriggerSpellAbsorb( self ) then return end
  end

  local blinkDistance = 50
  local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
  local blinkPosition = target:GetOrigin() + blinkDirection

  local origin = caster:GetAbsOrigin()


  caster:SetOrigin( blinkPosition )
  FindClearSpaceForUnit( caster, blinkPosition, true )

 

  if target:GetTeamNumber()~=caster:GetTeamNumber() then
    caster:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_buff", { duration = self.duration } )

---------------------------------------------ТАЛАНТ БЛАЙНД---------------------------------------------------------------
    if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_blind") then 
      target:EmitSound("Phantom_Assassin.Blind")
      target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_vision", {duration =  self.blind_duration * (1-target:GetStatusResistance())})
    end
----------------------------------------------------------------------------------------------------------------------------

  if caster:HasModifier("modifier_phantom_assassin_blink_legendary") then 
    self:Blind_Line(origin,caster:GetAbsOrigin())
  end
    caster:MoveToPositionAggressive(caster:GetOrigin())
  end


   



--------------------------------------------------------ТАЛАНТ ИЛЛЮЗИЯ--------------------------------------------
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_illusion") then 

  local damage = 100 - (self.illusion_damage_init + self.illusion_damage_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_illusion"))
  local incoming = (self.illusion_health_init + self.illusion_health_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_illusion"))
 

  local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {Duration = self.illusion_duration ,outgoing_damage = -damage ,incoming_damage = incoming}, 1, 1, true, true )
    for _,i in pairs(illusion) do

      i.owner = self:GetCaster()

      local effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
      if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
        effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"
      end

      local effect_cast_end = ParticleManager:CreateParticle( effect, PATTACH_WORLDORIGIN, i )
      ParticleManager:SetParticleControl( effect_cast_end, 0, i:GetOrigin() )
      ParticleManager:ReleaseParticleIndex( effect_cast_end )

      for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
        if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            i:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
        end
      end

      i:MoveToPositionAggressive(i:GetAbsOrigin())
      i:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_buff", { duration = self.duration } )
    end
end

---------------------------------------------------------------------------------------------------------------------------


  self:PlayEffects( origin )
end








function custom_phantom_assassin_phantom_strike:PlayEffects( origin )
 
  local particle_cast_start = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf"
  local particle_cast_end = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
  local sound_cast_start = "Hero_PhantomAssassin.Strike.Start"
  local sound_cast_end = "Hero_PhantomAssassin.Strike.End"

  if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
    particle_cast_start = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
    particle_cast_end = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"
  end


  local effect_cast_start = ParticleManager:CreateParticle( particle_cast_start, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast_start, 0, origin )
  ParticleManager:ReleaseParticleIndex( effect_cast_start )

  local effect_cast_end = ParticleManager:CreateParticle( particle_cast_end, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast_end, 0, self:GetCaster():GetOrigin() )
  ParticleManager:ReleaseParticleIndex( effect_cast_end )


  EmitSoundOnLocationWithCaster( origin, sound_cast_start, self:GetCaster() )
  EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast_end, self:GetCaster() )
end






modifier_phantom_assassin_phantom_strike_passive = class({})

function modifier_phantom_assassin_phantom_strike_passive:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_passive:IsPurgable() return false end





modifier_phantom_assassin_phantom_strike_buff = class({})


function modifier_phantom_assassin_phantom_strike_buff:IsHidden()
  return false
end

function modifier_phantom_assassin_phantom_strike_buff:IsDebuff()
  return false
end

function modifier_phantom_assassin_phantom_strike_buff:IsPurgable()
  return true
end



function modifier_phantom_assassin_phantom_strike_buff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS
  }
end

function modifier_phantom_assassin_phantom_strike_buff:GetModifierBonusStats_Agility()
  return self.agility
end


function modifier_phantom_assassin_phantom_strike_buff:OnCreated(table)

  self.agi_percentage = 0

  if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_damage") then 
    
   self.agi_percentage = self:GetAbility().stats_init + self:GetAbility().stats_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_damage")

  end

  if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_damage") then
    self:OnIntervalThink()
    self:StartIntervalThink(0.5)
  end

end


function modifier_phantom_assassin_phantom_strike_buff:OnIntervalThink()
if not IsServer() then return end


  self.agility  = 0
  self.agility   = self:GetParent():GetAgility() * self.agi_percentage * 0.01

  self:GetParent():CalculateStatBonus(true)

end




function modifier_phantom_assassin_phantom_strike_buff:GetModifierAttackSpeedBonus_Constant()

 return self:GetAbility():GetSpecialValueFor( "speed" )
end

function modifier_phantom_assassin_phantom_strike_buff:GetModifierMoveSpeedBonus_Percentage() return 
self:GetAbility().move_move_init + self:GetAbility().move_move_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blink_move")
 end


function modifier_phantom_assassin_phantom_strike_buff:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blink_blink") then return end
if self:GetParent() ~= params.attacker then return end


local heal = self:GetAbility().heal*self:GetParent():GetMaxHealth()

self:GetParent():Heal(heal, self:GetParent())
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

end





modifier_phantom_assassin_phantom_strike_vision = class({})


function modifier_phantom_assassin_phantom_strike_vision:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_vision:IsPurgable() return true end

function modifier_phantom_assassin_phantom_strike_vision:GetTexture() return "buffs/Phantom_Strike_blind" end

function modifier_phantom_assassin_phantom_strike_vision:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}

end
function modifier_phantom_assassin_phantom_strike_vision:GetBonusVisionPercentage() 
if self:GetParent():IsHero() then 
 return  -100  else return 0 end end
function modifier_phantom_assassin_phantom_strike_vision:GetModifierNoVisionOfAttacker() 
if self:GetParent():IsHero() then 
 return  1  
else 
  return 0
   end 
 end 


 function modifier_phantom_assassin_phantom_strike_vision:GetModifierDamageOutgoing_Percentage() 
  if self:GetParent():IsHero() then 
 return  0  
else 
  return -1*self:GetAbility().blind_damage
end

  end 

function modifier_phantom_assassin_phantom_strike_vision:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf" end
 
function modifier_phantom_assassin_phantom_strike_vision:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end





---------------------------------------ТАЛАНТ АРМОР--------------------------------------------------------



modifier_phantom_assassin_phantom_strike_slow = class({})
function modifier_phantom_assassin_phantom_strike_slow:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_slow:IsPurgable() return true end
function modifier_phantom_assassin_phantom_strike_slow:GetTexture() return "buffs/phantom_slow" end

function modifier_phantom_assassin_phantom_strike_slow:GetEffectName()
  return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_phantom_assassin_phantom_strike_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_phantom_assassin_phantom_strike_slow:GetModifierMoveSpeedBonus_Percentage()
return (self:GetAbility().move_move_init + self:GetAbility().move_move_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_move"))*-1
end




custom_phantom_assassin_phantom_strike_legendary = class({})

function custom_phantom_assassin_phantom_strike_legendary:OnSpellStart()
if not IsServer() then return end

local illusions = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

self:GetCaster():EmitSound("Phantom_Assassin.Blink_start")

for _,illusion in pairs(illusions) do
  if illusion:GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
    illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_legendary", {duration = self:GetSpecialValueFor("duration")})
  end

end


end


modifier_phantom_assassin_phantom_strike_legendary = class({})
function modifier_phantom_assassin_phantom_strike_legendary:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_legendary:IsPurgable() return false end


function modifier_phantom_assassin_phantom_strike_legendary:OnCreated(table)
if not IsServer() then return end

  self.ground_particle = ParticleManager:CreateParticle("particles/pa_blink_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
  ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

  self:AddParticle(self.ground_particle, false, false, -1, false, false)
end


function modifier_phantom_assassin_phantom_strike_legendary:DeclareFunctions()
return 
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_phantom_assassin_phantom_strike_legendary:OnAttackLanded(params)
if not IsServer() then return end

if params.target:IsBuilding() then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if params.attacker ~= self:GetParent() then return end


local random = RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("chance"),13,self:GetParent())

if not random then return end

self:GetParent():EmitSound("Phantom_Assassin.Blink_hit")

local main_ability = self:GetParent():FindAbilityByName("custom_phantom_assassin_phantom_strike")


local duration = main_ability:GetSpecialValueFor("duration") 
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_duration") then 
  local bonus = main_ability.duration_init + main_ability.duration_inc*self:GetParent():GetUpgradeStack("modifier_phantom_assassin_blink_duration")
  duration = duration  + bonus 
end
------------------------------------------------------------------------------------------------------------------------------------------

  local target =  (params.target:GetAbsOrigin() - (params.target:GetForwardVector())*150)
  local origin = self:GetParent():GetAbsOrigin()
  local caster = self:GetParent()

 
  caster:AddNewModifier(caster, main_ability, "modifier_phantom_assassin_phantom_strike_buff", { duration = duration } )

  caster:SetOrigin( target )
  FindClearSpaceForUnit( caster, target, true )
  local angel = (params.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin())
  angel.z = 0.0
  angel = angel:Normalized()
  self:GetParent():SetForwardVector(angel)
  self:GetParent():FaceTowards(params.target:GetAbsOrigin())

       
  main_ability:PlayEffects( origin )

  if self:GetParent():HasModifier("modifier_phantom_assassin_blink_move") then 
    params.target:AddNewModifier(self:GetParent(), main_ability, "modifier_phantom_assassin_phantom_strike_slow", {duration = duration*(1 - params.target:GetStatusResistance())})
  end

  if caster:HasModifier("modifier_phantom_assassin_blink_legendary") then 

    local attack = FindUnitsInLine(caster:GetTeamNumber(), origin,target, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

    for _,i in ipairs(attack) do

      local k = main_ability.legendary_damage
      if caster:IsIllusion() then 
          k = main_ability.legendary_damage_illusion
      end

      local damage = {
          victim = i,
          attacker = caster,
          damage = caster:GetAgility()*k,
          damage_type = DAMAGE_TYPE_MAGICAL,
          ability = main_ability
      }
      ApplyDamage( damage )
    end

  end



end