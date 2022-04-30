LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_spell_amplify_throw", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_armor", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_damage", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_unstable_concoction_custom = class({})
alchemist_unstable_concoction_throw_custom = class({})


alchemist_unstable_concoction_throw_custom.armor = {-3, -5, -7} 
alchemist_unstable_concoction_throw_custom.armor_duration = 5

alchemist_unstable_concoction_throw_custom.heal = {0.02, 0.03, 0.04}

alchemist_unstable_concoction_throw_custom.cast_range = 200
alchemist_unstable_concoction_throw_custom.cast_speed = 15

alchemist_unstable_concoction_throw_custom.spell_damage = {5,8}
alchemist_unstable_concoction_throw_custom.spell_duration = 6

alchemist_unstable_concoction_throw_custom.dispel = 2
 
alchemist_unstable_concoction_throw_custom.legendary_reduce = -20
alchemist_unstable_concoction_throw_custom.legendary_damage = 0.4

alchemist_unstable_concoction_throw_custom.damage_duration = 5
alchemist_unstable_concoction_throw_custom.damage_tick = {40,60,80}
alchemist_unstable_concoction_throw_custom.damage_interval = 1





function alchemist_unstable_concoction_custom:OnSpellStart()
	if not IsServer() then return end


	
	local duration = self:GetSpecialValueFor( "brew_explosion" )
	self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	local ability = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_throw_custom")

	if self:GetCaster():HasModifier("modifier_alchemist_unstable_4") then 
		if self:GetCaster():HasModifier("modifier_alchemist_unstable_concoction_custom_spell_amplify_throw") then 
			self:GetCaster():RemoveModifierByName("modifier_alchemist_unstable_concoction_custom_spell_amplify_throw")
		end
	end

	self:GetCaster():AddNewModifier( self:GetCaster(), ability, "modifier_alchemist_unstable_concoction_custom", { duration = duration } )
end

function alchemist_unstable_concoction_throw_custom:GetAOERadius()
	return self:GetSpecialValueFor( "midair_explosion_radius" )
end


function alchemist_unstable_concoction_throw_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_POINT end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN 
end

function alchemist_unstable_concoction_throw_custom:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "throw_distance" )

local bonus = 0
if self:GetCaster():HasModifier("modifier_alchemist_unstable_5") then 
  bonus = self.cast_range
end

return max_dist + bonus


end



