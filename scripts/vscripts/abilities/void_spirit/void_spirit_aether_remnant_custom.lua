LinkLuaModifier("modifier_custom_void_remnant_thinker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_target", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_tracker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_lowhp_cd", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_illusion", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_damage", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_slow", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_speed", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_stats", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_absorb", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_aether_remnant_custom = class({})


void_spirit_aether_remnant_custom.damage_init = 2
void_spirit_aether_remnant_custom.damage_inc = 2

void_spirit_aether_remnant_custom.absorb_duration = 6

void_spirit_aether_remnant_custom.legendary_duration = 7
void_spirit_aether_remnant_custom.legendary_damage = -70

void_spirit_aether_remnant_custom.range_range = 450
void_spirit_aether_remnant_custom.range_speed = 200
void_spirit_aether_remnant_custom.range_delay = 0

void_spirit_aether_remnant_custom.slow_duration = 3
void_spirit_aether_remnant_custom.slow_init = -20
void_spirit_aether_remnant_custom.slow_inc = -20
void_spirit_aether_remnant_custom.slow_attack_init = 0
void_spirit_aether_remnant_custom.slow_attack_inc = -30

void_spirit_aether_remnant_custom.speed_init = 15
void_spirit_aether_remnant_custom.speed_inc = 15
void_spirit_aether_remnant_custom.speed_duration = 3

void_spirit_aether_remnant_custom.stats_duration = 8
void_spirit_aether_remnant_custom.stats_init = 0.05
void_spirit_aether_remnant_custom.stats_inc = 0.10



function void_spirit_aether_remnant_custom:Precache( context )


end









function void_spirit_aether_remnant_custom:GetCastRange(vLocation, hTarget)

local upgrade = self.range_range*self:GetCaster():GetUpgradeStack("modifier_void_remnant_5")
 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function void_spirit_aether_remnant_custom:GetIntrinsicModifierName()
return "modifier_custom_void_remnant_tracker"
end

function void_spirit_aether_remnant_custom:OnVectorCastStart(vStartLocation, vDirection)
	-- unit identifier
	local caster = self:GetCaster()


	CreateModifierThinker(
		caster, 
		self,
		"modifier_custom_void_remnant_thinker", 
		{
			dir_x = vDirection.x,
			dir_y = vDirection.y,
			dir_z = vDirection.z,
		}, 
		self:GetCursorPosition(),
		caster:GetTeamNumber(),
		false
	)


	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
	caster:EmitSound(sound_cast)
end



modifier_custom_void_remnant_thinker = class({})


local STATE_RUN = 1
local STATE_DELAY = 2
local STATE_WATCH = 3
local STATE_PULL = 4

function modifier_custom_void_remnant_thinker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
}
end
function modifier_custom_void_remnant_thinker:GetModifierProvidesFOWVision() return 1 end

