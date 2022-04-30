LinkLuaModifier("modifier_void_spirit_astral_step", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_legendary_illusion", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_speed", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_attack", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_tracker", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_astral_step_charge_cd", "abilities/void_spirit/void_spirit_astral_step_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_astral_step_custom = class({})

void_spirit_astral_step_custom.crit_init = 100
void_spirit_astral_step_custom.crit_inc = 30

void_spirit_astral_step_custom.speed_init = 0
void_spirit_astral_step_custom.speed_inc = 10
void_spirit_astral_step_custom.range_init = 50
void_spirit_astral_step_custom.range_inc = 50
void_spirit_astral_step_custom.speed_duration = 3

void_spirit_astral_step_custom.lowhp_init = 0.02
void_spirit_astral_step_custom.lowhp_inc = 0.02

void_spirit_astral_step_custom.passive_chance = 18

void_spirit_astral_step_custom.charge_heal = 0.15
void_spirit_astral_step_custom.charge_cd = 30
void_spirit_astral_step_custom.charge_health = 30



void_spirit_astral_step_custom_1 = class({})
void_spirit_astral_step_custom_1.range_init = 50
void_spirit_astral_step_custom_1.range_inc = 50

void_spirit_astral_step_custom_2 = class({})
void_spirit_astral_step_custom_2.range_init = 50
void_spirit_astral_step_custom_2.range_inc = 50

void_spirit_astral_step_custom_3 = class({})
void_spirit_astral_step_custom_3.range_init = 50
void_spirit_astral_step_custom_3.range_inc = 50



function void_spirit_astral_step_custom:OnSpellStart()
	self:CastSpell(self:GetCaster(), self:GetCursorPosition())
end

function void_spirit_astral_step_custom:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
if self:GetCaster():HasModifier("modifier_void_step_3") then 
	max_dist = max_dist + self.range_init + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_3")
end
if IsClient() then 
	return max_dist 
end
return
end


function void_spirit_astral_step_custom_1:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
if self:GetCaster():HasModifier("modifier_void_step_3") then 
	max_dist = max_dist + self.range_init + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_3")
end
if IsClient() then 
	return max_dist 
end
return
end
function void_spirit_astral_step_custom_2:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
if self:GetCaster():HasModifier("modifier_void_step_3") then 
	max_dist = max_dist + self.range_init + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_3")
end
if IsClient() then 
	return max_dist 
end
return
end
function void_spirit_astral_step_custom_3:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "max_travel_distance" )
if self:GetCaster():HasModifier("modifier_void_step_3") then 
	max_dist = max_dist + self.range_init + self.range_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_3")
end
if IsClient() then 
	return max_dist 
end
return
end

function void_spirit_astral_step_custom_1:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")

	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end



function void_spirit_astral_step_custom_2:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")
	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end


function void_spirit_astral_step_custom_3:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")
	ability:CastSpell(self:GetCaster(), self:GetCursorPosition())
end




function void_spirit_astral_step_custom_1:OnUpgrade()
	self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom"):SetLevel(self:GetLevel())
end


function void_spirit_astral_step_custom_2:OnUpgrade()
	self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom"):SetLevel(self:GetLevel())
end

function void_spirit_astral_step_custom_3:OnUpgrade()
	self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom"):SetLevel(self:GetLevel())
end




function void_spirit_astral_step_custom:GetIntrinsicModifierName() return
"modifier_void_spirit_astral_step_tracker"
end



function void_spirit_astral_step_custom:CastSpell(caster, point)

local origin = caster:GetOrigin()

	local mod = caster:FindModifierByName("modifier_void_spirit_astral_replicant")
	if mod then 
		mod:IncrementStackCount()


		local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
		outgoing_damage = 0,
		duration		= mod:GetRemainingTime()		
		}, 1, 0, false, false)

		for _,illusion in pairs(illusion_self) do
			illusion.owner = caster

			mod.targetsx[mod:GetStackCount()] = caster:GetAbsOrigin().x
			mod.targetsy[mod:GetStackCount()] = caster:GetAbsOrigin().y
			mod.targetsz[mod:GetStackCount()] = caster:GetAbsOrigin().z
			illusion:AddNewModifier(illusion, self, "modifier_void_spirit_legendary_illusion", {})
		end
	end

