LinkLuaModifier("modifier_void_spirit_resonant_pulse", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_ring_lua", "util/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_void_spirit_resonant_pulse_aura", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_pulse_aura_damage", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_pulse_silence", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_invun", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_pulse_slow", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_resonant_pulse_custom = class({})

void_spirit_resonant_pulse_custom.mana_init = 50
void_spirit_resonant_pulse_custom.mana_inc = 50

void_spirit_resonant_pulse_custom.incoming = {-6, -9, -12}

void_spirit_resonant_pulse_custom.legendary_duration = 1

void_spirit_resonant_pulse_custom.burn_radius = 300
void_spirit_resonant_pulse_custom.burn_mana = {0.01, 0.02}
void_spirit_resonant_pulse_custom.burn_mana_base = 10
void_spirit_resonant_pulse_custom.burn_interval = 1
void_spirit_resonant_pulse_custom.burn_mana_k = 2

void_spirit_resonant_pulse_custom.health_shield = 0.15
void_spirit_resonant_pulse_custom.health_lifesteal = 0.2
void_spirit_resonant_pulse_custom.health_lifesteal_creeps = 0.33

void_spirit_resonant_pulse_custom.auto_slow = -80
void_spirit_resonant_pulse_custom.auto_slow_duration = 1

void_spirit_resonant_pulse_custom.damage = {40,80,120}


void_spirit_resonant_pulse_2_custom = class({})






function void_spirit_resonant_pulse_custom:OnSpellStart()
self:Cast(self:GetCaster())
end


function void_spirit_resonant_pulse_2_custom:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("void_spirit_resonant_pulse_custom")
ability:Cast(self:GetCaster())
end



function void_spirit_resonant_pulse_2_custom:OnUpgrade()
	self:GetCaster():FindAbilityByName("void_spirit_resonant_pulse_custom"):SetLevel(self:GetLevel())
end








function void_spirit_resonant_pulse_custom:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end


function void_spirit_resonant_pulse_custom:OnInventoryContentsChanged()
if self:GetCaster():HasScepter() and not  self:IsHidden() then
	self:SetHidden(true)
	self:GetCaster():SwapAbilities("void_spirit_resonant_pulse_custom", "void_spirit_resonant_pulse_2_custom", false, true)

	local ab = self:GetCaster():FindAbilityByName("void_spirit_resonant_pulse_2_custom")
	ab:SetHidden(false)

	ab:SetLevel(self:GetLevel())

	if self:GetCooldownTimeRemaining() > 0 then 
		ab:SetCurrentAbilityCharges(0)
	end

end

if not self:GetCaster():HasScepter() and self:IsHidden() then
	self:SetHidden(false)
	self:UseResources(false, false, true)
	self:GetCaster():SwapAbilities("void_spirit_resonant_pulse_2_custom", "void_spirit_resonant_pulse_custom", false, true)

	local ab = self:GetCaster():FindAbilityByName("void_spirit_resonant_pulse_2_custom")
	ab:SetHidden(true)

	ab:SetLevel(self:GetLevel())

end


end


function void_spirit_resonant_pulse_custom:Cast(caster)

local duration = self:GetSpecialValueFor( "buff_duration" )


self.base_absorb = self:GetSpecialValueFor( "base_absorb_amount" )

if caster:HasModifier("modifier_void_pulse_1") then 
	self.base_absorb = self.base_absorb + self.mana_init + self.mana_inc*caster:GetUpgradeStack("modifier_void_pulse_1")
end

if caster:HasModifier("modifier_void_pulse_6") then 
	self.base_absorb = self.base_absorb + (caster:GetMaxHealth() - caster:GetHealth())*self.health_shield
end

local mod = caster:FindModifierByName("modifier_void_spirit_resonant_pulse")

if not mod then 
	mod = caster:AddNewModifier(caster, self, "modifier_void_spirit_resonant_pulse", { duration = duration })
end

mod:CreateWave(caster)

self:AbsorbShield(caster, self.base_absorb)

	--local cd = 	(self:GetSpecialValueFor( "radius" ) + 90)/self:GetSpecialValueFor( "speed" )
	--self:StartCooldown(cd)
end


function void_spirit_resonant_pulse_custom:AbsorbShield(caster,shield)
if not IsServer() then return end
local mod = caster:FindModifierByName("modifier_void_spirit_resonant_pulse")
if not mod then return end

mod.shield = mod.shield + shield
mod:SetStackCount(mod.shield)

end






modifier_void_spirit_resonant_pulse = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_resonant_pulse:IsHidden()
	return false
end

function modifier_void_spirit_resonant_pulse:IsDebuff()
	return false
end

function modifier_void_spirit_resonant_pulse:IsPurgable()
	return true
end

function modifier_void_spirit_resonant_pulse:CreateWave(caster)


self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + 90
self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.return_speed = self:GetAbility():GetSpecialValueFor( "return_projectile_speed" )

if self:GetParent():HasModifier("modifier_void_pulse_3") then 
	self.damage = self.damage + self:GetAbility().damage[self:GetParent():GetUpgradeStack("modifier_void_pulse_3")]
end

if not IsServer() then return end

self.damageTable = {attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()}

self.info = {Target = caster, Ability = self:GetAbility(), EffectName = "", iMoveSpeed = self.return_speed, bDodgeable = false, iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}

local pulse = caster:AddNewModifier(
		caster, 
		self:GetAbility(), 
		"modifier_generic_ring_lua",
		{
			end_radius = self.radius,
			speed = self.speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} 
	)

pulse:SetCallback( function( enemy )

	self.damageTable.victim = enemy
	ApplyDamage(self.damageTable)

	if pulse:GetCaster():HasScepter() then 
		enemy:AddNewModifier(pulse:GetCaster(), pulse:GetAbility(), "modifier_void_spirit_resonant_pulse_silence", {duration = (1 - enemy:GetStatusResistance())*pulse:GetAbility():GetSpecialValueFor("scepter_silence")})
	end

	if pulse:GetCaster():HasModifier("modifier_void_pulse_5") then 
		enemy:AddNewModifier(pulse:GetCaster(), pulse:GetAbility(), "modifier_void_spirit_resonant_pulse_slow", {duration = (1 - enemy:GetStatusResistance())*pulse:GetAbility().auto_slow_duration})
	
	end

	if pulse:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 

		self:PlayEffects3( enemy )

		if not enemy:IsHero() then return end

		self.info.Source = enemy
		ProjectileManager:CreateTrackingProjectile(self.info)

		self:PlayEffects4( pulse:GetCaster(), enemy )
	end

end)

self:PlayEffects1()
end



function modifier_void_spirit_resonant_pulse:OnCreated( kv )
if not IsServer() then return end
self.shield = 0
self.RemoveForDuel = true
self:PlayEffects2()


end



function modifier_void_spirit_resonant_pulse:OnDestroy()
	if not IsServer() then return end
	local sound_destroy = "Hero_VoidSpirit.Pulse.Destroy"
	self:GetParent():EmitSound(sound_destroy)

	if self:GetParent():HasModifier("modifier_void_pulse_legendary") and self:GetRemainingTime() > 0.1 then
		self:GetParent():EmitSound("VoidSpirit.Shield_legendary")
		self:GetParent():Purge(false, true, false, true, false)


		local effect_cast = ParticleManager:CreateParticle( "particles/void_shield_legen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(),  true )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_resonant_invun", {duration = self:GetAbility().legendary_duration})	
	end


	if self:GetParent():HasModifier("modifier_void_pulse_5") then 
		self:CreateWave(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_resonant_pulse:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end



function modifier_void_spirit_resonant_pulse:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_pulse_6") then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit then return end
if params.unit == self:GetParent() then return end

local heal = params.damage * self:GetAbility().health_lifesteal

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().health_lifesteal_creeps
end


self:GetParent():Heal(heal, self:GetAbility())

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
local particle = ParticleManager:CreateParticle( "particles/am_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )


end





function modifier_void_spirit_resonant_pulse:GetModifierIncomingDamage_Percentage()
local bonus = 0

if self:GetParent():HasModifier("modifier_void_pulse_2") then
	bonus = self:GetAbility().incoming[self:GetParent():GetUpgradeStack("modifier_void_pulse_2")]
end

return bonus
end


function modifier_void_spirit_resonant_pulse:GetModifierIncomingPhysicalDamageConstant( params )
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_void_pulse_legendary") then return end

  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end

	self:PlayEffects5()

	if params.damage>=self.shield then
		self:Destroy()
		return -self.shield
	else
		self.shield = self.shield-params.damage
		self:SetStackCount(self.shield)
		return -params.damage
	end
end

function modifier_void_spirit_resonant_pulse:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_pulse_legendary") then return end


if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

	self:PlayEffects5()

	if params.damage>=self.shield then
		self:Destroy()
		return self.shield
	else
		self.shield = self.shield-params.damage
		self:SetStackCount(self.shield)
		return params.damage
	end

end






--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_resonant_pulse:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_void_spirit_resonant_pulse:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_void_spirit_resonant_pulse:PlayEffects1()

if not self then return end
	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse"

	-- adjustment
	local radius = self.radius * 2

	-- Create Particle

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )

	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end

function modifier_void_spirit_resonant_pulse:PlayEffects2()

if not self then return end
	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Cast"

	-- Get Data
	local radius = 130

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end


function modifier_void_spirit_resonant_pulse:PlayEffects3( target )
if not self then return end


	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	target:EmitSound(sound_cast)
end

function modifier_void_spirit_resonant_pulse:PlayEffects4( parent, target )
if not self then return end

	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0),  true )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true  )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_void_spirit_resonant_pulse:PlayEffects5()