function alchemist_unstable_concoction_throw_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target
	local unit

	if self:GetCursorTarget() ~= nil then 
		target = self:GetCursorTarget()

		if new_target ~= nil then 
			target = new_target
		end
	else 
    	unit = CreateUnitByName("npc_dota_companion", self:GetCursorPosition(), false, nil, nil, 0)

    
    	unit:AddNewModifier(unit, nil, "modifier_phased", {})
    	unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    	target = unit
	end

	local mod_spell = self:GetCaster():FindModifierByName("modifier_alchemist_unstable_concoction_custom_spell_amplify_throw")
	if mod_spell then 
		mod_spell:SetDuration(self.spell_duration, true)
	end


	local max_brew = self:GetSpecialValueFor( "brew_time" )
	local projectile_speed = self:GetSpecialValueFor( "movement_speed" )
	local projectile_vision = self:GetSpecialValueFor( "vision_range" )
	local brew_time
	local stack_count
	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)

	local legendary_damage = 0

	local modifier = caster:FindModifierByName( "modifier_alchemist_unstable_concoction_custom" )
	if modifier then

		if modifier.legendary_damage ~= 0 then 
			legendary_damage = modifier.legendary_damage
		end

		brew_time = math.min( GameRules:GetGameTime()-modifier:GetCreationTime(), max_brew )
		stack_count = modifier:GetStackCount()
		modifier:Destroy()
	elseif self.reflected_brew_time then
		brew_time = self.reflected_brew_time
	elseif self.stored_brew_time then
		brew_time = self.stored_brew_time
	else
		brew_time = 0
	end



	if self:GetCaster():HasModifier("modifier_alchemist_unstable_2") then 
		local heal = self.heal[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_2")]*brew_time*self:GetCaster():GetMaxHealth()

		self:GetCaster():Heal(heal, self:GetCaster())
		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end

	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		iSourceAttachment = self:GetCaster():ScriptLookupAttachment("attach_attack3"),
		EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                         
		bVisibleToEnemies = true,                   
		bProvidesVision = true,                     
		iVisionRadius = projectile_vision,          
		iVisionTeamNumber = caster:GetTeamNumber(), 
		ExtraData = {
			brew_time = brew_time,
			stack_count = stack_count,
			legendary_damage = legendary_damage,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)
	self:GetCaster():EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
end

function alchemist_unstable_concoction_throw_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
	if not target then return end


	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)
	local brew_time = ExtraData.brew_time
	local stack_count = ExtraData.stack_count
	self.reflected_brew_time = brew_time


	self.reflected_brew_time = nil


	if target:TriggerSpellAbsorb( self ) then return end
	
	local max_brew = self:GetSpecialValueFor( "brew_time" )
	local min_stun = self:GetSpecialValueFor( "min_stun" )
	local max_stun = self:GetSpecialValueFor( "max_stun" )
	local min_damage = self:GetSpecialValueFor( "min_damage" )
	local max_damage = self:GetSpecialValueFor( "max_damage" )
	local radius = self:GetSpecialValueFor( "midair_explosion_radius" )



	local bonus_max_damage = 0



	local stun = (brew_time/max_brew)*(max_stun-min_stun) + min_stun
	local damage = (brew_time/max_brew)*(max_damage-min_damage) + min_damage

	if ExtraData.legendary_damage ~= nil then 
		damage = damage + ExtraData.legendary_damage
	end

	local flag_units = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flag_bonus = 0
	local damage_type = DAMAGE_TYPE_PHYSICAL

	local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = damage_type, ability = self, }
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, flag_units, flag_bonus, 0, false )
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		



		if self:GetCaster():HasModifier("modifier_alchemist_unstable_1") then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_unstable_concoction_custom_armor", {duration = self.armor_duration})
		end

		if self:GetCaster():HasModifier("modifier_alchemist_unstable_3") then 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_unstable_concoction_custom_damage", {duration = self.damage_duration})
		end


		if self:GetCaster():HasModifier("modifier_alchemist_unstable_6") then 
			enemy:Purge(true, false, false, false, false)
		end
		local duration = stun*(1 - enemy:GetStatusResistance())

		ApplyDamage( damageTable )
		enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )


	end
	target:EmitSound("Hero_Alchemist.UnstableConcoction.Stun")

	if target:GetName() == "npc_dota_companion" then 
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		UTIL_Remove(target)
	else 

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end


end


modifier_alchemist_unstable_concoction_custom = class({})

function modifier_alchemist_unstable_concoction_custom:IsHidden()
	return true
end

function modifier_alchemist_unstable_concoction_custom:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_custom:OnCreated( kv )
	self.min_stun = self:GetAbility():GetSpecialValueFor( "min_stun" )
	self.max_stun = self:GetAbility():GetSpecialValueFor( "max_stun" )
	self.min_damage = self:GetAbility():GetSpecialValueFor( "min_damage" )
	self.max_damage = self:GetAbility():GetSpecialValueFor( "max_damage" )
	self.move_speed = self:GetAbility():GetSpecialValueFor("movespeed")

	if self:GetCaster():HasModifier("modifier_alchemist_unstable_5") then 
		self.move_speed = self.move_speed + self:GetAbility().cast_speed
	end

	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.legendary_damage = 0

	local main_ability = self:GetParent():FindAbilityByName("alchemist_unstable_concoction_throw_custom")

	if self:GetParent():HasModifier("modifier_alchemist_unstable_legendary") then

		self.particle_ally_fx = ParticleManager:CreateParticle("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    	ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
    	self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

    end

	if not IsServer() then return end
	self:SetStackCount(1)
	self:GetParent():SwapAbilities( "alchemist_unstable_concoction_custom", "alchemist_unstable_concoction_throw_custom", false, true )
	self.tick_interval = 0.5
	self.tick = kv.duration
	self.tick_halfway = true
	self.explode = false
	self:StartIntervalThink( self.tick_interval )
	self:GetParent():EmitSound("Hero_Alchemist.UnstableConcoction.Fuse")
end

function modifier_alchemist_unstable_concoction_custom:OnDestroy()
	if not IsServer() then return end
	self:GetParent():StopSound("Hero_Alchemist.UnstableConcoction.Fuse")
	self:GetParent():SwapAbilities( "alchemist_unstable_concoction_throw_custom", "alchemist_unstable_concoction_custom", false, true )
	if not self:GetParent():IsAlive() then
		if self.explode == false then
			self:Concoction_Explode()
		end
	end
end

function modifier_alchemist_unstable_concoction_custom:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return decFuncs
end



function modifier_alchemist_unstable_concoction_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then return end
if self:GetParent() ~= params.unit then return end
if not params.attacker then return end
if params.attacker == self:GetParent() then return end

self.legendary_damage = self.legendary_damage + self:GetAbility().legendary_damage*params.original_damage


end


function modifier_alchemist_unstable_concoction_custom:GetModifierIncomingDamage_Percentage()
if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then 
	return self:GetAbility().legendary_reduce
end 
return
end







function modifier_alchemist_unstable_concoction_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end


function modifier_alchemist_unstable_concoction_custom:CheckState()
	if not self:GetCaster():HasModifier("modifier_alchemist_unstable_5") then return {} end
	return {
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,
	}
end

modifier_alchemist_unstable_concoction_custom_spell_amplify_throw = class({})

function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:IsPurgable() return false end

function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE

    } 

    return decFuncs
