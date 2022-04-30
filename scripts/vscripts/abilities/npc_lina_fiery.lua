LinkLuaModifier("modifier_lina_fiery_thinker", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_aura", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_heal", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_slow", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina_fiery_cd", "abilities/npc_lina_fiery", LUA_MODIFIER_MOTION_NONE)

npc_lina_fiery = class({})
function npc_lina_fiery:GetIntrinsicModifierName() return "modifier_lina_fiery_heal" end 

modifier_lina_fiery_heal = class({})

function modifier_lina_fiery_heal:IsHidden() return true end

function modifier_lina_fiery_heal:IsPurgable() return false end

function modifier_lina_fiery_heal:DeclareFunctions()
return	
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_DEATH
}

end

function modifier_lina_fiery_heal:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
local unit = self:GetParent()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_death.vpcf", PATTACH_CUSTOMORIGIN, unit)
 ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
Timers:CreateTimer(2.17,function()

  unit:AddNoDraw()
end)

end


function modifier_lina_fiery_heal:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if params.inflictor == nil then return end
if not params.unit:IsRealHero() then return end

local heal = params.damage*self:GetAbility():GetSpecialValueFor("heal")/100
local caster = self:GetCaster()

caster:Heal(heal, caster)


local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(caster, 10, caster, heal, nil)
end




modifier_lina_fiery_thinker = class({})

function modifier_lina_fiery_thinker:IsHidden() return true end

function modifier_lina_fiery_thinker:IsPurgable() return false end

function modifier_lina_fiery_thinker:IsAura() return true end

function modifier_lina_fiery_thinker:GetAuraDuration() return 0.1 end
function modifier_lina_fiery_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_lina_fiery_thinker:GetAuraRadius() return 150
 end
function modifier_lina_fiery_thinker:OnCreated(table)
if not IsServer() then return end

self.nFXIndex = ParticleManager:CreateParticle("particles/lina_fire.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(150, 0, 0))
        ParticleManager:ReleaseParticleIndex(self.nFXIndex)


end

function modifier_lina_fiery_thinker:OnDestroy()
if not IsServer() then return end
 ParticleManager:DestroyParticle(self.nFXIndex, false )
 ParticleManager:ReleaseParticleIndex(self.nFXIndex)

end

function modifier_lina_fiery_thinker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_lina_fiery_thinker:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetCaster() then return end
	self:Destroy()
end

function modifier_lina_fiery_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_lina_fiery_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_lina_fiery_thinker:GetModifierAura() return "modifier_lina_fiery_aura" end



modifier_lina_fiery_aura = class({})

function modifier_lina_fiery_aura:IsPurgable() return false end

function modifier_lina_fiery_aura:IsHidden() return false end 
function modifier_lina_fiery_aura:IsDebuff() return true end

function modifier_lina_fiery_aura:OnCreated(table)
if not IsServer() then return end

self:SetHasCustomTransmitterData(true)

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.slow = -1*self:GetAbility():GetSpecialValueFor("slow")

self.tick = 0.33


self.damage = self.damage * self.tick
self:StartIntervalThink(self.tick)

end

function modifier_lina_fiery_aura:OnIntervalThink()
if not IsServer() then return end
local damage = self:GetParent():GetMaxHealth()*self.damage/100

ApplyDamage({victim = self:GetParent(), attacker = self:GetAbility():GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)

end

function modifier_lina_fiery_aura:AddCustomTransmitterData() return {
slow = self.slow
} end

function modifier_lina_fiery_aura:HandleCustomTransmitterData(data)
self.slow = data.slow
end

function modifier_lina_fiery_aura:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
  

function modifier_lina_fiery_aura:GetModifierMoveSpeedBonus_Percentage() return self.slow end

