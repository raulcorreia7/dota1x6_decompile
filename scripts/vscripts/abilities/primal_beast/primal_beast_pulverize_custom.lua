LinkLuaModifier( "modifier_primal_beast_pulverize_custom", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_pulverize_custom_debuff", "abilities/primal_beast/primal_beast_pulverize_custom", LUA_MODIFIER_MOTION_BOTH )

primal_beast_pulverize_custom = class({})

function primal_beast_pulverize_custom:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end

function primal_beast_pulverize_custom:GetChannelTime()
	return self:GetSpecialValueFor( "channel_time" )
end

primal_beast_pulverize_custom.modifiers = {}

function primal_beast_pulverize_custom:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb( self ) then
		self:GetCaster():Interrupt()
		return
	end

	local duration = self:GetSpecialValueFor( "channel_time" )

	local mod = target:AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_pulverize_custom_debuff", { duration = duration } )
	self.modifiers[mod] = true

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_pulverize_custom", { duration = duration } )

	if not target:IsHero() then
		self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Cast.Creep")
	else
		self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Cast")
	end
end

function primal_beast_pulverize_custom:OnChannelFinish( bInterrupted )
	if not IsServer() then return end

	for mod,_ in pairs(self.modifiers) do
		if not mod:IsNull() then
			mod:Destroy()
		end
	end

	self.modifiers = {}

	local self_mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_pulverize_custom" )
	if self_mod then
		self_mod:Destroy()
	end
end

function primal_beast_pulverize_custom:RemoveModifier( mod )
	self.modifiers[mod] = nil

	local has_enemies = false

	for _,mod in pairs(self.modifiers) do
		has_enemies = true
	end

	if not has_enemies then
		self:EndChannel( true )
	end
end

modifier_primal_beast_pulverize_custom = class({})

function modifier_primal_beast_pulverize_custom:IsPurgable()
	return false
end

function modifier_primal_beast_pulverize_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_primal_beast_pulverize_custom:GetModifierDisableTurning()
	return 1
end

modifier_primal_beast_pulverize_custom_debuff = class({})

function modifier_primal_beast_pulverize_custom_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_pulverize_custom_debuff:IsStunDebuff()
	return true
end

function modifier_primal_beast_pulverize_custom_debuff:OnCreated( kv )
	self.isRoshan = self:GetParent():GetUnitName()=="npc_dota_roshan"
	self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
	self.radius = self:GetAbility():GetSpecialValueFor( "splash_radius" )
	self.ministun = self:GetAbility():GetSpecialValueFor( "ministun" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.animrate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	if not IsServer() then return end

	self.interrupt_pos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 200
	self.cast_pos = self:GetCaster():GetOrigin()
	self.pos_threshold = 100

	local attach_rollback = {
		[1] = "attach_pummel",
		[2] = "attach_attack1",
		[3] = "attach_attack",
		[4] = "attach_hitloc",
	}

	for i,name in ipairs(attach_rollback) do
		self.attach_name = name
		if self:GetCaster():ScriptLookupAttachment( name )~=0 then
			break
		end
	end

	local hitloc_enum = self:GetParent():ScriptLookupAttachment( "attach_hitloc" )
	local hitloc_pos = self:GetParent():GetAttachmentOrigin( hitloc_enum )
	self.deltapos = self:GetParent():GetOrigin() - hitloc_pos

	if not self:ApplyHorizontalMotionController() then
		if not self.isRoshan then
			self:Destroy()
			return
		end
	end

	if not self:ApplyVerticalMotionController() then
		if not self.isRoshan then
			self:Destroy()
			return
		end
	end

	self:SetPriority( DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST )
	self:StartIntervalThink( self.interval )
end

function modifier_primal_beast_pulverize_custom_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )

	if not (self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()) then
		FindClearSpaceForUnit( self:GetParent(), self.interrupt_pos, false )
		local angle = self:GetParent():GetAnglesAsVector()
		self:GetParent():SetAngles( 0, angle.y+180, 0 )
	end

	self:GetAbility():RemoveModifier( self )
end

function modifier_primal_beast_pulverize_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_primal_beast_pulverize_custom_debuff:GetOverrideAnimation()
	if self.isRoshan then
		return ACT_DOTA_DISABLED
	end

	return ACT_DOTA_FLAIL
end

function modifier_primal_beast_pulverize_custom_debuff:GetOverrideAnimationRate()
	return self.animrate
end

function modifier_primal_beast_pulverize_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	return state
end

function modifier_primal_beast_pulverize_custom_debuff:OnIntervalThink()
	local origin = self.interrupt_pos
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), origin, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local damageTable = { attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.ministun } )
		self:GetCaster():EmitSound("Hero_PrimalBeast.Pulverize.Stun")
	end

	self:PlayEffects( origin, self.radius )

	if (self:GetCaster():GetOrigin()-self.cast_pos):Length2D() > self.pos_threshold then
		self:Destroy()
		return		
	end
end


function modifier_primal_beast_pulverize_custom_debuff:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsOutOfGame() or self:GetParent():IsInvulnerable() then
		self:Destroy()
		return
	end

	local attach = self:GetCaster():ScriptLookupAttachment( self.attach_name )
	local pos = self:GetCaster():GetAttachmentOrigin( attach )
	local angles = self:GetCaster():GetAttachmentAngles( attach )

	me:SetLocalAngles( 180-angles.x, 180+angles.y, 0 )

	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	me:SetOrigin( pos )
end


function modifier_primal_beast_pulverize_custom_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_pulverize_custom_debuff:UpdateVerticalMotion( me, dt )
	local attach = self:GetCaster():ScriptLookupAttachment( self.attach_name )
	local pos = self:GetCaster():GetAttachmentOrigin( attach )
	local angles = self:GetCaster():GetAttachmentAngles( attach )

	local deltapos = RotatePosition( Vector(0,0,0), QAngle(180-angles.x, 180+angles.y,0), self.deltapos )
	pos = pos + deltapos

	local mepos = me:GetOrigin()
	mepos.z = pos.z
	me:SetOrigin( mepos )
end

function modifier_primal_beast_pulverize_custom_debuff:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_pulverize_custom_debuff:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_custom_debuff:GetMotionPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function modifier_primal_beast_pulverize_custom_debuff:PlayEffects( origin, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:DestroyParticle( effect_cast, false )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_PrimalBeast.Pulverize.Impact", self:GetCaster() )
end