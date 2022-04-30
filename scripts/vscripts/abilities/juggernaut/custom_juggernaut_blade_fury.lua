LinkLuaModifier("modifier_custom_juggernaut_blade_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_silence", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_agility", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_shard_damage", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_passive", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_passive_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_agility_count", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_agility_stack", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)


custom_juggernaut_blade_fury = class({})

custom_juggernaut_blade_fury.cd_init = -1
custom_juggernaut_blade_fury.cd_inc = -1

custom_juggernaut_blade_fury.heal_agility = 0.3
custom_juggernaut_blade_fury.heal_armor = 8

custom_juggernaut_blade_fury.legendary_damage = 0.7
custom_juggernaut_blade_fury.legendary_duration = 1

custom_juggernaut_blade_fury.kill_agility_init = 1
custom_juggernaut_blade_fury.kill_agility_inc = 1
custom_juggernaut_blade_fury.perma_agility = 4
custom_juggernaut_blade_fury.agility_duration = 12

custom_juggernaut_blade_fury.silence_duration = 5

custom_juggernaut_blade_fury.damage_init = 0
custom_juggernaut_blade_fury.damage_inc = 20

custom_juggernaut_blade_fury.passive_duration = 1
custom_juggernaut_blade_fury.passive_chance_init = 5
custom_juggernaut_blade_fury.passive_chance_inc = 5



function custom_juggernaut_blade_fury:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_duration") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_duration")
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function custom_juggernaut_blade_fury:GetIntrinsicModifierName() return "modifier_custom_juggernaut_blade_fury_passive" end
 


function custom_juggernaut_blade_fury:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")
    if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_legendary") then 
      self.duration = self.duration + self.legendary_duration
    end

    if not IsServer() then return end

    if self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury") then 
        self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")
    end

    if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_silence") then 
        local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for _,i in pairs(targets) do 
          i:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_silence", {duration = (1 - i:GetStatusResistance())*self.silence_duration})
        end
    end



    self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury", {duration = self.duration, anim = 1})
    self:GetCaster():Purge(false, true, false, false, false)
   
    self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
    if self.omni then  self.omni:SetActivated(false) end 
    self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
    if self.swift then self.swift:SetActivated(false) end 

end



modifier_custom_juggernaut_blade_fury = class({})

function modifier_custom_juggernaut_blade_fury:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury:DeclareFunctions()

return
{

MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
MODIFIER_EVENT_ON_DEATH,
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
MODIFIER_PROPERTY_TOOLTIP,
MODIFIER_EVENT_ON_ATTACK_LANDED
}  

end

function modifier_custom_juggernaut_blade_fury:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_bladefury_agility") then return end
if params.target:IsBuilding() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_agility_count", {duration = self:GetAbility().agility_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_agility_stack", {duration = self:GetAbility().agility_duration})
end



function modifier_custom_juggernaut_blade_fury:GetModifierConstantHealthRegen()
local bonus = 0
if self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then 
  bonus = self:GetParent():GetAgility()*self:GetAbility().heal_agility
end
return bonus
end

function modifier_custom_juggernaut_blade_fury:GetModifierPhysicalArmorBonus()
local bonus = 0
if self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then 
  bonus = self:GetAbility().heal_armor
end
return bonus
end


function modifier_custom_juggernaut_blade_fury:OnTooltip()
return self.damage/self.tick

end