function modifier_custom_void_remnant_thinker:OnCreated( kv )

	self.interval = self:GetAbility():GetSpecialValueFor( "think_interval" )
	self.delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )

	if self:GetCaster():HasModifier("modifier_void_remnant_5") then 
		self.speed = self.speed + self:GetAbility().range_speed
		self.delay = self:GetAbility().range_delay
	end	

	self.width = self:GetAbility():GetSpecialValueFor( "remnant_watch_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "remnant_watch_distance" )
	self.watch_vision = self:GetAbility():GetSpecialValueFor( "watch_path_vision_radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	self.damage = self:GetAbility():GetSpecialValueFor( "impact_damage" )
	self.pull_duration = self:GetAbility():GetSpecialValueFor( "pull_duration" )
	self.pull = self:GetAbility():GetSpecialValueFor( "pull_destination" )

	if not IsServer() then return end

	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	self.origin = self:GetParent():GetAbsOrigin()

	self.direction = Vector( kv.dir_x, kv.dir_y, kv.dir_z )

	self.target = GetGroundPosition( self.origin + self.direction * self.distance, nil )

	local run_dist = (self.origin-self:GetCaster():GetOrigin()):Length2D()
	local run_delay = run_dist/self.speed

	self.state = STATE_RUN

	self:StartIntervalThink( run_delay )
	self:PlayEffects1()
end

function modifier_custom_void_remnant_thinker:OnRefresh( kv )
	if not IsServer() then return end
	self.state = kv.state
end

function modifier_custom_void_remnant_thinker:OnRemoved()
end

function modifier_custom_void_remnant_thinker:OnDestroy()
	if not IsServer() then return end
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"
	self:GetParent():StopSound( sound_cast )
	self:PlayEffects5()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_custom_void_remnant_thinker:OnIntervalThink()
	if self.state == STATE_RUN then
		-- change state
		self.state = STATE_DELAY
		self:StartIntervalThink( self.delay )

		-- play delay effects
		self:PlayEffects2()
		return
	elseif self.state == STATE_DELAY then
		-- change state
		self.state = STATE_WATCH
		self:StartIntervalThink( self.interval )

		-- start remnant duration
		self:SetDuration( self.duration, false )

		-- play remnant effects
		self:PlayEffects3()
		return
	elseif self.state == STATE_WATCH then
		self:WatchLogic()
	else -- self.state == STATE_PULL
		-- stop looping
		self:StartIntervalThink( -1 )
		

	end
end

function modifier_custom_void_remnant_thinker:WatchLogic()

	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, 0.1, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + self.direction*self.distance/2, self.watch_vision, 0.1, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.target, self.watch_vision, 0.1, true)

	local origin = self.origin + 150*self.direction

	local enemies = FindUnitsInLine(
		self:GetCaster():GetTeamNumber(),
		origin,	
		self.target,
		nil,	
		self.width,	
		self.abilityTargetTeam,	
		self.abilityTargetType,	
		self.abilityTargetFlags	
	)

	if #enemies==0 then return end

	local min = 999

	local min_i = 0

	for i,enemy in pairs(enemies) do 
		if enemy:HasModifier("modifier_custom_void_remnant_target") then 
			table.remove(enemies,i)
		end
	end

	if #enemies==0 then return end

	for i = 1,#enemies do
		if (enemies[i]:GetAbsOrigin() - origin):Length2D() <= min then 
			min = (enemies[i]:GetAbsOrigin() - origin):Length2D()
			min_i = i
		end
	end


	if min_i == 0 then return end

	local enemy = enemies[min_i]

	
	local agi = 0
	local str = 0
	local int = 0
	if self:GetCaster():HasModifier("modifier_void_remnant_4") then 
		if self:GetCaster():HasModifier("modifier_custom_void_remnant_stats") then 
			self:GetCaster():RemoveModifierByName("modifier_custom_void_remnant_stats")
		end
		if enemy:HasModifier("modifier_custom_void_remnant_stats") then 
			enemy:RemoveModifierByName("modifier_custom_void_remnant_stats")
		end
		local k = self:GetAbility().stats_init + self:GetAbility().stats_inc*self:GetCaster():GetUpgradeStack("modifier_void_remnant_4")

		local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"


		if enemy:IsHero() then 

 			if enemy:GetPrimaryAttribute() == 1 then  
 				agi = enemy:GetAgility()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf"
 			end

 			if enemy:GetPrimaryAttribute() == 0 then  
 				str = enemy:GetStrength()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf"
 			end

 			if enemy:GetPrimaryAttribute() == 2 then  
 				int = enemy:GetIntellect()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
 			end

 		else 
 			local random = RandomInt(1, 3)
 			if random == 1 then 
 				agi = self:GetCaster():GetAgility()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf"
 			end
 			if random == 2 then 
 				str = self:GetCaster():GetStrength()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf"
 			end
 			if random == 3 then 
 				int = self:GetCaster():GetIntellect()*k
				particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
 			end
 		end





		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt( effect_cast, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(),  true )
		ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true  )
		ParticleManager:ReleaseParticleIndex( effect_cast )

 		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_stats", {agi = agi, str = str, int = int, duration = self:GetAbility().stats_duration})
		
 		if enemy:IsHero() then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_stats", {agi = -agi, str = -str, int = -int, duration = self:GetAbility().stats_duration})
		end
	end


	local damageTable = {
		victim = enemy,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)


	-- add debuff
	enemy:AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_custom_void_remnant_target", -- modifier name
		{
			duration = self.pull_duration*(1 - enemy:GetStatusResistance()),
			pos_x = self.origin.x,
			pos_y = self.origin.y,
			pull = self.pull,
			durat = self.pull_duration
		} -- kv
	)


	if self:GetCaster():HasModifier("modifier_void_remnant_6") then 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_absorb", {duration = self:GetAbility().absorb_duration})
	end

	if self:GetCaster():HasModifier("modifier_void_remnant_legendary") then 

		local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
			outgoing_damage = -100,
			bounty_base		= 0,
			bounty_growth	= nil,
			duration		= self:GetAbility().legendary_duration
		}
		, 1, 0, false, true)
	

		for _, illusion in pairs(illusions) do
			illusion.owner = self:GetCaster()
			illusion:SetHealth(illusion:GetMaxHealth())

			for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
				if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
					illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
				end
			end
			if self:GetCaster():HasModifier("modifier_void_remnant_4") then 
				illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_custom_void_remnant_stats", {agi = agi, str = str, int = int, duration = self:GetAbility().stats_duration})
			end

			local point = enemy:GetAbsOrigin() + self.direction*100

			FindClearSpaceForUnit(illusion, point, false)
			
			local target = enemy:entindex()

			if enemy:IsAlive() then 
				illusion:SetForceAttackTarget(enemy)
			else 
				target = nil
			end

			illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_custom_void_remnant_illusion", {target = target})

		

		end
	end



	-- change remnant state
	self.state = STATE_PULL
	self:SetDuration( self.pull_duration*(1 - enemy:GetStatusResistance()), false )

	-- provides pull vision
	local direction = enemy:GetOrigin()-self.origin
	local dist = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, self.pull_duration, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + direction*dist/2, self.watch_vision, self.pull_duration, true)
	AddFOWViewer( self:GetParent():GetTeamNumber(), enemy:GetOrigin(), self.watch_vision, self.pull_duration, true)

	-- Play effects
	self:PlayEffects4( enemy )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_remnant_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant"

	-- get data
	local direction = self.origin-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )

	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin() , true)


	ParticleManager:SetParticleControl( effect_cast, 1, direction * self.speed )
	ParticleManager:SetParticleControlForward( effect_cast, 0, -direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end

function modifier_custom_void_remnant_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
		ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- store for later use
	self.effect_cast = effect_cast
end

function modifier_custom_void_remnant_thinker:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target )
	ParticleManager:SetParticleControlEnt(effect_cast, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControlForward( effect_cast, 2, self.direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	 self:GetParent():EmitSound(sound_cast)
end


function modifier_custom_void_remnant_thinker:PlayEffects4( target )
	-- Get Resources
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Triggered"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Target"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- get data
	local direction = target:GetOrigin()-self.origin
	direction.z = 0
	direction = -direction:Normalized()

	-- Create Particle

	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )

	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)

	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
	ParticleManager:SetParticleControl( effect_cast, 2, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 3, self.origin )
	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
	 target:EmitSound(sound_target)