local max_dist = self:GetSpecialValueFor( "max_travel_distance" )

if caster:HasModifier("modifier_void_step_3") then 
	max_dist = max_dist + self.range_init + self.range_inc*caster:GetUpgradeStack("modifier_void_step_3")
end

self:Strike(caster,origin,point, max_dist)

end



function void_spirit_astral_step_custom:Strike(caster,origin,point,max_dist)

	local min_dist = self:GetSpecialValueFor( "min_travel_distance" )
	local radius = self:GetSpecialValueFor( "radius" )
	local delay = self:GetSpecialValueFor( "pop_damage_delay" )

	local direction = (point-origin)

	local dist = math.max( math.min( max_dist + caster:GetCastRangeBonus(), direction:Length2D() ), min_dist )

	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )

	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"

	self:GetCaster():EmitSound(sound_start)


	FindClearSpaceForUnit( caster, target, true )


	self:GetCaster():EmitSound(sound_end)

	if caster:HasModifier("modifier_void_step_6") then 

		local heal = self.charge_heal*caster:GetMaxHealth()


		local trail_pfx = ParticleManager:CreateParticle("particles/void_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
 		ParticleManager:ReleaseParticleIndex(trail_pfx)

 		caster:Heal(heal, caster)
 		SendOverheadEventMessage(caster, 10, caster, heal, nil)
	end



	-- find units in line
	local enemies = FindUnitsInLine(
		caster:GetTeamNumber(),	-- int, your team number
		origin,	-- point, start point
		target,	-- point, end point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	-- int, flag filter
	)

	local attack_mod = caster:AddNewModifier(caster, self, "modifier_void_spirit_astral_step_attack", {})
	local no_cleave = caster:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_caster", {})

	for _,enemy in pairs(enemies) do
		-- perform attack
		caster:PerformAttack( enemy, true, true, true, false, true, false, true )

		-- add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_void_spirit_astral_step", -- modifier name
			{ duration = delay } -- kv
		)

		-- play effects
		self:PlayEffects2( enemy )
	end


	if attack_mod then 
		attack_mod:Destroy()
	end

	if no_cleave then 
		no_cleave:Destroy()
	end

	if caster:HasModifier("modifier_void_step_3") then 
		caster:AddNewModifier(caster, self, "modifier_void_spirit_astral_step_speed", {duration = self.speed_duration})
	end

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
	self:PlayEffects1( origin, target )
end

--------------------------------------------------------------------------------
function void_spirit_astral_step_custom:PlayEffects1( origin, target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

function void_spirit_astral_step_custom:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end




modifier_void_spirit_astral_step = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_astral_step:IsHidden()
	return false
end

function modifier_void_spirit_astral_step:IsDebuff()
	return true
end

function modifier_void_spirit_astral_step:IsStunDebuff()
	return false
end

function modifier_void_spirit_astral_step:IsPurgable()
	return true
end

function modifier_void_spirit_astral_step:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_void_spirit_astral_step:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_void_spirit_astral_step:OnRefresh( kv )
	
end


function modifier_void_spirit_astral_step:OnDestroy()
if not IsServer() then return end
if not self:GetParent() then return end
if self:GetParent():IsNull() then return end
if not self:GetParent():IsAlive() then return end


if self:GetCaster():HasModifier("modifier_void_step_4") then 
	local health = self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()

	health = health*(self:GetAbility().lowhp_init + self:GetAbility().lowhp_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_4"))
	SendOverheadEventMessage(nil, 6, self:GetParent(), health, nil)
	self.damage = self.damage + health
end


	-- Apply damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_astral_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_void_spirit_astral_step:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_astral_step:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_void_spirit_astral_step:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_void_spirit_astral_step:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_void_spirit_astral_step:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_void_spirit_astral_step:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
	local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self:GetParent():EmitSound(sound_target)
end



modifier_void_spirit_legendary_illusion = class({})
function modifier_void_spirit_legendary_illusion:IsHidden() return true end
function modifier_void_spirit_legendary_illusion:IsPurgable() return false end
function modifier_void_spirit_legendary_illusion:GetStatusEffectName() return "particles/void_step_texture.vpcf" end

function modifier_void_spirit_legendary_illusion:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_CAPTURE)
end

function modifier_void_spirit_legendary_illusion:StatusEffectPriority()
    return 10010
end

function modifier_void_spirit_legendary_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_OUT_OF_GAME]	= true,
	[MODIFIER_STATE_STUNNED]	= true,
}

