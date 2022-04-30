LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_thinker", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_debuff", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_trap", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_slow", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_damage", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_vision", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_speed", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_silence", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )


hoodwink_bushwhack_custom = class({})

hoodwink_bushwhack_custom.cd_init = -1
hoodwink_bushwhack_custom.cd_inc = -1

hoodwink_bushwhack_custom.damage_init = 0
hoodwink_bushwhack_custom.damage_inc = 60

hoodwink_bushwhack_custom.slow_init = -20
hoodwink_bushwhack_custom.slow_inc = -10
hoodwink_bushwhack_custom.slow_damage_init = -5
hoodwink_bushwhack_custom.slow_damage_inc = -5
hoodwink_bushwhack_custom.slow_duration = 3

hoodwink_bushwhack_custom.legendary_duration = 100
hoodwink_bushwhack_custom.legendary_radius = 400
hoodwink_bushwhack_custom.legendary_vision = 400

hoodwink_bushwhack_custom.incoming_init = 0
hoodwink_bushwhack_custom.incoming_inc = 10
hoodwink_bushwhack_custom.incoming_duration = 15
hoodwink_bushwhack_custom.incoming_max = 9

hoodwink_bushwhack_custom.vision_radius = 10 
hoodwink_bushwhack_custom.vision_duration = 40
hoodwink_bushwhack_custom.vision_speed = 15

hoodwink_bushwhack_custom.silence_duration = 2
hoodwink_bushwhack_custom.silence_mana = 25

function hoodwink_bushwhack_custom:GetAOERadius()
	return self:GetSpecialValueFor( "trap_radius" )
end


function hoodwink_bushwhack_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_hoodwink_bush_1") then 
	upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_1")
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end




function hoodwink_bushwhack_custom:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	local delay = (point-caster:GetOrigin()):Length2D()/projectile_speed
	local target = CreateModifierThinker( caster, self, "modifier_hoodwink_bushwhack_custom_thinker", { duration = delay, }, point, caster:GetTeamNumber(), false )
end

modifier_hoodwink_bushwhack_custom_thinker = class({})

function modifier_hoodwink_bushwhack_custom_thinker:IsHidden()
	return false
end

function modifier_hoodwink_bushwhack_custom_thinker:IsPurgable()
	return true
end

function modifier_hoodwink_bushwhack_custom_thinker:OnCreated( kv )
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
	self.radius = self:GetAbility():GetSpecialValueFor( "trap_radius" )
	self.location = self:GetParent():GetOrigin()

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 2, Vector( self.speed, 0, 0 ) )
	self:AddParticle( particle, false, false, -1, false, false )
	self.caster:EmitSound("Hero_Hoodwink.Bushwhack.Cast")
end

function modifier_hoodwink_bushwhack_custom_thinker:OnDestroy()
	if not IsServer() then return end
	AddFOWViewer( self.caster:GetTeamNumber(), self.location, self.radius, self.duration, false )


	if self:GetCaster():HasModifier("modifier_hoodwink_bush_legendary") then
		local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
		if #trees>0 and #enemies<1 then
			local origin = self.location
			local mytree = trees[1]
			local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
			for _,tree in pairs(trees) do
				local treedist = (tree:GetOrigin()-origin):Length2D()
				if treedist<mytreedist then
					mytree = tree
					mytreedist = treedist
				end
			end
			local tree = CreateUnitByName("npc_dota_treant_eyes", mytree:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeamNumber())
			tree:AddNewModifier(self.caster, self.ability, "modifier_hoodwink_bushwhack_custom_trap", {duration = self:GetAbility().legendary_duration, radius = self:GetAbility().legendary_radius, target = mytree:entindex()})

			self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
			self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
			return
		end
	end


	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #enemies<1 then
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.location )
		ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( particle )

		self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
		self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
		return
	end

	local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
	if #trees<1 then
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.location )
		ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( particle )

		self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
		self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
		return
	end


	self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")

	for _,enemy in pairs(enemies) do
		local origin = enemy:GetOrigin()
		local mytree = trees[1]
		local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
		for _,tree in pairs(trees) do
			local treedist = (tree:GetOrigin()-origin):Length2D()
			if treedist<mytreedist then
				mytree = tree
				mytreedist = treedist
			end
		end
		enemy:AddNewModifier( self.caster, self.ability, "modifier_hoodwink_bushwhack_custom_debuff", { duration = self.duration*(1 - enemy:GetStatusResistance()), damage = 1, tree = mytree:entindex(), }  )
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.location )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )
	self.caster:EmitSound("Hero_Hoodwink.Bushwhack.Impact")

	UTIL_Remove( self:GetParent() )