end

function modifier_custom_void_remnant_thinker:PlayEffects5()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Destroy"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_target)
end






modifier_custom_void_remnant_target = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_void_remnant_target:IsHidden()
	return false
end

function modifier_custom_void_remnant_target:IsDebuff()
	return true
end

function modifier_custom_void_remnant_target:IsStunDebuff()
	return true
end

function modifier_custom_void_remnant_target:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_void_remnant_target:OnCreated( kv )
	-- references

	if not IsServer() then return end
	self.target = Vector( kv.pos_x, kv.pos_y, 0 )

	-- get speed
	local dist = (self:GetParent():GetOrigin()-self.target):Length2D()
	self.speed = kv.pull/100*dist/kv.durat

	self:GetParent():MoveToPosition( self.target )
end

function modifier_custom_void_remnant_target:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_custom_void_remnant_target:OnRemoved()
end

function modifier_custom_void_remnant_target:OnDestroy()
if not IsServer() then return end
	self:GetParent():Stop()

	if self:GetCaster():HasModifier("modifier_void_remnant_2") then 
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_slow", {duration = self:GetAbility().slow_duration*(1 - self:GetParent():GetStatusResistance())})
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_custom_void_remnant_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_custom_void_remnant_target:GetModifierMoveSpeed_Absolute()
	if IsServer() then return self.speed end