end


   
function modifier_alchemist_unstable_concoction_custom_spell_amplify_throw:GetModifierSpellAmplify_Percentage()
 return self:GetStackCount()*self:GetAbility().spell_damage[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_4")]/2
end
   


function modifier_alchemist_unstable_concoction_custom:OnIntervalThink()
	if not IsServer() then return end
	self.tick = self.tick - self.tick_interval

	if self:GetParent():HasModifier("modifier_alchemist_unstable_4") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_spell_amplify_throw", {})
	end

	if self:GetStackCount() < 10 then
		self:IncrementStackCount()
	end
	if self.tick>0 then

		if self:GetParent():HasModifier("modifier_alchemist_unstable_6") and self.tick == self:GetAbility().dispel then 
			self:GetParent():Purge(false, true, false, true, false)
			local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:ReleaseParticleIndex( particle )
			self:GetParent():EmitSound("Alch.Stun_purge")
		end

		self.tick_halfway = not self.tick_halfway
		local time = math.floor( self.tick )
		local mid = 1
		if self.tick_halfway then mid = 8 end
		
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, time, mid ) )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 2, 0, 0 ) )

		if time<1 then
			ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
		end

		ParticleManager:ReleaseParticleIndex( effect_cast )
		return
	end
	self:Concoction_Explode()
	self:Destroy()
end

function modifier_alchemist_unstable_concoction_custom:Concoction_Explode()
	if not IsServer() then return end


	local mod_spell = self:GetParent():FindModifierByName("modifier_alchemist_unstable_concoction_custom_spell_amplify_throw")
	if mod_spell then 
		mod_spell:SetDuration(self:GetAbility().spell_duration, true)
	end

	self.explode = true

	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)
	local damage_type = DAMAGE_TYPE_PHYSICAL

	local damageTable = { attacker = self:GetCaster(), damage = self.max_damage, damage_type = damage_type, ability = self:GetAbility(), }

	local flag_units = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flag_bonus = 0

	local radius =  self:GetAbility():GetSpecialValueFor( "midair_explosion_radius" )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, flag_units, flag_bonus, 0, false )

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		local duration = self.max_stun*(1 - enemy:GetStatusResistance())

		ApplyDamage( damageTable )
		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = duration } )
	end

	if not self:GetParent():IsInvulnerable() and self:GetParent():IsAlive() and not self:GetParent():IsMagicImmune() then
		damageTable.victim = self:GetParent()
		ApplyDamage( damageTable )
		local duration = self.max_stun*(1 - self:GetParent():GetStatusResistance())
		self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = duration } )
	end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetParent():EmitSound("Hero_Alchemist.UnstableConcoction.Stun")
end




modifier_alchemist_unstable_concoction_custom_armor = class({})
function modifier_alchemist_unstable_concoction_custom_armor:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_armor:IsPurgable() return true end
function modifier_alchemist_unstable_concoction_custom_armor:GetTexture() return "buffs/fervor_armor" end
function modifier_alchemist_unstable_concoction_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_alchemist_unstable_concoction_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetAbility().armor[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_1")]
end


function modifier_alchemist_unstable_concoction_custom_armor:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end






modifier_alchemist_unstable_concoction_custom_damage = class({})
function modifier_alchemist_unstable_concoction_custom_damage:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_damage:IsPurgable() return true end
function modifier_alchemist_unstable_concoction_custom_damage:GetTexture() return "buffs/unstable_damage" end

function modifier_alchemist_unstable_concoction_custom_damage:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_alchemist_unstable_concoction_custom_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().damage_interval)
end

function modifier_alchemist_unstable_concoction_custom_damage:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetAbility().damage_tick[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_3")]
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), victim = self:GetParent() }

ApplyDamage(damageTable)
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)
self:GetParent():EmitSound("Hero_Alchemist.AcidSpray.Damage")
end