if not self then return end
	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf"

	-- Get Data
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end





modifier_void_spirit_resonant_pulse_aura = class({})

function modifier_void_spirit_resonant_pulse_aura:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_aura:IsPurgable() return false end
function modifier_void_spirit_resonant_pulse_aura:IsDebuff() return false end
function modifier_void_spirit_resonant_pulse_aura:GetTexture() return "buffs/shield_burn" end
function modifier_void_spirit_resonant_pulse_aura:RemoveOnDeath() return false end



function modifier_void_spirit_resonant_pulse_aura:GetAuraRadius()
	return self:GetAbility().burn_radius
end

function modifier_void_spirit_resonant_pulse_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_void_spirit_resonant_pulse_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_void_spirit_resonant_pulse_aura:GetModifierAura()
	return "modifier_void_spirit_resonant_pulse_aura_damage"
end

function modifier_void_spirit_resonant_pulse_aura:IsAura()
	return true
end

function modifier_void_spirit_resonant_pulse_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_void_spirit_resonant_pulse_aura:OnTooltip()
local k = 1
if self:GetParent():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self:GetAbility().burn_mana_k 
end

return (self:GetCaster():GetMaxMana()*self:GetAbility().burn_mana[self:GetCaster():GetUpgradeStack("modifier_void_pulse_4")] + self:GetAbility().burn_mana_base)*k
end