end



function modifier_custom_void_remnant_target:OnAttackLanded(params)
if not self:GetCaster():HasModifier("modifier_void_remnant_3") then return end
if self:GetParent() ~= params.target then return end
	
local speed = self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_void_remnant_3")

if not IsServer() then return end

params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_custom_void_remnant_speed", {speed = speed, duration = self:GetAbility().speed_duration})

end



	





--------------------------------------------------------------------------------
function modifier_custom_void_remnant_target:GetModifierIncomingDamage_Percentage()
if self:GetCaster():HasModifier("modifier_void_remnant_1") then 
	return self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_void_remnant_1")
end
return
end


function modifier_custom_void_remnant_target:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_TAUNTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true
	}

	if not self:GetParent():IsHero() then 
		state = {
			[MODIFIER_STATE_STUNNED] = true
		}
	end

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_remnant_target:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf"
end

function modifier_custom_void_remnant_target:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

modifier_custom_void_remnant_tracker = class({})
function modifier_custom_void_remnant_tracker:IsHidden() return true end
function modifier_custom_void_remnant_tracker:IsPurgable() return false end
function modifier_custom_void_remnant_tracker:DeclareFunctions()
return
{

MODIFIER_PROPERTY_ABSORB_SPELL,
}
end





function modifier_custom_void_remnant_tracker:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_remnant_6") then return end

local attacker = params.ability:GetCaster()
if not attacker then return end
if self:GetParent() == attacker then return end


if not attacker:HasModifier("modifier_custom_void_remnant_absorb") then return end


attacker:RemoveModifierByName("modifier_custom_void_remnant_absorb")
--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_lowhp_cd", {duration = self:GetAbility().lowhp_cd})
--local caster = self:GetParent()

--local caster_dir = (attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()

--local point = attacker:GetAbsOrigin() + caster_dir*self:GetAbility().lowhp_range

--local direction = (attacker:GetAbsOrigin() - point):Normalized()

--CreateModifierThinker(
	--caster, 
	--self:GetAbility(),
--	"modifier_custom_void_remnant_thinker", 
	--{
	--	dir_x = direction.x,
	--	dir_y = direction.y,
	--	dir_z = direction.z,
	--}, 
	--point,
	--caster:GetTeamNumber(),
--	false
--)


--local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
--caster:EmitSound(sound_cast)

local particle = ParticleManager:CreateParticle("particles/void_linkenqop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)
self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
return 1
end



modifier_custom_void_remnant_lowhp_cd = class({})
function modifier_custom_void_remnant_lowhp_cd:IsHidden() return false end
function modifier_custom_void_remnant_lowhp_cd:IsPurgable() return false end
function modifier_custom_void_remnant_lowhp_cd:IsDebuff() return true end
function modifier_custom_void_remnant_lowhp_cd:RemoveOnDeath() return false end
function modifier_custom_void_remnant_lowhp_cd:GetTexture() return "buffs/remnant_lowhp" end
function modifier_custom_void_remnant_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_void_remnant_illusion = class({})
function modifier_custom_void_remnant_illusion:IsHidden() return true end
function modifier_custom_void_remnant_illusion:IsPurgable() return false end
function modifier_custom_void_remnant_illusion:GetStatusEffectName() return "particles/void_step_texture.vpcf" end


function modifier_custom_void_remnant_illusion:StatusEffectPriority()
    return 99999
end

function modifier_custom_void_remnant_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}

end
function modifier_custom_void_remnant_illusion:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_DEATH
}

end

function modifier_custom_void_remnant_illusion:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent().owner == nil then return end

