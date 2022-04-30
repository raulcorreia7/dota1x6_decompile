LinkLuaModifier("modifier_custom_void_dissimilate", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_slow_thinker", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_slow", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_resist_tracker", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_resist", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_burn", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_dissimilate_exit", "abilities/void_spirit/void_spirit_dissimilate_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_dissimilate_custom = class({})

void_spirit_dissimilate_custom.damage_init = 0
void_spirit_dissimilate_custom.damage_inc = 40

void_spirit_dissimilate_custom.cd = {-2, -3, -4}

void_spirit_dissimilate_custom.stun_duration = 1.2

void_spirit_dissimilate_custom.legendary_duration = 3
void_spirit_dissimilate_custom.legendary_damage = 80

void_spirit_dissimilate_custom.portal_slow = {-20,-30,-40}
void_spirit_dissimilate_custom.portal_magic = {-10,-15,-20}

void_spirit_dissimilate_custom.resist_duration = 5
void_spirit_dissimilate_custom.resist_damage = -40

void_spirit_dissimilate_custom.burn_duration = 4
void_spirit_dissimilate_custom.burn_init = 0.05
void_spirit_dissimilate_custom.burn_inc = 0.05
void_spirit_dissimilate_custom.burn_interval = 1

void_spirit_dissimilate_custom.exit_delay = 2
void_spirit_dissimilate_custom.exit_damage = {0.5, 0.8}





function void_spirit_dissimilate_custom:OnSpellStart()

	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor( "phase_duration" )

	if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 
		duration = self.legendary_duration
	end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_custom_void_dissimilate", -- modifier name
		{ duration = duration } -- kv
	)

	local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
	self:GetCaster():EmitSound("sound_cast")



	if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 

		local ability_cancel = self:GetCaster():FindAbilityByName("void_spirit_dissimilate_custom_cancel")


		self:SetHidden(true)
		ability_cancel:SetHidden(false)

		self:GetCaster():SwapAbilities("void_spirit_dissimilate_custom", "void_spirit_dissimilate_custom_cancel", false, true)
	end

end




modifier_custom_void_dissimilate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_void_dissimilate:IsHidden()
	return false
end

function modifier_custom_void_dissimilate:IsDebuff()
	return false
end

function modifier_custom_void_dissimilate:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_void_dissimilate:OnCreated( kv )


	if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 
		for i = 0,self:GetParent():GetAbilityCount()-1 do
   	 		local ability = self:GetParent():GetAbilityByIndex(i)
    		if ability and ability:GetName() ~= "void_spirit_dissimilate_custom_cancel" then 
    			ability:SetActivated(false)
    		end
		end
	end



	self.portals = self:GetAbility():GetSpecialValueFor( "portals_per_ring" )
	self.angle = self:GetAbility():GetSpecialValueFor( "angle_per_ring_portal" )
	self.radius = self:GetAbility():GetSpecialValueFor( "damage_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "first_ring_distance_offset" )
	self.target_radius = self:GetAbility():GetSpecialValueFor( "destination_fx_radius" )

	self.RemoveForDuel = true

	if not IsServer() then return end

	local origin = self:GetParent():GetOrigin()
	local direction = self:GetParent():GetForwardVector()
	local zero = Vector(0,0,0)

	self.selected = 1

	self.points = {}
	self.effects = {}
	self.thinkers = {}

	table.insert( self.points, origin )
	table.insert( self.effects, self:PlayEffects1( origin, true ) )

	if self:GetParent():HasModifier("modifier_void_astral_3") then 
		local thinker = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_slow_thinker", {radius = self.radius}, origin, self:GetCaster():GetTeamNumber(), false)
		table.insert( self.thinkers, thinker )	
	end

	for i=1,self.portals do
		local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )

		local point = GetGroundPosition( origin + new_direction * self.distance, nil )

		table.insert( self.points, point )
		table.insert( self.effects, self:PlayEffects1( point, false ) )

		if self:GetParent():HasModifier("modifier_void_astral_3") then 
			local thinker = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_slow_thinker", {radius = self.radius}, point, self:GetCaster():GetTeamNumber(), false)
			table.insert( self.thinkers, thinker )	
		end

	end

	if self:GetParent():HasShard() then 
		for i=1,self.portals do
			local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )

			local point = GetGroundPosition( origin + new_direction * self.distance*2, nil )



			table.insert( self.points, point )
			table.insert( self.effects, self:PlayEffects1( point, false ) )
		end
	end

	

	self:GetParent():AddNoDraw()

	if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
		self:StartIntervalThink(self:GetRemainingTime()/(10))
	end