end

modifier_void_spirit_astral_step_attack = class({})
function modifier_void_spirit_astral_step_attack:IsHidden() return true end
function modifier_void_spirit_astral_step_attack:IsPurgable() return false end
function modifier_void_spirit_astral_step_attack:GetCritDamage() 
local crit = 0
if self:GetParent():HasModifier("modifier_void_step_1") then 
	crit = self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_void_step_1")
end

return crit
end

function modifier_void_spirit_astral_step_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_void_spirit_astral_step_attack:GetModifierPreAttack_CriticalStrike()
local crit = 0
if self:GetParent():HasModifier("modifier_void_step_1") then 
	crit = self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_void_step_1")
end

return crit
end





modifier_void_spirit_astral_step_speed = class({})
function modifier_void_spirit_astral_step_speed:IsHidden() return false end
function modifier_void_spirit_astral_step_speed:IsPurgable() return false end
function modifier_void_spirit_astral_step_speed:GetEffectName() return "particles/void_step_speed.vpcf" end
function modifier_void_spirit_astral_step_speed:GetTexture() return "buffs/remnant_speed" end

function modifier_void_spirit_astral_step_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_void_spirit_astral_step_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_void_step_3")
end


modifier_void_spirit_astral_step_tracker = class({})
function modifier_void_spirit_astral_step_tracker:IsHidden() return true end
function modifier_void_spirit_astral_step_tracker:IsPurgable() return false end
function modifier_void_spirit_astral_step_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_void_spirit_astral_step_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_void_step_5") then return end

local chance = self:GetAbility().passive_chance
local random = RollPseudoRandomPercentage(chance,92,self:GetParent())

if not random then return end

params.target:EmitSound("VoidSpirit.Step.Passive")

local delay = self:GetAbility():GetSpecialValueFor( "pop_damage_delay" )

params.target:AddNewModifier(self:GetParent(), self:GetAbility(),  "modifier_void_spirit_astral_step", { duration = delay })
	

end

function modifier_void_spirit_astral_step_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_step_6") then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().charge_health then return end
if self:GetParent():HasModifier("modifier_void_spirit_astral_step_charge_cd") then return end
if not self:GetParent():IsAlive() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_astral_step_charge_cd", {duration = self:GetAbility().charge_cd})

local ability = self:GetAbility()

if self:GetParent():HasModifier("modifier_void_step_2") then 
	local n = self:GetParent():FindModifierByName("modifier_void_step_2"):GetStackCount()
	ability = self:GetParent():FindAbilityByName("void_spirit_astral_step_custom_"..n)
end

self:GetParent():EmitSound("Sf.Souls_Heal")   
local particle_aoe_fx = ParticleManager:CreateParticle("particles/void_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_aoe_fx, 0,  self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(150, 1, 1))
ParticleManager:ReleaseParticleIndex(particle_aoe_fx)  




if ability:GetCurrentAbilityCharges() == 2 then return end 



if ability:GetCurrentAbilityCharges() == 0 then 
	ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges() + 1)
else 
	if ability:GetCurrentAbilityCharges() == 1 then 
		ability:RefreshCharges()
	end
end


end

modifier_void_spirit_astral_step_charge_cd = class({})
function modifier_void_spirit_astral_step_charge_cd:IsHidden() return false end
function modifier_void_spirit_astral_step_charge_cd:IsPurgable() return false end
function modifier_void_spirit_astral_step_charge_cd:IsDebuff() return true end
function modifier_void_spirit_astral_step_charge_cd:RemoveOnDeath() return false end
function modifier_void_spirit_astral_step_charge_cd:GetTexture() return "buffs/step_cd" end
function modifier_void_spirit_astral_step_charge_cd:OnCreated(table)
self.RemoveForDuel = true
end