modifier_void_spirit_resonant_pulse_aura_damage = class({})
function modifier_void_spirit_resonant_pulse_aura_damage:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_aura_damage:IsPurgable() return false end
function modifier_void_spirit_resonant_pulse_aura_damage:GetTexture() return "buffs/shield_burn" end

function modifier_void_spirit_resonant_pulse_aura_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().burn_interval)

end

function modifier_void_spirit_resonant_pulse_aura_damage:OnIntervalThink()
if not IsServer() then return end


local k = 1
if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self:GetAbility().burn_mana_k 
end

self.damage =  (self:GetAbility().burn_interval*self:GetCaster():GetMaxMana()*self:GetAbility().burn_mana[self:GetCaster():GetUpgradeStack("modifier_void_pulse_4")]+ self:GetAbility().burn_mana_base)*k 


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end




function modifier_void_spirit_resonant_pulse_aura_damage:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf"
end

function modifier_void_spirit_resonant_pulse_aura_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_void_spirit_resonant_pulse_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_void_spirit_resonant_pulse_aura_damage:OnTooltip()

local k = 1
if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self:GetAbility().burn_mana_k 
end

return self:GetCaster():GetMaxMana()*self:GetAbility().burn_mana[self:GetCaster():GetUpgradeStack("modifier_void_pulse_4")]*k
end

modifier_void_spirit_resonant_pulse_silence = class({})

function modifier_void_spirit_resonant_pulse_silence:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_silence:IsPurgable() return true end
function modifier_void_spirit_resonant_pulse_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end
function modifier_void_spirit_resonant_pulse_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_void_spirit_resonant_pulse_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end







modifier_void_spirit_resonant_invun = class({})
function modifier_void_spirit_resonant_invun:IsHidden() return false end
function modifier_void_spirit_resonant_invun:IsPurgable() return false end
function modifier_void_spirit_resonant_invun:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end

function modifier_void_spirit_resonant_invun:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_void_spirit_resonant_invun:StatusEffectPriority()
	return 99999
end



modifier_void_spirit_resonant_pulse_slow = class({})
function modifier_void_spirit_resonant_pulse_slow:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_slow:IsPurgable() return true end
function modifier_void_spirit_resonant_pulse_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end






function modifier_void_spirit_resonant_pulse_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end

function modifier_void_spirit_resonant_pulse_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().auto_slow
end
