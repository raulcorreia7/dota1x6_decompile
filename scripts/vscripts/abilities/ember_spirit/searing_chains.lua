LinkLuaModifier("modifier_searing_chains_custom_debuff", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_speed", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_tracker", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_resist", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)

ember_spirit_searing_chains_custom = class({})

ember_spirit_searing_chains_custom.duration_init = 0
ember_spirit_searing_chains_custom.duration_inc = 0.3

ember_spirit_searing_chains_custom.speed_attack_init = 20
ember_spirit_searing_chains_custom.speed_attack_inc = 20
ember_spirit_searing_chains_custom.speed_move_init = 5
ember_spirit_searing_chains_custom.speed_move_inc = 5
ember_spirit_searing_chains_custom.speed_duration = 3

ember_spirit_searing_chains_custom.legendary_chance = 30
ember_spirit_searing_chains_custom.legendary_duration = 1.8
ember_spirit_searing_chains_custom.legendary_damage = 0.05

ember_spirit_searing_chains_custom.heal_init = 0.05
ember_spirit_searing_chains_custom.heal_inc = 0.05

ember_spirit_searing_chains_custom.stun_duration = 0.5

ember_spirit_searing_chains_custom.reduction_heal = -25
ember_spirit_searing_chains_custom.reduction_damage = -25

ember_spirit_searing_chains_custom.resist_duration = 10
ember_spirit_searing_chains_custom.resist_init = -2
ember_spirit_searing_chains_custom.resist_inc = -3
ember_spirit_searing_chains_custom.resist_max = 5


function ember_spirit_searing_chains_custom:GetIntrinsicModifierName()
return "modifier_searing_chains_custom_tracker"
end

function ember_spirit_searing_chains_custom:OnSpellStart()
if not IsServer() then return end

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local targets_count = self:GetSpecialValueFor("unit_count")
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	if self:GetCaster():HasModifier("modifier_ember_chain_1") then 
		duration = duration + self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_1")
	end

	caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")

	local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
		targets_count = #nearby_enemies
	end

	for i = 1, targets_count do
		if nearby_enemies[i] then
			ApplySearingChains(caster, caster, nearby_enemies[i], self, duration)
		end
	end


end

function ApplySearingChains(caster, source, target, ability, duration)
if not IsServer() then return end

	
	if caster:HasModifier("modifier_ember_chain_2") then 
		caster:AddNewModifier(caster, ability, "modifier_searing_chains_custom_speed", {duration = ability.speed_duration})
	end


	if caster:HasModifier("modifier_ember_chain_5") then 
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability.stun_duration*(1 - target:GetStatusResistance())})
	end

	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
	local point = target:GetAbsOrigin()
	point.z = point.z + 100

	target:AddNewModifier(caster, ability, "modifier_searing_chains_custom_debuff", {duration = duration * (1 - target:GetStatusResistance())})
	local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(impact_pfx, 0, source:GetAbsOrigin())
	ParticleManager:SetParticleControl(impact_pfx, 1, point)
	ParticleManager:ReleaseParticleIndex(impact_pfx)
end

modifier_searing_chains_custom_debuff = class({})

function modifier_searing_chains_custom_debuff:IsDebuff() return true end
function modifier_searing_chains_custom_debuff:IsHidden() return false end
function modifier_searing_chains_custom_debuff:IsPurgable() return true end

function modifier_searing_chains_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_searing_chains_custom_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_searing_chains_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_searing_chains_custom_debuff:OnCreated(keys)
	if not IsServer() then return end
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
	self.damage =  self:GetAbility():GetSpecialValueFor("damage_per_second")*self.tick_interval
	self:StartIntervalThink(self.tick_interval)
	--self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1 * (1 - self:GetParent():GetStatusResistance())})
end

function modifier_searing_chains_custom_debuff:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

end


function modifier_searing_chains_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end
function modifier_searing_chains_custom_debuff:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if not self:GetCaster():HasModifier("modifier_ember_chain_4") then return end
if params.target ~= self:GetParent() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_searing_chains_custom_resist", {duration = self:GetAbility().resist_duration})
end



function modifier_searing_chains_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self:GetAbility().reduction_heal
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self:GetAbility().reduction_heal
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierHPRegenAmplify_Percentage()
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self:GetAbility().reduction_heal
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self:GetAbility().reduction_damage
else 
	return
end

end


modifier_searing_chains_custom_speed = class({})
function modifier_searing_chains_custom_speed:IsHidden() return false end
function modifier_searing_chains_custom_speed:IsPurgable() return true end
function modifier_searing_chains_custom_speed:GetTexture() return "buffs/chains_speed" end
function modifier_searing_chains_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_searing_chains_custom_speed:GetModifierAttackSpeedBonus_Constant()
return
self:GetAbility().speed_attack_init + self:GetAbility().speed_attack_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_2")
end

function modifier_searing_chains_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return
self:GetAbility().speed_move_init + self:GetAbility().speed_move_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_2")
end


modifier_searing_chains_custom_tracker = class({})
function modifier_searing_chains_custom_tracker:IsHidden() return true end
function modifier_searing_chains_custom_tracker:IsPurgable() return false end
function modifier_searing_chains_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_searing_chains_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_ember_chain_3") then return end
if not params.unit:HasModifier("modifier_searing_chains_custom_debuff") then return end
if not self:GetParent():IsRealHero() then return end

local heal = params.damage*(self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_ember_chain_3"))

self:GetParent():Heal(heal, self:GetAbility())


local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )


end


function modifier_searing_chains_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_ember_chain_legendary") then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

local random = RollPseudoRandomPercentage(self:GetAbility().legendary_chance,121,self:GetParent())

if not random then return end

if params.target:HasModifier("modifier_searing_chains_custom_debuff") then 

	params.target:EmitSound("Ember.Chains_Proc")

	local damage = params.target:GetMaxHealth()*self:GetAbility().legendary_damage
	ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
else

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	ApplySearingChains(self:GetParent(), self:GetParent(), params.target, self:GetAbility(), self:GetAbility().legendary_duration)

end

end


modifier_searing_chains_custom_resist = class({})
function modifier_searing_chains_custom_resist:IsHidden() return false end
function modifier_searing_chains_custom_resist:IsPurgable() return false end
function modifier_searing_chains_custom_resist:GetTexture() return "buffs/chains_resist" end
function modifier_searing_chains_custom_resist:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_searing_chains_custom_resist:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().resist_max then return end
self:IncrementStackCount()
end

function modifier_searing_chains_custom_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}

end

function modifier_searing_chains_custom_resist:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*(self:GetAbility().resist_init + self:GetAbility().resist_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_4"))
end