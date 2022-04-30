LinkLuaModifier( "modifier_primal_beast_uproar_custom", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_buff", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_debuff", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )

primal_beast_uproar_custom = class({})

function primal_beast_uproar_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function primal_beast_uproar_custom:GetAbilityTextureName(  )
	local stack = self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() )
	if stack==0 then
		return "primal_beast_uproar_none"
	elseif stack == self:GetSpecialValueFor("stack_limit") then
		return "primal_beast_uproar_max"
	else
		return "primal_beast_uproar_mid"
	end
end

function primal_beast_uproar_custom:IsRefreshable()
	return false
end

function primal_beast_uproar_custom:GetIntrinsicModifierName()
	return "modifier_primal_beast_uproar_custom"
end

function primal_beast_uproar_custom:CastFilterResult()
	if self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() ) < 1 then
		return UF_FAIL_CUSTOM
	end
	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_custom_buff") then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function primal_beast_uproar_custom:GetCustomCastError( hTarget )
	if self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() ) < 1 then
		return "#dota_hud_error_no_uproar_stacks"
	end
	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_custom_buff") then
		return "#dota_hud_error_already_roared"
	end
	return ""
end

function primal_beast_uproar_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor( "roar_duration" )
	local radius = self:GetSpecialValueFor( "radius" )
	local slow = self:GetSpecialValueFor( "slow_duration" )

	local stack = 0
	local modifier = self:GetCaster():FindModifierByName( "modifier_primal_beast_uproar_custom" )
	if modifier then
		stack = modifier:GetStackCount()
		modifier:ResetStack()
	end

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_uproar_custom_buff", { duration = duration, stack = stack } )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_uproar_custom_debuff", { duration = slow, stack = stack } )
	end

	self:PlayEffects( radius )
	self:PlayEffects2()
end

function primal_beast_uproar_custom:PlayEffects( radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("Hero_PrimalBeast.Uproar.Cast")
end

function primal_beast_uproar_custom:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_jaw_fx", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_primal_beast_uproar_custom = class({})

function modifier_primal_beast_uproar_custom:IsHidden()
	return self:GetStackCount() < 1
end

function modifier_primal_beast_uproar_custom:IsPurgable()
	return false
end

function modifier_primal_beast_uproar_custom:RemoveOnDeath()
	return false
end

function modifier_primal_beast_uproar_custom:DestroyOnExpire()
	return false
end

function modifier_primal_beast_uproar_custom:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	if not IsServer() then return end
	self.damage_count = 0

	self.damage_limit = self:GetAbility():GetSpecialValueFor( "damage_limit" )/100
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
end

function modifier_primal_beast_uproar_custom:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	if not IsServer() then return end
	self.damage_limit = self:GetAbility():GetSpecialValueFor( "damage_limit" )/100
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )	
end

function modifier_primal_beast_uproar_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_primal_beast_uproar_custom:OnTakeDamage( params )
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier( "modifier_primal_beast_uproar_custom_buff" ) then return end
if params.unit ~= self:GetParent() then return end

local damage = params.damage
local max = self:GetParent():GetMaxHealth()*self.damage_limit


while damage > 0 do 
	self.damage_count = damage + self.damage_count

	if self.damage_count < max then 
	    damage = 0
    else 
	    damage =  self.damage_count - max
	    self.damage_count = 0

		if self:GetStackCount() < self.stack_limit then
			self:IncrementStackCount()
			if self:GetStackCount() == self.stack_limit then
				self:GetParent():EmitSound("Hero_PrimalBeast.Uproar.MaxStacks")
			end
		end

		self:SetDuration( self.duration, true )
		self:StartIntervalThink(self.duration)
	end
end




end

function modifier_primal_beast_uproar_custom:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_primal_beast_uproar_custom:OnIntervalThink()
	self:ResetStack()
end

function modifier_primal_beast_uproar_custom:ResetStack()
	self:SetStackCount(0)
end

modifier_primal_beast_uproar_custom_buff = class({})

function modifier_primal_beast_uproar_custom_buff:IsPurgable()
	return true
end

function modifier_primal_beast_uproar_custom_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" )
	self.armor = self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
	self:PlayEffects()
end


function modifier_primal_beast_uproar_custom_buff:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" )
	self.armor = self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_primal_beast_uproar_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_primal_beast_uproar_custom_buff:GetModifierPreAttack_BonusDamage()
	return self.damage * self:GetStackCount()
end

function modifier_primal_beast_uproar_custom_buff:GetModifierPhysicalArmorBonus()
	return self.armor * self:GetStackCount()
end

function modifier_primal_beast_uproar_custom_buff:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 2, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )
end

modifier_primal_beast_uproar_custom_debuff = class({})

function modifier_primal_beast_uproar_custom_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_uproar_custom_debuff:GetTexture()
	return "primal_beast_uproar"
end

function modifier_primal_beast_uproar_custom_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_primal_beast_uproar_custom_debuff:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_primal_beast_uproar_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_primal_beast_uproar_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * self:GetStackCount()
end

function modifier_primal_beast_uproar_custom_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_primal_beast_uproar_custom_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end