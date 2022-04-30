LinkLuaModifier( "modifier_primal_beast_trample_custom", "abilities/primal_beast/primal_beast_trample_custom", LUA_MODIFIER_MOTION_NONE )

primal_beast_trample_custom = class({})

function primal_beast_trample_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor( "duration" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_trample_custom", { duration = duration } )
end

modifier_primal_beast_trample_custom = class({})

function modifier_primal_beast_trample_custom:IsPurgable()
	return false
end

function modifier_primal_beast_trample_custom:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.step_distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) / 100
	if not IsServer() then return end
	self.distance = 0
	self.treshold = 500
	self.currentpos = self:GetParent():GetOrigin()
	self:StartIntervalThink( 0.1 )
	self:Trample()
end

function modifier_primal_beast_trample_custom:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "effect_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "step_distance" )
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
	self.attack_damage = self:GetAbility():GetSpecialValueFor( "attack_damage" ) / 100
end

function modifier_primal_beast_trample_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_primal_beast_trample_custom:GetActivityTranslationModifiers()
	return "heavy_steps"
end

function modifier_primal_beast_trample_custom:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_primal_beast_trample_custom:OnIntervalThink()
	local pos = self:GetParent():GetOrigin()
	local dist = (pos-self.currentpos):Length2D()
	self.currentpos = pos
	GridNav:DestroyTreesAroundPoint( pos, self.radius, false )
	if dist>self.treshold then return end
	self.distance = self.distance + dist
	if self.distance > self.step_distance then
		self:Trample()
		self.distance = 0
	end
end

function modifier_primal_beast_trample_custom:Trample()
	local pos = self:GetParent():GetOrigin()
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local damage = self.base_damage + self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self.attack_damage
	local damageTable = { attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil )
	end

	self:PlayEffects()
end

function modifier_primal_beast_trample_custom:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_disarm.vpcf"
end

function modifier_primal_beast_trample_custom:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_primal_beast_trample_custom:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetParent():EmitSound("Hero_PrimalBeast.Trample")
end