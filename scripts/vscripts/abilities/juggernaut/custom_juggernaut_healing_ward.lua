LinkLuaModifier("modifier_custom_juggernaut_healing_ward", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_effect", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_speed", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)

 
custom_juggernaut_healing_ward = class({})


custom_juggernaut_healing_ward.cd_init = 0
custom_juggernaut_healing_ward.cd_inc = 10

custom_juggernaut_healing_ward.heal_init = 0
custom_juggernaut_healing_ward.heal_inc = 1

custom_juggernaut_healing_ward.move_init = 0
custom_juggernaut_healing_ward.move_inc = 20

custom_juggernaut_healing_ward.return_init = 0
custom_juggernaut_healing_ward.return_inc = 0.3
custom_juggernaut_healing_ward.return_radius = 400

custom_juggernaut_healing_ward.purge_cd = 3

custom_juggernaut_healing_ward.stun_stun = 1.5
custom_juggernaut_healing_ward.stun_heal = 0.2

custom_juggernaut_healing_ward.legendary_hits = 3


function custom_juggernaut_healing_ward:GetCooldown(iLevel)
local upgrade_cooldown = 0  
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end





function custom_juggernaut_healing_ward:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")
self.radius = self:GetSpecialValueFor("radius")
if not IsServer() then return end

local wards = Entities:FindAllByModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")


for _,ward in pairs(wards) do 
  if ward:GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
    ward:ForceKill(false)
 end
end

self.ward = CreateUnitByName("juggernaut_healing_ward", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
self.ward:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self.duration})
self.ward:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)


Timers:CreateTimer(0.05, function()self.ward:MoveToNPC(self:GetCaster()) end)
self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward", {})


if self:GetCaster():HasModifier("modifier_juggernaut_healingward_move") then
  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_speed", {})
end

------------------------------------------------------------------------------------------------------------------
------------------------------------------------ТАЛАНТ УМЕНЬШЕНИЕ---------------------------------------------------
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then

  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_reduction", {})
end
-------------------------------------------------------------------------------------------------------------------------
end




modifier_custom_juggernaut_healing_ward = class({})



function modifier_custom_juggernaut_healing_ward:OnCreated(table)
if not IsServer() then return end
self.hits = self:GetAbility().legendary_hits

self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Cast")

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetAbility().radius, 1, 1))
ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "flame_attachment", self:GetParent():GetAbsOrigin(), true)
self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Loop") 
end



function modifier_custom_juggernaut_healing_ward:OnDeath( params )
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
self:Death()

if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_stun") then return end
  
self:HealOnDeath()

local duration = self:GetAbility().stun_stun *( 1 - params.attacker:GetStatusResistance())
params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = duration})

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_custom_juggernaut_healing_ward:HealOnDeath()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_stun") then return end

local heal =  self:GetAbility().stun_heal*self:GetCaster():GetMaxHealth()

self:GetCaster():Heal(heal, self:GetCaster())
self:GetCaster():EmitSound("Juggernaut.WardDeath")    

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end

function modifier_custom_juggernaut_healing_ward:Death()
if not IsServer() then return end
self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Stop")
ParticleManager:DestroyParticle(self.particle, true)
ParticleManager:ReleaseParticleIndex(self.particle)
self:GetParent():StopSound("Hero_Juggernaut.HealingWard.Loop")

end

function modifier_custom_juggernaut_healing_ward:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward:IsAura() return true end

function modifier_custom_juggernaut_healing_ward:GetAuraDuration() return 2 end

function modifier_custom_juggernaut_healing_ward:GetAuraRadius() return self:GetAbility().radius end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_aura" end

function modifier_custom_juggernaut_healing_ward:CheckState() return 
      {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
      }
end


function modifier_custom_juggernaut_healing_ward:DeclareFunctions() return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_DEATH
} 
end


    function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamageMagical() return 1 end

     function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePhysical() return 1 end

     function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePure() return 1 end

function modifier_custom_juggernaut_healing_ward:OnAttackLanded( param )
if not IsServer() then return end
if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") and not param.attacker:IsRealHero() then return end
if self:GetParent() ~= param.target then return end

if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then
  self.hits = self.hits - 1
else 
  self.hits = self.hits - self:GetAbility().legendary_hits 
end
        
self:GetParent():SetHealth(self.hits)

if self.hits <= 0 then
  self:GetParent():Kill(nil, param.attacker)
end



end


modifier_custom_juggernaut_healing_ward_aura = class({})

function modifier_custom_juggernaut_healing_ward_aura:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward_aura:DeclareFunctions()
return 
  {
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
end 

function modifier_custom_juggernaut_healing_ward_aura:GetModifierMoveSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_move") then 
  bonus = self:GetAbility().move_init + self:GetAbility().move_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_move")
end
return bonus
end

function modifier_custom_juggernaut_healing_ward_aura:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if self:GetParent() ~= params.unit then return end 
if params.attacker:IsBuilding() then return end

self:GetParent():EmitSound("Juggernaut.WardDamage")
  
local rdamage = self:GetAbility().return_init + self:GetAbility().return_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_return")


ApplyDamage({victim = params.attacker, attacker = self:GetParent(), damage = params.original_damage*rdamage, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self:GetAbility()})
            
    

end


function modifier_custom_juggernaut_healing_ward_aura:OnCreated(table)
  self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen") 

  if self:GetCaster():HasModifier("modifier_juggernaut_healingward_heal") then 
    self.health_regen = self.health_regen + self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_heal")
  end


if not IsServer() then return end
  if (self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_purge")) then

    self:StartIntervalThink(self:GetAbility().purge_cd)
    self:OnIntervalThink()
  end


end

function modifier_custom_juggernaut_healing_ward_aura:OnIntervalThink()
  if not IsServer() then return end
  self:GetParent():Purge(false, true, false, true, false)

 local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
            ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_custom_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage() return self.health_regen end




modifier_custom_juggernaut_healing_ward_reduction = class({})

function modifier_custom_juggernaut_healing_ward_reduction:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward_reduction:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward_reduction:IsAura() return true end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraDuration() return 0.1 end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraRadius() return self:GetAbility().radius end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward_reduction:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_reduction_aura" end





modifier_custom_juggernaut_healing_ward_reduction_aura = class({})



function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectName() return "particles/jugger_ward_legend.vpcf" end



function modifier_custom_juggernaut_healing_ward_reduction_aura:IsPurgable() return false end


function modifier_custom_juggernaut_healing_ward_reduction_aura:IsHidden() return true end


function modifier_custom_juggernaut_healing_ward_reduction_aura:DeclareFunctions() 
  return 
  {
    MODIFIER_PROPERTY_MIN_HEALTH
  }
end


function modifier_custom_juggernaut_healing_ward_reduction_aura:GetMinHealth()
if not self:GetCaster():HasModifier("modifier_death") then 
 return 1 
else 
 return 0
end
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end




modifier_custom_juggernaut_healing_ward_speed = class({})

function modifier_custom_juggernaut_healing_ward_speed:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_speed:IsHidden() return false end

function modifier_custom_juggernaut_healing_ward_speed:DeclareFunctions()
return 
  {

    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
  }
end 

function modifier_custom_juggernaut_healing_ward_speed:GetModifierMoveSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_move") then 
  bonus = self:GetAbility().move_init + self:GetAbility().move_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_move")
end
return bonus
end