end

modifier_hoodwink_bushwhack_custom_debuff = class({})

function modifier_hoodwink_bushwhack_custom_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_bushwhack_custom_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.height = self:GetAbility():GetSpecialValueFor( "visual_height" )
	self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
	self.duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.distance = 150
	self.speed = 900
	self.interval = 0.3
	self.tick_count = self.duration / self.interval
	self.allow_damage = kv.damage



	self.damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) 

	if self:GetCaster():HasModifier("modifier_hoodwink_bush_2") then 
		self.damage = self.damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_2")
	end

	self.damage = self.damage / self.tick_count

	if not IsServer() then return end


	if self:GetCaster():HasModifier("modifier_hoodwink_bush_4") then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_damage", {duration = self:GetAbility().incoming_duration})
	end

	if self:GetCaster():HasModifier("modifier_hoodwink_bush_6") then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_vision", {duration = self:GetAbility().vision_duration})
	end

	self.tree = EntIndexToHScript( kv.tree )
	self.tree_origin = self.tree:GetOrigin()
	if not self:ApplyHorizontalMotionController() then
		return
	end
	self:StartIntervalThink( self.interval )

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( particle, 15, self.tree_origin )
	self:AddParticle( particle, false, false, -1, false, false )
	self.parent:EmitSound("Hero_Hoodwink.Bushwhack.Target")
end

function modifier_hoodwink_bushwhack_custom_debuff:OnRefresh(table)
if not IsServer() then return end


self:OnCreated(table)

end


function modifier_hoodwink_bushwhack_custom_debuff:OnDestroy()
if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )

	if self:GetCaster():HasModifier("modifier_hoodwink_bush_3") and not self:GetParent():IsMagicImmune() then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().slow_duration})
	end

	if self:GetCaster():HasModifier("modifier_hoodwink_bush_5") and not self:GetParent():IsMagicImmune() then 
		self:GetParent():EmitSound("Hoodwink.Bush_silence")
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().silence_duration})
	end



end

function modifier_hoodwink_bushwhack_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,

		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
  		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  		MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
	}

	return funcs
end

function modifier_hoodwink_bushwhack_custom_debuff:GetBonusVisionPercentage() 
 return  -100  
end
 
function modifier_hoodwink_bushwhack_custom_debuff:GetModifierNoVisionOfAttacker() 
 return  1  
 end 

function modifier_hoodwink_bushwhack_custom_debuff:GetFixedDayVision()
	return 0
end

function modifier_hoodwink_bushwhack_custom_debuff:GetFixedNightVision()
	return 0
end

function modifier_hoodwink_bushwhack_custom_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_hoodwink_bushwhack_custom_debuff:GetOverrideAnimationRate()
	return self.rate
end

function modifier_hoodwink_bushwhack_custom_debuff:GetVisualZDelta()
	return self.height
end

function modifier_hoodwink_bushwhack_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end







