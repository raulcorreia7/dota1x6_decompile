LinkLuaModifier("modifier_custom_reqiuem_phase_buff", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_debuff", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_harvest", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_bkb", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_bkb_cd", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_tracker", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_legendary", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_legendary_cd", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_damage", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_auto_cd", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_magic_res", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_reqiuem_legendary_silence", "abilities/shadow_fiend/custom_nevermore_requiem", LUA_MODIFIER_MOTION_NONE)



custom_nevermore_requiem = class({})

custom_nevermore_requiem.cd_init = 0
custom_nevermore_requiem.cd_inc = 10

custom_nevermore_requiem.damage_init = 0
custom_nevermore_requiem.damage_inc = 10

custom_nevermore_requiem.bkb_cd = 15

custom_nevermore_requiem.legendary_radius = 900
custom_nevermore_requiem.legendary_cd = 15
custom_nevermore_requiem.legendary_speed = 12

custom_nevermore_requiem.heal_init = 0
custom_nevermore_requiem.heal_inc = 0.2

custom_nevermore_requiem.passive_fear = 0.2
custom_nevermore_requiem.passive_fear_max = 0.6
custom_nevermore_requiem.passive_cd = 15

custom_nevermore_requiem.proc_duration = 10
custom_nevermore_requiem.proc_init = 0
custom_nevermore_requiem.proc_inc = 10
 

function custom_nevermore_requiem:GetIntrinsicModifierName() return "modifier_custom_reqiuem_tracker" end


function custom_nevermore_requiem:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_requiem_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_requiem_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end


--function custom_nevermore_requiem:GetCastRange(vLocation, hTarget)
--if self:GetCaster():HasModifier("modifier_nevermore_requiem_legendary") and not self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary_cd")  then
 --return self.legendary_radius
--end
--end


--function custom_nevermore_requiem:GetBehavior()
 -- if self:GetCaster():HasModifier("modifier_nevermore_requiem_legendary") and not self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary_cd")  then
   -- return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end
 --return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
--end

--function custom_nevermore_requiem:CastFilterResultTarget(target)
 --if self:GetCaster():HasModifier("modifier_nevermore_requiem_legendary")  and not self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary_cd")  then

	--if target ~= nil and target:IsMagicImmune() and target ~= self:GetCaster() and not self:GetCaster():HasModifier('modifier_custom_reqiuem_cast_mod') then
	--	return UF_FAIL_MAGIC_IMMUNE_ENEMY
	--end

	--if target ~= nil and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and target ~= self:GetCaster()  then
	--	return UF_FAIL_FRIENDLY
	--end

	--if not self:GetCaster():HasModifier("modifier_custom_reqiuem_cast_mod") then 
--		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
--	else 
	--	return
	--end

--end
--end

function custom_nevermore_requiem:GetAbilityTextureName()
   return "nevermore_requiem"
end

function custom_nevermore_requiem:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_requiem:GetAssociatedSecondaryAbilities()
	return "custom_nevermore_necromastery"
end

function custom_nevermore_requiem:OnAbilityPhaseStart()

    self.sound = "Hero_Nevermore.RequiemOfSoulsCast"
    self.target = nil



	if self:GetCaster():HasModifier("modifier_nevermore_requiem_legendary") and not self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary_cd") then 

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_legendary", {duration = (self:GetCastPoint() + 0.3)})
	
	end	



	if self:GetCaster():IsInvisible() then
		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), self.sound, self:GetCaster())
	else
		self:GetCaster():EmitSound(self.sound)
	end


	self.wings_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_wings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

	-- Start cast animation
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phased", {})

	

	if not self:GetCaster():HasModifier("modifier_custom_reqiuem_bkb_cd") and self:GetCaster():HasModifier("modifier_nevermore_requiem_bkb") then 
		self:GetCaster():EmitSound("Sf.Requiem_Bkb")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_bkb", {})
	end

	return true
end

