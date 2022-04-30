LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_debuff", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood_count", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_hits", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_knockback", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_HORIZONTAL )

hoodwink_sharpshooter_custom = class({})

hoodwink_sharpshooter_custom.charge_init = 0.05
hoodwink_sharpshooter_custom.charge_inc = 0.05

hoodwink_sharpshooter_custom.blood_init = 0
hoodwink_sharpshooter_custom.blood_inc = 0.1
hoodwink_sharpshooter_custom.blood_duration = 5
hoodwink_sharpshooter_custom.blood_interval = 1

hoodwink_sharpshooter_custom.legendary_1 = 0.33
hoodwink_sharpshooter_custom.legendary_2 = 0.66

hoodwink_sharpshooter_custom.cast_vision = 1

hoodwink_sharpshooter_custom.hit_init = 10
hoodwink_sharpshooter_custom.hit_inc = 10

hoodwink_sharpshooter_custom.cd = {-10, -15, -20}

hoodwink_sharpshooter_custom.healing_reduction = -50

hoodwink_sharpshooter_custom.knock_self = 250
hoodwink_sharpshooter_custom.knockback_duration = 0.2
hoodwink_sharpshooter_custom.knockback_distance = 200

function hoodwink_sharpshooter_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_2") then
	bonus = self.cd[self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_2")]
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end


function hoodwink_sharpshooter_custom:GetBehavior()
  	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_legendary") then
    	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
  	end
 	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function hoodwink_sharpshooter_custom:OnSpellStart()
	local point = self:GetCursorPosition()

	--if point.x == self:GetCaster():GetAbsOrigin().x and point.y == self:GetCaster():GetAbsOrigin().y then 
		--point = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
	--end

	local duration = self:GetSpecialValueFor( "misfire_time" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom", { duration = duration, x = point.x, y = point.y, } )
end

function hoodwink_sharpshooter_custom:OnProjectileThink_ExtraData( location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )
	if not sound or sound:IsNull() then return end
	sound:SetOrigin( location )
end

function hoodwink_sharpshooter_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )

	local reduce_cd = false
	if sound and sound.hit_hero == false then 
		reduce_cd = true
	end

	if false then 
		if not sound or sound:IsNull() then return end
		sound:StopSound("Hero_Hoodwink.Sharpshooter.Projectile")
		UTIL_Remove( sound )
	end


	if not target then 
		return false 
	end

	local k = 1
	local creep = false

	if target:IsCreep() then 
		k = self:GetSpecialValueFor("creeps")/100
	end


	if target:IsBuilding() then 
		k = self:GetSpecialValueFor("building_damage")/100
	end

	local damageTable = { victim = target, attacker = self:GetCaster(), damage = ExtraData.damage*k, damage_type = self:GetAbilityDamageType(), ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE }
	ApplyDamage(damageTable)


	if target:IsRealHero() then 
		sound.hit_hero = true
	end

	if ExtraData.pct == 1 and target:IsRealHero() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_hits", {})
	end

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_3") and not target:IsBuilding() then 

		local damage = (self.blood_init + self.blood_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_3"))*ExtraData.damage*k
		target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood", {duration = self.blood_duration, damage = damage})
		target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood_count", {duration = self.blood_duration, damage = damage})


	end

	target:AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_debuff", { duration = ExtraData.duration*(1 - target:GetStatusResistance()), x = ExtraData.x, y = ExtraData.y } )
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, ExtraData.damage*k, self:GetCaster():GetPlayerOwner() )
	
	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_5") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_knockback", {duration = self.knockback_duration * (1 - target:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
    end			

	AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), 300, 4, false)

	local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_Hoodwink.Sharpshooter.Target")
	return creep
end



hoodwink_sharpshooter_release_custom = class({})

function hoodwink_sharpshooter_release_custom:OnSpellStart()
	local mod = self:GetCaster():FindModifierByName( "modifier_hoodwink_sharpshooter_custom" )
	if not mod then return end
	mod:Destroy()
end


modifier_hoodwink_sharpshooter_custom = class({})

function modifier_hoodwink_sharpshooter_custom:IsPurgable()
	return false
end





function modifier_hoodwink_sharpshooter_custom:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()
	self.charge = self:GetAbility():GetSpecialValueFor( "max_charge_time" )


	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_1") then 
		self.charge = self.charge - self.charge*(self:GetAbility().charge_init + self:GetAbility().charge_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_sharp_1"))
	end


	self.damage = self:GetAbility():GetSpecialValueFor( "max_damage" )

	if self:GetCaster():HasModifier("modifier_hoodwink_sharpshooter_custom_hits") and self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then 
		self.damage = self.damage + (self:GetAbility().hit_init + self:GetAbility().hit_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_4"))*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharpshooter_custom_hits")
	end

	self.duration = self:GetAbility():GetSpecialValueFor( "max_slow_debuff_duration" )
	self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.recoil_distance = self:GetAbility():GetSpecialValueFor( "recoil_distance" )
	self.recoil_duration = self:GetAbility():GetSpecialValueFor( "recoil_duration" )
	self.recoil_height = self:GetAbility():GetSpecialValueFor( "recoil_height" )

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_5") then 
		self.recoil_distance = self.recoil_distance + self:GetAbility().knock_self
	end

	self.interval = 0.03


	self.shot_1 = false
	self.shot_2 = false

	self:StartIntervalThink( self.interval)
	if not IsServer() then return end

	self.RemoveForDuel = true

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_1") then 
		self.projectile_speed = self.projectile_speed + self.projectile_speed*(self:GetAbility().charge_init + self:GetAbility().charge_inc*self:GetParent():GetUpgradeStack("modifier_hoodwink_sharp_1"))
	end



	self.projectile_range = self:GetAbility():GetSpecialValueFor( "arrow_range" )
	self.projectile_width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
	local projectile_vision = self:GetAbility():GetSpecialValueFor( "arrow_vision" )
	local vec = Vector( kv.x, kv.y, 0 )
	self:SetDirection( vec )
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector( self.current_dir )

	self.turn_speed = self.interval*self.turn_rate


	local type_target = DOTA_UNIT_TARGET_HERO
	local deleteonhit = true

	if true then 
		type_target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
		deleteonhit = false
	end


	self.info = {
		Source = self.parent,
		Ability = self:GetAbility(),
	    bDeleteOnHit = deleteonhit,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = type_target,
	    EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf",
	    fDistance = self.projectile_range,
	    fStartRadius = self.projectile_width,
	    fEndRadius = self.projectile_width,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
		bVisibleToEnemies = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self.caster:GetTeamNumber()
	}
	self.caster:SwapAbilities( "hoodwink_sharpshooter_custom", "hoodwink_sharpshooter_release_custom", false, true )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )

	EmitSoundOn("Hero_Hoodwink.Sharpshooter.Channel", self.parent)


end

function modifier_hoodwink_sharpshooter_custom:Shoot()
if not IsServer() then return end

	local direction = self.current_dir
	local pct = math.min(1, (math.min( self:GetElapsedTime(), self.charge )/self.charge + 0.2))
 
	self.info.vSpawnOrigin = self.parent:GetOrigin()
	self.info.vVelocity = direction * self.projectile_speed

	local sound = CreateModifierThinker( self.caster, self, "", {}, self.caster:GetOrigin(), self.team, false )
	sound:EmitSound("Hero_Hoodwink.Sharpshooter.Projectile")
	sound.hit_hero = false


	local duration = self.duration * pct
	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
		duration = self.duration
	end

	self.info.ExtraData = { damage = self.damage * pct, pct = pct, duration = duration, x = direction.x, y = direction.y, sound = sound:entindex(), }

	ProjectileManager:CreateLinearProjectile( self.info )

end


function modifier_hoodwink_sharpshooter_custom:OnDestroy()
if not IsServer() then return end

	local direction = self.current_dir

	StopSoundOn("Hero_Hoodwink.Sharpshooter.Channel",self.parent)

	self:Shoot()

	local bump_point = self:GetCaster():GetAbsOrigin() + direction * self.recoil_distance

	local mod = self.caster:AddNewModifier(
		self.caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_knockback", -- modifier name
		{
			duration = self.recoil_duration,
			knockback_height = self.recoil_height,
			knockback_distance = self.recoil_distance,
			knockback_duration = self.recoil_duration,
			center_x = bump_point.x,
			center_y = bump_point.y,
			center_z = bump_point.z,
		} -- kv
	)

	self.caster:SwapAbilities( "hoodwink_sharpshooter_release_custom", "hoodwink_sharpshooter_custom", false, true )

	if mod then
		local effect_cast = ParticleManager:CreateParticle( "particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		mod:AddParticle( effect_cast, false, false, -1, false, false )
	end

	self.caster:StopSound("Hero_Hoodwink.Sharpshooter.Cast")
	self.caster:EmitSound("Hero_Hoodwink.Sharpshooter.Cast")
	
end


function modifier_hoodwink_sharpshooter_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return funcs
end


function modifier_hoodwink_sharpshooter_custom:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6
end

function modifier_hoodwink_sharpshooter_custom:OnOrder( params )
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
	end
end

function modifier_hoodwink_sharpshooter_custom:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_hoodwink_sharpshooter_custom:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_hoodwink_sharpshooter_custom:GetModifierDisableTurning()
	return 1
end

function modifier_hoodwink_sharpshooter_custom:CheckState()
local state = {}
	state =
	{ 
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_hoodwink_sharpshooter_custom:OnIntervalThink()
	if not IsServer() then
		self:UpdateStack()
		return
	end
	self:TurnLogic()
	local startpos = self.parent:GetOrigin()
	local visions = self.projectile_range/self.projectile_width
	local delta = self.parent:GetForwardVector() * self.projectile_width


	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_legendary") then 
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetAbility():GetSpecialValueFor("arrow_range")*self:GetAbility().cast_vision, FrameTime(), false)
	end

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_legendary") and self:GetAbility():GetAutoCastState() == false then 

		if self:GetElapsedTime() >= self.charge*0.8*self:GetAbility().legendary_1 and self.shot_1 == false then 
			self:Shoot()
			self.shot_1 = true 
		end


		if self:GetElapsedTime() >= self.charge*0.8*self:GetAbility().legendary_2 and self.shot_2 == false then 
			self:Shoot()
			self.shot_2 = true 
		end
	end

	if not self.charged and self:GetElapsedTime()>self.charge*0.8 then
		self.charged = true
		self.parent:EmitSound("Hero_Hoodwink.Sharpshooter.MaxCharge")
	end
	local remaining = self:GetRemainingTime()
	local seconds = math.ceil( remaining )
	local isHalf = (seconds-remaining)>0.5
	if isHalf then seconds = seconds-1 end
	if self.half~=isHalf then
		self.half = isHalf
		local mid = 1
		if isHalf then mid = 8 end
		local len = 2
		if seconds<1 then len = 1 if not isHalf then return end end
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
	end
	--self:UpdateEffect()
end

function modifier_hoodwink_sharpshooter_custom:SetDirection( vec )


	if vec.x == self:GetCaster():GetAbsOrigin().x and vec.y == self:GetCaster():GetAbsOrigin().y then 
		vec = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
	end

	self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_hoodwink_sharpshooter_custom:TurnLogic()
	if self.face_target then return end
	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )
	local sign = -1
	if angle_diff<0 then sign = 1 end
	if math.abs( angle_diff )<1.1*self.turn_speed then
		self.current_dir = self.target_dir
		self.face_target = true
	else
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
	end
	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function modifier_hoodwink_sharpshooter_custom:UpdateStack()
	
	local pct = math.min(1, (math.min( self:GetElapsedTime(), self.charge )/self.charge + 0.2))
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end

function modifier_hoodwink_sharpshooter_custom:OrderFilter( data )
	if #data.units>1 then return true end
	local unit
	for _,id in pairs(data.units) do
		unit = EntIndexToHScript( id )
	end
	if unit~=self.parent then return true end
	if data.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	elseif data.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or data.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end
	return true
end

function modifier_hoodwink_sharpshooter_custom:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range
	ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end

modifier_hoodwink_sharpshooter_custom_debuff = class({})

function modifier_hoodwink_sharpshooter_custom_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_sharpshooter_custom_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow_move_pct" )
	if not IsServer() then return end
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	self:AddParticle( effect_cast, false, false, -1, false, false )
end

function modifier_hoodwink_sharpshooter_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}

	return funcs