end

function modifier_custom_void_dissimilate:OnIntervalThink()
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_custom_void_dissimilate:OnRefresh( kv )
	
end

function modifier_custom_void_dissimilate:OnRemoved()
end

function modifier_custom_void_dissimilate:OnDestroy()
if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 
	

		for i = 0,self:GetParent():GetAbilityCount()-1 do
   	 		local ability = self:GetParent():GetAbilityByIndex(i)
   	 		if ability then 
    			ability:SetActivated(true)
    		end
		end


		local ability_cancel = self:GetCaster():FindAbilityByName("void_spirit_dissimilate_custom_cancel")


		self:GetAbility():SetHidden(false)
		ability_cancel:SetHidden(true)

		self:GetCaster():SwapAbilities("void_spirit_dissimilate_custom_cancel", "void_spirit_dissimilate_custom", false, true)

	end



	for _,effect in pairs(self.effects) do 
		ParticleManager:DestroyParticle(effect, true)
		ParticleManager:ReleaseParticleIndex(effect)
	end

	local point = self.points[self.selected]

	-- move parent

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	if #enemies == 0 and self:GetParent():HasModifier("modifier_void_astral_2") then 
		local cd = self:GetAbility():GetCooldownTimeRemaining()
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(cd + self:GetAbility().cd[self:GetParent():GetUpgradeStack("modifier_void_astral_2")])

	end


	local damage = self:GetAbility():GetAbilityDamage()
	if self:GetParent():HasShard() then 
		damage = damage + self:GetAbility():GetSpecialValueFor("shard_bonus_damage")
	end

	if self:GetParent():HasModifier("modifier_void_astral_1") and self:GetParent():GetAbsOrigin() == point then 
		damage = damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_void_astral_1")
	end


	FindClearSpaceForUnit( self:GetParent(), point, true )


	if self:GetStackCount() > 0 then 
		damage = damage*(1 + ((self:GetAbility().legendary_damage/10)*self:GetStackCount())/100)
	end

	for _,thinker in pairs(self.thinkers) do 
		if thinker and thinker:GetAbsOrigin() == point and self:GetParent():HasModifier("modifier_void_astral_6") then 
			local mod = thinker:FindModifierByName("modifier_custom_void_dissimilate_slow_thinker")
			if mod then 
				mod:SetDuration(self:GetAbility().resist_duration, true)
			end
		else 
			UTIL_Remove( thinker )
		end
	end

	if self:GetParent():HasModifier("modifier_void_astral_6") then 
		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_resist_tracker", {duration = self:GetAbility().resist_duration, radius = self.radius}, point, self:GetCaster():GetTeamNumber(), false)
	end	




	-- precache damage




	for _,enemy in pairs(enemies) do

		local deal_damage = damage
		if enemy:IsBuilding() then 
			deal_damage = deal_damage*self:GetAbility():GetSpecialValueFor("building_damage")/100
		end

		local damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage = deal_damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
		}

		ApplyDamage(damageTable)
		

		if false and self:GetParent():HasModifier("modifier_void_astral_3") then 
			local burn = damage*(self:GetAbility().burn_init + self:GetAbility().burn_inc*self:GetCaster():GetUpgradeStack("modifier_void_astral_3"))
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_burn", {damage = burn, duration = self:GetAbility().burn_duration}) 
		end

		if self:GetParent():HasModifier("modifier_void_astral_5") then 
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().stun_duration})
		end		
	end

	if self:GetParent():HasModifier("modifier_void_astral_4") then 
		local damage_exit = damage*self:GetAbility().exit_damage[self:GetParent():GetUpgradeStack("modifier_void_astral_4")]

		CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_void_dissimilate_exit", {damage = damage_exit, duration = self:GetAbility().exit_delay, radius = self.target_radius}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end

	-- nodraw
	self:GetParent():RemoveNoDraw()

	self:PlayEffects2( point, #enemies )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_custom_void_dissimilate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_custom_void_dissimilate:OnOrder( params )
	if params.unit~=self:GetParent() then return end


	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end

	if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
		--self:Destroy()
	end
end

function modifier_custom_void_dissimilate:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_custom_void_dissimilate:CheckState()
local state = {}

if self:GetCaster():HasModifier("modifier_void_astral_legendary") then 
	state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}