function custom_nevermore_requiem:OnAbilityPhaseInterrupted()
	-- Stop cast animation
	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_6)


	self:GetCaster():RemoveModifierByName("modifier_phased")
	self:GetCaster():StopSound(self.sound)
	
	if self.wings_particle then
		ParticleManager:DestroyParticle(self.wings_particle, true)
		ParticleManager:ReleaseParticleIndex(self.wings_particle)
	end

	if self:GetCaster():HasModifier("modifier_custom_reqiuem_bkb") then 
		self:GetCaster():RemoveModifierByName("modifier_custom_reqiuem_bkb")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_bkb_cd", {duration = self.bkb_cd})
	end

	if self:GetCaster():HasModifier("modifier_nevermore_requiem_legendary") and not self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary_cd") 
		 then 

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_legendary_cd", {duration = self.legendary_cd})

		if  self:GetCaster():HasModifier("modifier_custom_reqiuem_legendary") then
			self:GetCaster():RemoveModifierByName("modifier_custom_reqiuem_legendary")
		end

	end

end

function custom_nevermore_requiem:OnSpellStart(death_cast)	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self




	local cast_response = {"nevermore_nev_ability_requiem_01", "nevermore_nev_ability_requiem_02", "nevermore_nev_ability_requiem_03", "nevermore_nev_ability_requiem_04", "nevermore_nev_ability_requiem_05", "nevermore_nev_ability_requiem_06", "nevermore_nev_ability_requiem_07", "nevermore_nev_ability_requiem_08", "nevermore_nev_ability_requiem_11", "nevermore_nev_ability_requiem_12", "nevermore_nev_ability_requiem_13", "nevermore_nev_ability_requiem_14"}
	local sound_cast = "Hero_Nevermore.RequiemOfSouls"

	local particle_caster_souls = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_a.vpcf"
	local particle_caster_ground = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	
	if self:GetCaster():HasModifier("modifier_custom_reqiuem_bkb") then 
		self:GetCaster():RemoveModifierByName("modifier_custom_reqiuem_bkb")
	end


	local souls_per_line = ability:GetSpecialValueFor("requiem_soul_conversion")
	local travel_distance = ability:GetSpecialValueFor("requiem_radius")

	self.count = 0

	-- Play cast sound
	caster:EmitSound(sound_cast)

	if self.wings_particle then
		ParticleManager:ReleaseParticleIndex(self.wings_particle)
	end



	local particle_caster_souls_fx = ParticleManager:CreateParticle(particle_caster_souls, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 1, Vector(lines, 0, 0))
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_caster_souls_fx)

	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(lines, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)

	local modifier_souls_handler
	local stacks
	local necro_ability
	local max_souls
	local modifier_souls = "modifier_custom_necromastery_souls"

	if caster:HasModifier(modifier_souls) then
		modifier_souls_handler = caster:FindModifierByName(modifier_souls)
		if modifier_souls_handler then
			stacks = modifier_souls_handler:GetStackCount()
			necro_ability = modifier_souls_handler:GetAbility()
		max_souls = modifier_souls_handler.total_max_souls
		end
	end


	if not modifier_souls_handler then
		return nil
	end



	local line_position = caster:GetAbsOrigin() + caster:GetForwardVector() * travel_distance

	--line_position = RotatePosition(caster:GetAbsOrigin() , QAngle(0,-75,0), line_position)


	if stacks >= 1 then
		CreateRequiemSoulLine(caster, ability, line_position, death_cast)
	end

	local qangle_rotation_rate = 360 / stacks
	for i = 1, stacks - 1 do
		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(caster:GetAbsOrigin() , qangle, line_position)

		CreateRequiemSoulLine(caster, ability, line_position, death_cast)
	end


	self:GetCaster():RemoveModifierByName("modifier_phased")
end

