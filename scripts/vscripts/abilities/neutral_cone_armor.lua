LinkLuaModifier("modifier_neutral_cone_buff", "abilities/neutral_cone_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_neutral_cone_armor", "abilities/neutral_cone_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_neutral_cone_armor_cd", "abilities/neutral_cone_armor", LUA_MODIFIER_MOTION_NONE)




neutral_cone_armor = class({})

function neutral_cone_armor:GetIntrinsicModifierName() return "modifier_neutral_cone_armor" end 



modifier_neutral_cone_armor = class({})

function modifier_neutral_cone_armor:IsPurgable() return false end

function modifier_neutral_cone_armor:IsHidden() return true end

function modifier_neutral_cone_armor:OnCreated(table)
if not IsServer() then return end
self.cd = self:GetAbility():GetSpecialValueFor("cd")
self.health = self:GetAbility():GetSpecialValueFor("health")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
self.damage = self:GetAbility():GetSpecialValueFor("damage")/100
self:StartIntervalThink(FrameTime())
end


function modifier_neutral_cone_armor:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_neutral_cone_armor:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

if self:GetParent():HasModifier("modifier_neutral_cone_buff") and params.attacker ~= nil then 

  local attacker = params.attacker

  if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
 
  damage = params.original_damage * self.damage
  ApplyDamage({ victim = attacker, attacker = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = params.damage_type, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION})
     
  EmitSoundOnEntityForPlayer("DOTA_Item.BladeMail.Damage", attacker, attacker:GetPlayerOwnerID())
end


if self:GetParent():GetHealthPercent() > self.health then return end
if self:GetParent():HasModifier("modifier_neutral_cone_armor_cd") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cone_armor_cd", {duration = self.cd})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_neutral_cone_buff", {duration = self.duration})

end






modifier_neutral_cone_buff = class({})
function modifier_neutral_cone_buff:IsHidden() return false end
function modifier_neutral_cone_buff:IsPurgable() return true end

function modifier_neutral_cone_buff:OnCreated(table)
  self.reduce = self:GetAbility():GetSpecialValueFor("reduce")
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

function modifier_neutral_cone_buff:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end
function modifier_neutral_cone_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_neutral_cone_buff:GetModifierIncomingDamage_Percentage()
return self.reduce
end





modifier_neutral_cone_armor_cd = class({})

function modifier_neutral_cone_armor_cd:IsPurgable() return false end

function modifier_neutral_cone_armor_cd:IsHidden() return false end