local mod = self:GetParent().owner:AddNewModifier(self:GetParent().owner, self:GetAbility(), "modifier_custom_void_remnant_damage", {})
self:GetParent().owner:PerformAttack(params.target, false, true, true, false, false, false, true)
if mod then
	mod:Destroy()
end


end

function modifier_custom_void_remnant_illusion:OnCreated(table)
if not IsServer() then return end
if table.target == nil then 
	self.target = nil
else 
	self.target = EntIndexToHScript(table.target)
end

end

function modifier_custom_void_remnant_illusion:OnDeath(params)
if not IsServer() then return end
if self.target == nil then return end

if self.target ~= params.unit then return end
--self:GetParent():ForceKill(false)
self:GetParent():SetForceAttackTarget(nil)

end


modifier_custom_void_remnant_damage = class({})
function modifier_custom_void_remnant_damage:IsHidden() return true end
function modifier_custom_void_remnant_damage:IsPurgable() return false end
function modifier_custom_void_remnant_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_custom_void_remnant_damage:GetModifierDamageOutgoing_Percentage()
return self:GetAbility().legendary_damage
end



modifier_custom_void_remnant_slow = class({})
function modifier_custom_void_remnant_slow:IsHidden() return false end
function modifier_custom_void_remnant_slow:IsPurgable() return true end
function modifier_custom_void_remnant_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end
function modifier_custom_void_remnant_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_void_remnant_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_void_remnant_2")
end 

function modifier_custom_void_remnant_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_attack_init + self:GetAbility().slow_attack_inc*self:GetCaster():GetUpgradeStack("modifier_void_remnant_2")
end 




modifier_custom_void_remnant_speed = class({})

function modifier_custom_void_remnant_speed:IsHidden() return false end
function modifier_custom_void_remnant_speed:IsPurgable() return true end
function modifier_custom_void_remnant_speed:GetTexture() return "buffs/image_stack" end

function modifier_custom_void_remnant_speed:OnCreated(table)
if not IsServer() then return end

 self:SetHasCustomTransmitterData(true)
self.speed = table.speed
end
function modifier_custom_void_remnant_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end
function modifier_custom_void_remnant_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



function modifier_custom_void_remnant_speed:AddCustomTransmitterData() return {
speed = self.speed,

} end

function modifier_custom_void_remnant_speed:HandleCustomTransmitterData(data)
self.speed = data.speed
end


modifier_custom_void_remnant_stats = class({})

function modifier_custom_void_remnant_stats:IsHidden() return false end
function modifier_custom_void_remnant_stats:IsPurgable() return false end
function modifier_custom_void_remnant_stats:GetTexture()
if self.agi ~= 0 then 
	return "buffs/remnant_agi" 
end
if self.str ~= 0 then 
	return "buffs/remnant_str" 
end
if self.int ~= 0 then 
	return "buffs/remnant_int" 
end

end

function modifier_custom_void_remnant_stats:OnCreated(table)
if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
self.agi = table.agi
self.str = table.str
self.int = table.int 

if self.agi ~= 0 then 
	self:SetStackCount(math.abs(self.agi))
end
if self.str ~= 0 then 
	self:SetStackCount(math.abs(self.str))
end
if self.int ~= 0 then 
	self:SetStackCount(math.abs(self.int))
end


end

function modifier_custom_void_remnant_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end
function modifier_custom_void_remnant_stats:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,

} end

function modifier_custom_void_remnant_stats:HandleCustomTransmitterData(data)
self.agi = data.agi
self.int = data.int
self.str = data.str
end



function modifier_custom_void_remnant_stats:GetModifierBonusStats_Agility() 
return self.agi 
end
function modifier_custom_void_remnant_stats:GetModifierBonusStats_Strength() 
return self.str
end
function modifier_custom_void_remnant_stats:GetModifierBonusStats_Intellect()
return self.int
end


modifier_custom_void_remnant_absorb = class({})
function modifier_custom_void_remnant_absorb:IsHidden() return false end
function modifier_custom_void_remnant_absorb:IsPurgable() return false end
function modifier_custom_void_remnant_absorb:GetTexture() return "buffs/remnant_lowhp" end