function custom_nevermore_requiem:OnProjectileHit_ExtraData(target, location, extra_data)
	-- If there was no target, do nothing
	if not target then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	local modifier_debuff = "modifier_custom_reqiuem_debuff"
	local scepter_line = extra_data.scepter_line
	local death_cast = extra_data.death_cast
	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local slow_duration = ability:GetSpecialValueFor("requiem_slow_duration")
	local max_duration = ability:GetSpecialValueFor("requiem_slow_duration_max")

	if caster:HasModifier("modifier_nevermore_requiem_cdsoul") then 
		slow_duration = slow_duration + self.passive_fear
		max_duration = max_duration + self.passive_fear_max
	end

	local scepter_line_damage_pct = ability:GetSpecialValueFor("requiem_damage_pct_scepter")

	-- Convert from string to bool
	if scepter_line == 0 then
		scepter_line = false
	else
		scepter_line = true
	end


	if scepter_line then
		damage = damage * (scepter_line_damage_pct * 0.01)
	end
	
	target:EmitSound("Hero_Nevermore.RequiemOfSouls.Damage")
	
	local bonus = self.damage_init + self.damage_inc*caster:GetUpgradeStack("modifier_nevermore_requiem_damage") 
	-- Damage the target
	local damageTable = {victim = target,
						damage = damage + bonus,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
						}

	local damage_dealt = ApplyDamage(damageTable)
	



	-- If this line is a scepter line, heal the caster for the actual damage dealt
	if scepter_line then
		caster:Heal(damage_dealt, caster)
	end
	

	if self:GetCaster():HasModifier("modifier_nevermore_requiem_proc") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_damage", {duration = self.proc_duration})
	end

		
	if not death_cast then
		if not target:HasModifier("modifier_nevermore_requiem_fear") then
			target:AddNewModifier(self:GetCaster(), self, "modifier_nevermore_requiem_fear", {duration  = slow_duration * (1 - target:GetStatusResistance())})
			target:AddNewModifier(caster, ability, modifier_debuff, {duration = slow_duration * (1 - target:GetStatusResistance())})
		else
			target:FindModifierByName("modifier_nevermore_requiem_fear"):SetDuration(math.min(target:FindModifierByName("modifier_nevermore_requiem_fear"):GetRemainingTime() + slow_duration, max_duration) * (1 - target:GetStatusResistance()), true)
			target:FindModifierByName(modifier_debuff):SetDuration(math.min(target:FindModifierByName(modifier_debuff):GetRemainingTime() + slow_duration, max_duration) * (1 - target:GetStatusResistance()), true)

		end
	end

	Timers:CreateTimer(0.1, function()
		if self and target and not target:IsNull() and target:IsAlive() and self:GetCaster() then
			local fear_mod = target:FindModifierByName("modifier_nevermore_requiem_fear")
			if fear_mod then 
				target:AddNewModifier(self:GetCaster(), self, "modifier_custom_reqiuem_magic_res", {duration = fear_mod:GetRemainingTime()})
			end
		end
	end)
end