else 
	state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}



end

	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_custom_void_dissimilate:SetValidTarget( location )
	-- find max
	local max_dist = (location-self.points[1]):Length2D()
	local max_point = 1
	for i,point in ipairs(self.points) do
		local dist = (location-point):Length2D()
		if dist<max_dist then
			max_dist = dist
			max_point = i
		end
	end

	-- select
	local old_select = self.selected
	self.selected = max_point

	-- change effects
	self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_dissimilate:PlayEffects1( point, main )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Portals"

	if self:GetParent():HasModifier("modifier_void_astral_legendary") then 
		particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_2.vpcf"
	end
	-- adjustments
	local radius = self.radius + 25

	-- Create Particle for this team
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )

	if main then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Play Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return effect_cast
end

function modifier_custom_void_dissimilate:ChangeEffects( old, new )
	ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_custom_void_dissimilate:PlayEffects2( point, hit )
	


	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"
	local sound_hit = "Hero_VoidSpirit.Dissimilate.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.target_radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	self:GetParent():EmitSound(sound_cast)
	
	if hit>0 then
		self:GetParent():EmitSound(sound_hit)
	end
end







modifier_custom_void_dissimilate_slow_thinker = class({})

function modifier_custom_void_dissimilate_slow_thinker:IsHidden() return true end

function modifier_custom_void_dissimilate_slow_thinker:IsPurgable() return false end

function modifier_custom_void_dissimilate_slow_thinker:IsAura() return true end

function modifier_custom_void_dissimilate_slow_thinker:GetAuraDuration() return 0.2 end


function modifier_custom_void_dissimilate_slow_thinker:GetAuraRadius() return self.radius
end

function modifier_custom_void_dissimilate_slow_thinker:OnCreated(table)
self.radius = table.radius
end


function modifier_custom_void_dissimilate_slow_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_custom_void_dissimilate_slow_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO +  DOTA_UNIT_TARGET_BASIC end

function modifier_custom_void_dissimilate_slow_thinker:GetModifierAura() return "modifier_custom_void_dissimilate_slow" end



modifier_custom_void_dissimilate_slow = class({})

function modifier_custom_void_dissimilate_slow:IsPurgable() return false end

function modifier_custom_void_dissimilate_slow:IsHidden() return false end 
function modifier_custom_void_dissimilate_slow:IsDebuff() return true end
function modifier_custom_void_dissimilate_slow:GetTexture() return "buffs/astral_slow" end


function modifier_custom_void_dissimilate_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_custom_void_dissimilate_slow:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}

end
function modifier_custom_void_dissimilate_slow:GetModifierMagicalResistanceBonus()
return 
self:GetAbility().portal_magic[self:GetCaster():GetUpgradeStack("modifier_void_astral_3")]
end