function modifier_hoodwink_bushwhack_custom_debuff:OnIntervalThink()
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end

	elseif not self.tree:IsStanding() then
		self:Destroy()
	end


	if self:GetCaster():HasModifier("modifier_hoodwink_bush_5") then 
		local mana = (self:GetAbility().silence_mana*self:GetParent():GetMaxMana())/(self.tick_count*100)
		self:GetParent():SpendMana(mana, self:GetAbility())

		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), mana, self:GetCaster():GetPlayerOwner() )
	
	end

	if (self.allow_damage == 0) then return end
	ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, } )
end

function modifier_hoodwink_bushwhack_custom_debuff:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local dir = self.tree_origin-origin
	local dist = dir:Length2D()
	dir.z = 0
	dir = dir:Normalized()

	if dist<self.distance then
		self:GetParent():RemoveHorizontalMotionController( self )
		local particle = ParticleManager:CreateParticle( "particles/tree_fx/tree_simple_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		return
	end

	local target = dir * self.speed*dt
	me:SetOrigin( origin + target )
end

function modifier_hoodwink_bushwhack_custom_debuff:OnHorizontalMotionInterrupted()
	self:GetParent():RemoveHorizontalMotionController( self )
end


modifier_hoodwink_bushwhack_custom_trap = class({})

function modifier_hoodwink_bushwhack_custom_trap:OnCreated(params)
    if not IsServer() then return end
    local parent = self:GetParent()
    if parent:IsNull() then return end
    self.radius = params.radius or 0
    self.target = params.target or -1
    parent:SetDayTimeVisionRange(self.radius)
    parent:SetNightTimeVisionRange(self.radius)
    self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, parent, self:GetParent():GetTeamNumber())
    ParticleManager:SetParticleControl(self.particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
    ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius,self.radius,self.radius))
    self:AddParticle(self.particle, false, false, -1, false, false)
    self.team_particles = {}
    self:StartIntervalThink(FrameTime() * 3)
end

function modifier_hoodwink_bushwhack_custom_trap:OnDestroy()
    if not IsServer() then return end
    for id, particle in pairs(self.team_particles) do
    	ParticleManager:DestroyParticle(particle, true)
    end
    self:GetParent():Destroy()
end

function modifier_hoodwink_bushwhack_custom_trap:OnIntervalThink()
    local parent = self:GetParent()
    local tree = EntIndexToHScript(self.target)

    if not tree then
        self:Destroy()
        if not parent:IsNull() then 
        	parent:ForceKill(false) 
        end

        return 
    end

    if (tree:IsNull() or parent:IsNull()) then return end


    if tree:IsNull() then
        self:Destroy()
        parent:ForceKill(false)
        return
    else
    	ParticleManager:SetParticleControl(self.particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
        AddFOWViewer(parent:GetTeamNumber(), parent:GetAbsOrigin(), self:GetAbility().legendary_vision, FrameTime() * 3, false)
    end

    for _, mod in pairs(parent:FindAllModifiersByName("modifier_truesight")) do
    	if mod and mod:GetCaster() then
    		if not self.team_particles[mod:GetCaster():GetTeamNumber()] then
    			self.team_particles[mod:GetCaster():GetTeamNumber()] = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, parent, mod:GetCaster():GetTeamNumber())
    			ParticleManager:SetParticleControl(self.team_particles[mod:GetCaster():GetTeamNumber()], 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
    			ParticleManager:SetParticleControl(self.team_particles[mod:GetCaster():GetTeamNumber()], 1, Vector(self.radius,self.radius,self.radius))
    		end
    	end
    end

    for id, particle in pairs(self.team_particles) do
    	local delete_particle = true
    	for _, mod in pairs(parent:FindAllModifiersByName("modifier_truesight")) do
    		if mod and mod:GetCaster() then
    			if id == mod:GetCaster():GetTeamNumber() then
    				delete_particle = false
    			end
    		end
    	end
    	if delete_particle then
    		ParticleManager:DestroyParticle(particle, true)
    		self.team_particles[id] = nil
    	end
    end

	local enemies = FindUnitsInRadius( parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_debuff", { duration = self:GetAbility():GetSpecialValueFor("debuff_duration")*(1 - enemy:GetStatusResistance()), tree = tree:entindex(), }  )
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil) )
		ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( particle )
		parent:EmitSound("Hero_Hoodwink.Bushwhack.Impact")
		UTIL_Remove( parent )
		break
	end