function CreateRequiemSoulLine(caster, ability, line_end_position, death_cast)


	local particle_lines = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
	
	if caster:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then 
		particle_lines = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf"
	end

	local scepter = caster:HasScepter()

	-- Ability specials
	local travel_distance = ability:GetSpecialValueFor("requiem_radius")
	local lines_starting_width = ability:GetSpecialValueFor("requiem_line_width_start")
	local lines_end_width = ability:GetSpecialValueFor("requiem_line_width_end")
	local lines_travel_speed = ability:GetSpecialValueFor("requiem_line_speed")

	-- Calculate the time that it would take to reach the maximum distance
	local max_distance_time = travel_distance / lines_travel_speed

	-- Calculate velocity
	local velocity = (line_end_position - caster:GetAbsOrigin()):Normalized()  * lines_travel_speed 

	-- Launch the line
	projectile_info = {Ability = ability,
					  
          			
					   vSpawnOrigin = caster:GetAbsOrigin() + (line_end_position - caster:GetAbsOrigin()):Normalized()*(105) ,
					   fDistance = travel_distance,
					   fStartRadius = lines_starting_width,
					   fEndRadius = lines_end_width,
					   Source = caster,
					   bHasFrontalCone = false,
					   bReplaceExisting = false,
					   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					   bDeleteOnHit = false,
					   vVelocity = velocity,
					   bProvidesVision = false,
					   ExtraData = {scepter_line = false, death_cast = death_cast}
					   }

	-- Create the projectile
	ProjectileManager:CreateLinearProjectile(projectile_info)

	-- Create the particle
	local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_lines_fx, 0, caster:GetAbsOrigin() + (line_end_position - caster:GetAbsOrigin()):Normalized()*(105))
    ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
	ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
	ParticleManager:ReleaseParticleIndex(particle_lines_fx)

	local origin = caster:GetAbsOrigin()
	
	if scepter and not death_cast then
		Timers:CreateTimer(max_distance_time, function()
			-- Calculate velocity
			local velocity = (origin - line_end_position):Normalized() * lines_travel_speed

			-- Launch the line
			projectile_info = {Ability = ability,
							   vSpawnOrigin = line_end_position,
							   fDistance = travel_distance,
							   fStartRadius = lines_end_width,
							   fEndRadius = lines_starting_width,
							   Source = caster,
							   bHasFrontalCone = false,
							   bReplaceExisting = false,
							   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
							   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
							   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							   bDeleteOnHit = false,
							   vVelocity = velocity,
							   bProvidesVision = false,
							   ExtraData = {scepter_line = true}
							   }

			-- Create the projectile
			ProjectileManager:CreateLinearProjectile(projectile_info)

			-- Create the particle
			local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(particle_lines_fx, 0, line_end_position)
			ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
			ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
			ParticleManager:ReleaseParticleIndex(particle_lines_fx)
		end)
	end
end




-- Requiem of Souls slow debuff
modifier_custom_reqiuem_debuff = modifier_custom_reqiuem_debuff or class({})

function modifier_custom_reqiuem_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self:GetDuration()
	self.particle_black_screen = "particles/hero/nevermore/screen_requiem_indicator.vpcf"

	
	self.ms_slow_pct = self.ability:GetSpecialValueFor("requiem_reduction_ms") 

	if IsServer() then
		self.scepter = self.caster:HasScepter()

		-- Paint the eyes of players in black if the caster has a scepter
		if self.scepter and self.parent:IsRealHero() then
			local requiem_screen_particle = ParticleManager:CreateParticleForPlayer(self.particle_black_screen, PATTACH_EYES_FOLLOW, self.parent, PlayerResource:GetPlayer(self.parent:GetPlayerID()))
			self:AddParticle(requiem_screen_particle, false, false, -1, false, false)
		end
	end
end

function modifier_custom_reqiuem_debuff:IsHidden() return false end
function modifier_custom_reqiuem_debuff:IsPurgable() return true end
function modifier_custom_reqiuem_debuff:IsDebuff() return true end

function modifier_custom_reqiuem_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end


function modifier_custom_reqiuem_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct
end



modifier_custom_reqiuem_bkb = class({})

function modifier_custom_reqiuem_bkb:IsHidden() return true end
 function modifier_custom_reqiuem_bkb:IsPurgable() return false end
 function modifier_custom_reqiuem_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true, [MODIFIER_STATE_ATTACK_IMMUNE] = true} end
 function modifier_custom_reqiuem_bkb:GetEffectName() return "particles/sf_bkb.vpcf" end

modifier_custom_reqiuem_bkb_cd = class({})

function modifier_custom_reqiuem_bkb_cd:IsHidden() return false end
 function modifier_custom_reqiuem_bkb_cd:IsPurgable() return false end
 function modifier_custom_reqiuem_bkb_cd:RemoveOnDeath() return false end
 function modifier_custom_reqiuem_bkb_cd:IsDebuff() return true end
 function modifier_custom_reqiuem_bkb_cd:GetTexture() return "buffs/requiem_cd" end
function modifier_custom_reqiuem_bkb_cd:OnCreated(table)
	self.RemoveForDuel = true
end