function modifier_custom_juggernaut_blade_fury:OnDeath( params )
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end 
if not params.unit:IsRealHero() then return end 

 
if self:GetParent():FindModifierByName("modifier_juggernaut_bladefury_agility") then

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_agility", {})
  local life_time = 3.0
  local digits = string.len( math.floor( 20 ) ) + 1

  local amount = self:GetAbility().perma_agility

  local numParticle = ParticleManager:CreateParticle( "particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( numParticle, 1, Vector( 10, amount, 4 ) )
  ParticleManager:SetParticleControl( numParticle, 2, Vector( life_time, digits, 0 ) )
  ParticleManager:SetParticleControl( numParticle, 3, Vector( 14, 197, 15 ) )

  local effect_cast = ParticleManager:CreateParticle( "particles/jugger_up.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex( effect_cast )
        
        
end



end

function modifier_custom_juggernaut_blade_fury:GetModifierMoveSpeedBonus_Constant()
if self:GetParent():HasShard() then 
 return 100 
end
end


function modifier_custom_juggernaut_blade_fury:GetModifierProcAttack_BonusDamage_Physical( params ) 
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then return end 
if params.target:IsBuilding() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_shard_damage") then return -params.damage*0.25 end

return -params.damage

end

function modifier_custom_juggernaut_blade_fury:OnCreated(table)
self.RemoveForDuel = true

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.tick = 0.2
self.count = 5
self:StartIntervalThink(self.tick)

self.anim = table.anim
self:PlayEffects(self.anim)




if not IsServer() then return end

if self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then
  
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


end

function modifier_custom_juggernaut_blade_fury:CheckState()
if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then
 return {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
end
end

function modifier_custom_juggernaut_blade_fury:OnIntervalThink()

local damage = 0
local bonus = 0
local agility = 0
if self:GetParent():HasModifier("modifier_juggernaut_bladefury_legendary") then 
    agility = self:GetParent():GetAgility()*self:GetAbility().legendary_damage
end

if self:GetParent():HasModifier("modifier_juggernaut_bladefury_damage") then 
  bonus = (self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladefury_damage"))
end

self.damage = (self:GetAbility():GetSpecialValueFor("damage") + agility + bonus)*self.tick


if not IsServer() then return end

local targets = nil 
targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)


if self:GetParent():HasShard() and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then

  if self.count == 5  then 
    local shard_targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

    if #shard_targets > 0 then 
    
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_shard_damage", {})
      local random = RandomInt(1, #shard_targets)
      self:GetParent():PerformAttack(shard_targets[random],true,true,true,false,false,false,false)
      self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_shard_damage")
      self.count = 0
    end

  else

self.count = self.count + 1
end


end

for _,i in ipairs(targets) do

  ApplyDamage({victim = i, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
      

  self:PlayEffects2( i )

end

end




function modifier_custom_juggernaut_blade_fury:OnDestroy( kv )
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then 
  self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_passive_fury") 
end
self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
if self.omni then  self.omni:SetActivated(true) end 
self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
if self.swift then self.swift:SetActivated(true) end 



StopSoundOn( "Hero_Juggernaut.BladeFuryStart", self:GetParent() )
self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
end



function modifier_custom_juggernaut_blade_fury:PlayEffects()
if not IsServer() then return end

local r = 1
local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"
if self.anim == 0 then 
    r = 1.3
    particle_cast = "particles/jugg_small_fury.vpcf"
end


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius/r, 0, 0 ) )


self:AddParticle(effect_cast,false,false,-1,false,false)
 self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
end



function modifier_custom_juggernaut_blade_fury:PlayEffects2( target )
if not IsServer() then return end
    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_custom_juggernaut_blade_fury_silence = class({})

function modifier_custom_juggernaut_blade_fury_silence:IsHidden() return false end

function modifier_custom_juggernaut_blade_fury_silence:IsPurgable() return true end

function modifier_custom_juggernaut_blade_fury_silence:GetTexture() return "silencer_last_word" end

function modifier_custom_juggernaut_blade_fury_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_custom_juggernaut_blade_fury_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_juggernaut_blade_fury_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end



modifier_custom_juggernaut_blade_fury_agility = class({})

function modifier_custom_juggernaut_blade_fury_agility:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury_agility:IsHidden() return false end

function modifier_custom_juggernaut_blade_fury_agility:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_TOOLTIP,
}
end


function modifier_custom_juggernaut_blade_fury_agility:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_custom_juggernaut_blade_fury_agility:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_custom_juggernaut_blade_fury_agility:GetModifierBonusStats_Agility() 
return self:GetStackCount()*(self:GetAbility().perma_agility)
end


function modifier_custom_juggernaut_blade_fury_agility:RemoveOnDeath() return false end

function modifier_custom_juggernaut_blade_fury_agility:OnTooltip()
return self:GetStackCount()
end




modifier_custom_juggernaut_blade_fury_shard_damage = class({})

function modifier_custom_juggernaut_blade_fury_shard_damage:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_shard_damage:IsPurgable() return false end



modifier_custom_juggernaut_blade_fury_passive = class({})

function modifier_custom_juggernaut_blade_fury_passive:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_passive:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_passive:DeclareFunctions()
return 
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_juggernaut_blade_fury_passive:OnAttackLanded(params)
if not IsServer() or self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") 
or not self:GetParent():HasModifier("modifier_juggernaut_bladefury_chance") then return end
if self:GetParent() ~= params.attacker then return end
local chance = self:GetAbility().passive_chance_init + self:GetAbility().passive_chance_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladefury_chance")
  

local random = RollPseudoRandomPercentage(chance,74,self:GetParent())
if not random then return end
 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_passive_fury", {})
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury", {duration = self:GetAbility().passive_duration, anim = 0})

end



modifier_custom_juggernaut_blade_fury_passive_fury = class({})
function modifier_custom_juggernaut_blade_fury_passive_fury:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_passive_fury:IsPurgable() return false end





modifier_custom_juggernaut_blade_fury_agility_stack = class({})
function modifier_custom_juggernaut_blade_fury_agility_stack:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_agility_stack:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_agility_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_juggernaut_blade_fury_agility_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_custom_juggernaut_blade_fury_agility_stack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_fury_agility_count")

if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


end

modifier_custom_juggernaut_blade_fury_agility_count = class({})
function modifier_custom_juggernaut_blade_fury_agility_count:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_agility_count:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_agility_count:GetTexture() return "buffs/bladefury_agility" end
function modifier_custom_juggernaut_blade_fury_agility_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:GetParent():CalculateStatBonus(true)
end

function modifier_custom_juggernaut_blade_fury_agility_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
self:GetParent():CalculateStatBonus(true)
end

function modifier_custom_juggernaut_blade_fury_agility_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}

end

function modifier_custom_juggernaut_blade_fury_agility_count:GetModifierBonusStats_Agility()
return self:GetStackCount()*(self:GetAbility().kill_agility_init + self:GetAbility().kill_agility_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_bladefury_agility"))
end