end

function modifier_hoodwink_bushwhack_custom_trap:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end




modifier_hoodwink_bushwhack_custom_slow = class({})
function modifier_hoodwink_bushwhack_custom_slow:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_slow:IsPurgable() return true end
function modifier_hoodwink_bushwhack_custom_slow:GetTexture() return "buffs/bush_slow" end
function modifier_hoodwink_bushwhack_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_hoodwink_bushwhack_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_3")
end 

function modifier_hoodwink_bushwhack_custom_slow:GetModifierTotalDamageOutgoing_Percentage()
return self:GetAbility().slow_damage_init + self:GetAbility().slow_damage_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_3")
end 



modifier_hoodwink_bushwhack_custom_damage = class({})
function modifier_hoodwink_bushwhack_custom_damage:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_damage:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_damage:GetTexture() return "buffs/bush_damage" end
function modifier_hoodwink_bushwhack_custom_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_hoodwink_bushwhack_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().incoming_max then return end
self:IncrementStackCount()
end

function modifier_hoodwink_bushwhack_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_hoodwink_bushwhack_custom_damage:GetModifierIncomingDamage_Percentage(params)
if params.attacker ~= self:GetCaster() then return end
return self:GetStackCount()*(self:GetAbility().incoming_init + self:GetAbility().incoming_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_4"))
end

function modifier_hoodwink_bushwhack_custom_damage:OnTooltip()
return self:GetStackCount()*(self:GetAbility().incoming_init + self:GetAbility().incoming_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_bush_4"))

end

function modifier_hoodwink_bushwhack_custom_damage:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/hoodwink_bush_damage.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end






modifier_hoodwink_bushwhack_custom_vision = class({})
function modifier_hoodwink_bushwhack_custom_vision:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_vision:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_vision:GetTexture() return "buffs/bush_vision" end
function modifier_hoodwink_bushwhack_custom_vision:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self.caster = self:GetCaster()

local mod = self.caster:FindModifierByName("modifier_hoodwink_bushwhack_custom_speed")

if mod and self.parent:IsRealHero() then 
	mod:IncrementStackCount()
end
if self.parent:IsHero() then 
	self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
	self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)
end

self:StartIntervalThink(FrameTime())
end

function modifier_hoodwink_bushwhack_custom_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility().vision_radius, FrameTime(), false )
end

function modifier_hoodwink_bushwhack_custom_vision:OnDestroy()
if not IsServer() then return end
local mod = self.caster:FindModifierByName("modifier_hoodwink_bushwhack_custom_speed")

if mod then 
	mod:DecrementStackCount()
end

end

modifier_hoodwink_bushwhack_custom_speed = class({})
function modifier_hoodwink_bushwhack_custom_speed:IsHidden() return self:GetStackCount() < 1
 end
function modifier_hoodwink_bushwhack_custom_speed:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_speed:RemoveOnDeath() return false end
function modifier_hoodwink_bushwhack_custom_speed:GetTexture() return "buffs/bush_vision" end


function modifier_hoodwink_bushwhack_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_hoodwink_bushwhack_custom_speed:GetModifierMoveSpeedBonus_Percentage()
if self:GetStackCount() > 0 then 
	return self:GetAbility().vision_speed
end 
return
end


modifier_hoodwink_bushwhack_custom_silence = class({})
function modifier_hoodwink_bushwhack_custom_silence:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_silence:IsPurgable() return true end
function modifier_hoodwink_bushwhack_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end


function modifier_hoodwink_bushwhack_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_hoodwink_bushwhack_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