modifier_custom_reqiuem_tracker = class({})
function modifier_custom_reqiuem_tracker:IsHidden() return true end
function modifier_custom_reqiuem_tracker:IsPurgable() return false end
function modifier_custom_reqiuem_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_custom_reqiuem_tracker:OnAttackLanded(params)
if not IsServer() then return end

if params.attacker == self:GetParent() then 

	if not params.target:HasModifier("modifier_custom_reqiuem_damage") then return end

	local stack = params.target:FindModifierByName("modifier_custom_reqiuem_damage"):GetStackCount()
	local damage = (self:GetAbility().proc_init + self:GetAbility().proc_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_requiem_proc"))*stack

	local damageTable = {victim = params.target,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = self:GetParent(),
						ability = self:GetAbility()
						}

	local damage_dealt = ApplyDamage(damageTable)
	SendOverheadEventMessage(params.target, 4, params.target, damage, nil)

 end


if self:GetParent() ~= params.target then return end
if not self:GetParent():HasModifier("modifier_nevermore_requiem_cdsoul") then return end
if self:GetParent():HasModifier("modifier_custom_reqiuem_auto_cd") then return end
if params.attacker:IsBuilding() then return end

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_reqiuem_auto_cd", {duration = self:GetAbility().passive_cd})


	local particle_lines = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"


	local  caster = self:GetParent()
	if caster:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then 
		particle_lines = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_requiemofsouls_line.vpcf"
	end

	local travel_distance = self:GetAbility():GetSpecialValueFor("requiem_radius")
	local lines_starting_width = self:GetAbility():GetSpecialValueFor("requiem_line_width_start")
	local lines_end_width = self:GetAbility():GetSpecialValueFor("requiem_line_width_end")
	local lines_travel_speed = self:GetAbility():GetSpecialValueFor("requiem_line_speed")

	local direction =  params.attacker:GetAbsOrigin() -  self:GetParent():GetAbsOrigin() 
	direction.z = 0.0
	direction = direction:Normalized()

	local max_distance_time = travel_distance / lines_travel_speed


	-- Launch the line
	projectile_info = {Ability =  self:GetAbility(),
					  
					   vSpawnOrigin = caster:GetAbsOrigin() ,
					   fDistance = travel_distance,
					   fStartRadius = lines_starting_width,
					   fEndRadius = lines_end_width,
					   Source = caster,
					   bHasFrontalCone = false,
					   bReplaceExisting = false,
					   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					   bDeleteOnHit = false,
					   vVelocity = direction*lines_travel_speed,
					   bProvidesVision = false,
					   ExtraData = {scepter_line = false}
					   }

	-- Create the projectile
	ProjectileManager:CreateLinearProjectile(projectile_info)

	-- Create the particle
	local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_lines_fx, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl(particle_lines_fx, 1, direction*lines_travel_speed)
	ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
	ParticleManager:ReleaseParticleIndex(particle_lines_fx)


end

function modifier_custom_reqiuem_tracker:OnTakeDamage(params)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_nevermore_requiem_heal") and self:GetParent() == params.attacker 
	and params.unit:HasModifier("modifier_nevermore_requiem_fear") then 

	local heal = self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_nevermore_requiem_heal")	
	heal = heal*params.damage
	self:GetCaster():Heal(heal, self:GetAbility())

	local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )

end

end

function modifier_custom_reqiuem_tracker:OnProjectileHit(hTarget, vLocation)
if not IsServer() then return end
self:GetAbility():OnProjectileHit_ExtraData(hTarget, vLocation)
end











modifier_custom_reqiuem_legendary =  class({})

function modifier_custom_reqiuem_legendary:IgnoreTenacity()	return true end

function modifier_custom_reqiuem_legendary:GetStatusEffectName()
	return "particles/status_fx/status_effect_battle_hunger.vpcf"
end

function modifier_custom_reqiuem_legendary:OnCreated()
self.ability 			= self:GetAbility()
self.caster				= self:GetCaster()
self.parent				= self:GetParent()

self.records = {}
if not IsServer() then return end

self:StartIntervalThink(0)

