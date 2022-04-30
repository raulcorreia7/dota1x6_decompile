LinkLuaModifier( "modifier_primal_beast_onslaught_custom_cast", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_HORIZONTAL )

primal_beast_onslaught_custom = class({})

function primal_beast_onslaught_custom:OnSpellStart()
	if not IsServer() then return end
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor( "chargeup_time" )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_cast", { duration = duration } )

	local release_ability = self:GetCaster():FindAbilityByName( "primal_beast_onslaught_release_custom" )

	if release_ability then
		release_ability:UseResources( false, false, true )
	end

	self:GetCaster():SwapAbilities( "primal_beast_onslaught_custom", "primal_beast_onslaught_release_custom", false, true )
end

function primal_beast_onslaught_custom:OnChargeFinish( interrupt )
	if not IsServer() then return end

	self:GetCaster():SwapAbilities( "primal_beast_onslaught_release_custom", "primal_beast_onslaught_custom", false, true )

	local max_duration = self:GetSpecialValueFor( "chargeup_time" )
	local max_distance = self:GetSpecialValueFor( "max_distance" )
	local speed = self:GetSpecialValueFor( "charge_speed" )
	local charge_duration = max_duration

	local mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_onslaught_custom_cast" )
	if mod then
		if mod.effect_cast then
			ParticleManager:DestroyParticle(mod.effect_cast, true)
		end
		charge_duration = mod:GetElapsedTime()
		mod.charge_finish = true
		mod:Destroy()
	end

	local distance = max_distance * charge_duration / max_duration
	local duration = distance / speed

	if interrupt then return end

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom", { duration = duration } )
	self:GetCaster():EmitSound("Hero_PrimalBeast.Onslaught")
end

-- Абилка внезапного побега

primal_beast_onslaught_release_custom = class({})

function primal_beast_onslaught_release_custom:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("primal_beast_onslaught_custom")
	if ability then
		ability:OnChargeFinish( false )
	end
end


modifier_primal_beast_onslaught_custom_cast = class({})

function modifier_primal_beast_onslaught_custom_cast:IsPurgable()
	return false
end

function modifier_primal_beast_onslaught_custom_cast:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )

	if not IsServer() then return end
	self.anim_return = 0
	self.origin = self:GetParent():GetOrigin()
	self.charge_finish = false
	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true
	self:StartIntervalThink( FrameTime() )
	
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_primal_beast_onslaught_custom_cast:OnRemoved()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
	self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	if not self.charge_finish then
		self:GetAbility():OnChargeFinish( false )
	end
end

function modifier_primal_beast_onslaught_custom_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_primal_beast_onslaught_custom_cast:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:GetAbility():OnChargeFinish( false )
	end	
end

function modifier_primal_beast_onslaught_custom_cast:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom_cast:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_primal_beast_onslaught_custom_cast:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	return state
end

function modifier_primal_beast_onslaught_custom_cast:OnIntervalThink()
	if IsServer() then
		self.anim_return = self.anim_return + FrameTime()
		if self.anim_return >= 1 then
			self.anim_return = 0
			self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
		end
	end
	if self:GetParent():IsRooted() or self:GetParent():IsStunned() or self:GetParent():IsSilenced() or
		self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()
	then
		self:GetAbility():OnChargeFinish( true )
	end
	self:TurnLogic( FrameTime() )
	self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_primal_beast_onslaught_custom_cast:PlayEffects1()
	self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_range_finder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	self:AddParticle( self.effect_cast, false, false, -1, false, false )
	self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:SetEffects()
	local target_pos = self.origin + self:GetParent():GetForwardVector() * self.speed * self:GetElapsedTime()
	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_primal_beast_onslaught_custom_cast:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )
	self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
end

modifier_primal_beast_onslaught_custom = class({})

function modifier_primal_beast_onslaught_custom:IsPurgable()
	return false
end

function modifier_primal_beast_onslaught_custom:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.radius = self:GetAbility():GetSpecialValueFor( "knockback_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "knockback_damage" )
	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3

	if not IsServer() then return end

	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true
	self.knockback_units = {}
	self.knockback_units[self:GetParent()] = true

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end

	self.damageTable = { attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() }
end

function modifier_primal_beast_onslaught_custom:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController(self)
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )
end


function modifier_primal_beast_onslaught_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end

function modifier_primal_beast_onslaught_custom:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetDirection( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_primal_beast_onslaught_custom:GetModifierDisableTurning()
	return 1
end

function modifier_primal_beast_onslaught_custom:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_primal_beast_onslaught_custom:GetActivityTranslationModifiers()
	return "onslaught_movement"
end


function modifier_primal_beast_onslaught_custom:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_primal_beast_onslaught_custom:HitLogic()
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, false )
	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	for _,unit in pairs(units) do
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true
			local is_enemy = unit:GetTeamNumber()~=self:GetParent():GetTeamNumber()

			if is_enemy then
				local enemy = unit
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.stun } )
			end

			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				local direction = unit:GetOrigin()-self:GetParent():GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

		        local knockbackProperties =
		        {
		            center_x = unit:GetOrigin().x,
		            center_y = unit:GetOrigin().y,
		            center_z = unit:GetOrigin().z,
		            duration = self.duration,
		            knockback_duration = self.duration,
		            knockback_distance = self.distance,
		            knockback_height = self.height
		        }
		        unit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
			end

			self:PlayEffects( unit, self.radius )
		end
	end
end

function modifier_primal_beast_onslaught_custom:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsRooted() then
		self:Destroy()
		return
	end
	self:HitLogic()
	self:TurnLogic( dt )
	local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
	me:SetOrigin(nextpos)
end

function modifier_primal_beast_onslaught_custom:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_onslaught_custom:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_primal_beast_onslaught_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_primal_beast_onslaught_custom:PlayEffects( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
end