end


function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end

function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end

function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end



function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_sharpshooter_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end





modifier_hoodwink_sharpshooter_custom_blood = class({})
function modifier_hoodwink_sharpshooter_custom_blood:IsHidden() return true end
function modifier_hoodwink_sharpshooter_custom_blood:IsPurgable() return true end
function modifier_hoodwink_sharpshooter_custom_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_hoodwink_sharpshooter_custom_blood:OnCreated(table)
if not IsServer() then return end

self.damage = table.damage
self.tick = self.damage/self:GetRemainingTime()
self.tick = self.tick*self:GetAbility().blood_interval

self:StartIntervalThink(self:GetAbility().blood_interval)
end


function modifier_hoodwink_sharpshooter_custom_blood:OnIntervalThink()
if not IsServer() then return end


local damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.tick,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.tick, nil)


end


function modifier_hoodwink_sharpshooter_custom_blood:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_hoodwink_sharpshooter_custom_blood_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

modifier_hoodwink_sharpshooter_custom_blood_count = class({})
function modifier_hoodwink_sharpshooter_custom_blood_count:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetTexture() return "buffs/sharp_blood" end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end
function modifier_hoodwink_sharpshooter_custom_blood_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_hoodwink_sharpshooter_custom_blood_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


modifier_hoodwink_sharpshooter_custom_hits = class({})
function modifier_hoodwink_sharpshooter_custom_hits:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_hits:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_hits:RemoveOnDeath() return false end
function modifier_hoodwink_sharpshooter_custom_hits:GetTexture() return "buffs/sharp_hits" end
function modifier_hoodwink_sharpshooter_custom_hits:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end
function modifier_hoodwink_sharpshooter_custom_hits:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

end

function modifier_hoodwink_sharpshooter_custom_hits:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}

end
function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip()
return self:GetStackCount()
end

function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip2()
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then 
	return self:GetStackCount()*(self:GetAbility().hit_init + self:GetAbility().hit_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_4"))
end
return
end





modifier_hoodwink_sharpshooter_custom_knockback = class({})

function modifier_hoodwink_sharpshooter_custom_knockback:IsHidden() return true end

function modifier_hoodwink_sharpshooter_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = self.ability.knockback_distance
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_hoodwink_sharpshooter_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  --GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_hoodwink_sharpshooter_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_hoodwink_sharpshooter_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_hoodwink_sharpshooter_custom_knockback:OnDestroy()
  if not IsServer() then return end
  self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_scream_slow", {duration = self:GetAbility().knockback_duration_slow})
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end