self.particle = ParticleManager:CreateParticle("particles/sf_ulti_gaze_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_portrait", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 3, self.caster, PATTACH_ABSORIGIN_FOLLOW, nil, self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 10, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_custom_reqiuem_legendary:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
self:GetCaster():GetAbsOrigin(),
nil,
self:GetAbility().legendary_radius,
DOTA_UNIT_TARGET_TEAM_ENEMY,
DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
FIND_ANY_ORDER,
false)

for _,unit in pairs(enemies) do

	local add_buf = true
	for _,record in pairs(self.records) do 
		if record == unit then
			add_buf = false 
			break
		end
	end
	if add_buf == true then 
		table.insert(self.records, unit)
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_reqiuem_legendary_silence", {duration = self:GetRemainingTime()})
	end

	local vect = (unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	if (unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= 100 and unit:IsHero() and not unit:HasModifier("modifier_nevermore_requiem_fear") then 
		unit:SetAbsOrigin(unit:GetAbsOrigin() - vect*self:GetAbility().legendary_speed)
		FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
	end
end



end


modifier_custom_reqiuem_legendary_silence = class({})
function modifier_custom_reqiuem_legendary_silence:IsHidden() return false end
function modifier_custom_reqiuem_legendary_silence:IsPurgable() return true end
function modifier_custom_reqiuem_legendary_silence:OnCreated(table)
if not IsServer() then return end
self.ability 			= self:GetAbility()
self.caster				= self:GetCaster()
self.parent				= self:GetParent()
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/pudge_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	self:AddParticle(self.pfx, false, false, -1, false, false)	


	self.particle = ParticleManager:CreateParticle("particles/sf_ulti_gaze_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_portrait", self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 3, self.caster, PATTACH_ABSORIGIN_FOLLOW, nil, self.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.particle, 10, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_custom_reqiuem_legendary_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end










modifier_custom_reqiuem_legendary_cd = class({})
function modifier_custom_reqiuem_legendary_cd:IsHidden() return false end
function modifier_custom_reqiuem_legendary_cd:IsPurgable() return false end
function modifier_custom_reqiuem_legendary_cd:RemoveOnDeath() return false end
function modifier_custom_reqiuem_legendary_cd:IsDebuff() return true end
function modifier_custom_reqiuem_legendary_cd:OnCreated(table)
self.RemoveForDuel = true
end


modifier_custom_reqiuem_damage = class({})
function modifier_custom_reqiuem_damage:IsHidden() return false end
function modifier_custom_reqiuem_damage:IsPurgable() return false end
function modifier_custom_reqiuem_damage:GetTexture() return "buffs/requiem_damage" end
function modifier_custom_reqiuem_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_custom_reqiuem_damage:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

end

function modifier_custom_reqiuem_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_reqiuem_damage:OnTooltip() return
self:GetStackCount()*(self:GetAbility().proc_init + self:GetAbility().proc_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_requiem_proc"))
end




modifier_custom_reqiuem_auto_cd = class({})
function modifier_custom_reqiuem_auto_cd:IsHidden() return false end
function modifier_custom_reqiuem_auto_cd:IsPurgable() return false end
function modifier_custom_reqiuem_auto_cd:RemoveOnDeath() return false end
function modifier_custom_reqiuem_auto_cd:IsDebuff() return true end
function modifier_custom_reqiuem_auto_cd:GetTexture() return "buffs/requiem_autocd" end
function modifier_custom_reqiuem_auto_cd:OnCreated(table)
self.RemoveForDuel = true
end


modifier_custom_reqiuem_magic_res = class({})
function modifier_custom_reqiuem_magic_res:IsHidden() return true end
function modifier_custom_reqiuem_magic_res:IsPurgable() return true end
function modifier_custom_reqiuem_magic_res:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}

end

function modifier_custom_reqiuem_magic_res:OnCreated(table)
self.magic = self:GetAbility():GetSpecialValueFor("magic_res")
end

function modifier_custom_reqiuem_magic_res:GetModifierMagicalResistanceBonus()
return self.magic
end