function modifier_custom_void_dissimilate_slow:GetModifierMoveSpeedBonus_Percentage() 
return 
self:GetAbility().portal_slow[self:GetCaster():GetUpgradeStack("modifier_void_astral_3")]
end




modifier_custom_void_dissimilate_resist_tracker = class({})

function modifier_custom_void_dissimilate_resist_tracker:IsHidden() return true end

function modifier_custom_void_dissimilate_resist_tracker:IsPurgable() return false end

function modifier_custom_void_dissimilate_resist_tracker:IsAura() return true end

function modifier_custom_void_dissimilate_resist_tracker:GetAuraDuration() return 0.1 end


function modifier_custom_void_dissimilate_resist_tracker:GetAuraRadius() return self.radius
end

function modifier_custom_void_dissimilate_resist_tracker:OnCreated(table)
self.radius = table.radius

if not IsServer() then return end
particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_52.vpcf"

local radius = self.radius + 25


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )


self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


function modifier_custom_void_dissimilate_resist_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 end

function modifier_custom_void_dissimilate_resist_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_custom_void_dissimilate_resist_tracker:GetModifierAura() return "modifier_custom_void_dissimilate_resist" end





modifier_custom_void_dissimilate_resist = class({})

function modifier_custom_void_dissimilate_resist:IsPurgable() return false end

function modifier_custom_void_dissimilate_resist:IsHidden() return false end 
function modifier_custom_void_dissimilate_resist:GetTexture() return "buffs/astral_resist" end
function modifier_custom_void_dissimilate_resist:GetEffectName()
	return "particles/units/heroes/hero_vengeful/void_astral_resist.vpcf"
end

function modifier_custom_void_dissimilate_resist:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



function modifier_custom_void_dissimilate_resist:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end
function modifier_custom_void_dissimilate_resist:GetModifierIncomingDamage_Percentage()
return 
self:GetAbility().resist_damage
end



modifier_custom_void_dissimilate_burn = class({})
function modifier_custom_void_dissimilate_burn:IsHidden() return false end
function modifier_custom_void_dissimilate_burn:IsPurgable() return true end
function modifier_custom_void_dissimilate_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_void_dissimilate_burn:GetTexture() return "buffs/astral_burn" end
function modifier_custom_void_dissimilate_burn:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage/self:GetAbility().burn_interval
self:StartIntervalThink(self:GetAbility().burn_interval)
end

function modifier_custom_void_dissimilate_burn:OnIntervalThink()
if not IsServer() then return end

    local damageTable = {
      victim      = self:GetParent(),
      damage      = self.damage,
      damage_type   = DAMAGE_TYPE_MAGICAL,
      damage_flags  = DOTA_DAMAGE_FLAG_NONE,
      attacker    = self:GetCaster(),
      ability     = self:GetAbility()
    }

    ApplyDamage(damageTable)

	local trail_pfx = ParticleManager:CreateParticle("particles/void_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
 	ParticleManager:ReleaseParticleIndex(trail_pfx)

    SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

end




void_spirit_dissimilate_custom_cancel = class({})


function void_spirit_dissimilate_custom_cancel:OnSpellStart()
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_custom_void_dissimilate")

if not mod then return end

mod:Destroy()

end




modifier_custom_void_dissimilate_exit = class({})
function modifier_custom_void_dissimilate_exit:IsHidden() return false end
function modifier_custom_void_dissimilate_exit:IsPurgable() return false end
function modifier_custom_void_dissimilate_exit:OnCreated(table)
if not IsServer() then return end
self.radius = table.radius
self.damage = table.damage
end


function modifier_custom_void_dissimilate_exit:OnDestroy()
if not IsServer() then return end

local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
for _,enemy in pairs(enemies) do 


	local damage = self.damage
	if enemy:IsBuilding() then 
		damage = damage*self:GetAbility():GetSpecialValueFor("building_damage")/100
	end

	self.damageTable = {
		victim = enemy,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	ApplyDamage(self.damageTable)
end




local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN,nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound(sound_cast)
	

end