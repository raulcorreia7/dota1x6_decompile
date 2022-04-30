LinkLuaModifier( "modifier_ogre_magi_fireblast_tracker", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_fire", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_lowhp_cd", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_knockback", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_ogre_magi_fireblast_speed", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_HORIZONTAL )



ogre_magi_fireblast_custom = class({})

ogre_magi_fireblast_custom.damage_bonus = {30,60,90}

ogre_magi_fireblast_custom.heal = {0.1, 0.2, 0.3}
ogre_magi_fireblast_custom.heal_mana = 0.5
ogre_magi_fireblast_custom.heal_creeps = 0.33

ogre_magi_fireblast_custom.speed_bonus = {3,4,5}
ogre_magi_fireblast_custom.speed_duration = 10
ogre_magi_fireblast_custom.speed_max = 5

ogre_magi_fireblast_custom.legendary_range = 900
ogre_magi_fireblast_custom.legendary_speed = 1600
ogre_magi_fireblast_custom.legendary_width = 150
ogre_magi_fireblast_custom.legendary_radius = 250
ogre_magi_fireblast_custom.legendary_damage = 0.3
ogre_magi_fireblast_custom.legendary_creep = 0.5

ogre_magi_fireblast_custom.fire_duration = 10
ogre_magi_fireblast_custom.fire_interval = 1
ogre_magi_fireblast_custom.fire_damage = {25, 40}
ogre_magi_fireblast_custom.fire_chance = 50
ogre_magi_fireblast_custom.fire_max = 5

ogre_magi_fireblast_custom.lowhp_cd = 40
ogre_magi_fireblast_custom.lowhp_range = 700
ogre_magi_fireblast_custom.lowhp_health = 30
ogre_magi_fireblast_custom.knockback_duration = 0.5
ogre_magi_fireblast_custom.knockback_distance = 600

ogre_magi_fireblast_custom.fullhp_health = 80
ogre_magi_fireblast_custom.fullhp_cd = 1.5

ogre_magi_unrefined_fireblast_custom = class({})
ogre_magi_unrefined_fireblast_custom.legendary_range = 900
ogre_magi_unrefined_fireblast_custom.legendary_creep = 0.5


function ogre_magi_fireblast_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_fireblast_tracker"
end

function ogre_magi_fireblast_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then
    return  DOTA_ABILITY_BEHAVIOR_POINT
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end


function ogre_magi_fireblast_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_ogremagi_blast_5") and self:GetCaster():GetHealthPercent() >= self.fullhp_health then 
  upgrade_cooldown = self.fullhp_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
 end


function ogre_magi_fireblast_custom:GetCastRange(vLocation, hTarget)


if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
	
	if IsClient() then 
		return self.legendary_range
	else 
		return
	end
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end


function ogre_magi_unrefined_fireblast_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then
    return  DOTA_ABILITY_BEHAVIOR_POINT
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end



function ogre_magi_unrefined_fireblast_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
	
	if IsClient() then 
		return self.legendary_range
	else 
		return
	end
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end











function ogre_magi_fireblast_custom:Impact(target, debuff, dont_stun)
if not IsServer() then return end

if debuff then 
	local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
	target:AddNewModifier( self:GetCaster(), ability,  "modifier_ogre_magi_multicast_custom_proc_damage",  {duration = ability.proc_damage_duration * ( 1 - target:GetStatusResistance() )} )
end

local duration = self:GetSpecialValueFor( "stun_duration" )

self.damage = self:GetSpecialValueFor( "fireblast_damage" )
if self:GetCaster():HasModifier("modifier_ogremagi_blast_1") then 
	self.damage = self.damage + self.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_1")]
end

if target:IsCreep() and self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
	self.damage = self.damage*self.legendary_creep
end

if target:IsBuilding() then 
	self.damage = self.damage*self:GetSpecialValueFor("building_damage")/100
end
	

if not dont_stun then 
	target:AddNewModifier( self:GetCaster(), self,  "modifier_stunned",  {duration = duration * ( 1 - target:GetStatusResistance() )} )
end



ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = self.damage, damage_type = self:GetAbilityDamageType(), ability = self } )

if self:GetCaster():HasModifier("modifier_ogremagi_blast_4") and not target:IsBuilding() then 
	if RollPseudoRandomPercentage(self.fire_chance, 548, target) then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_fireblast_fire", {duration = self.fire_duration})
	end
end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
ParticleManager:ReleaseParticleIndex( particle )
target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end



function ogre_magi_fireblast_custom:OnProjectileHit_ExtraData( target, location, data)

if not target then 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, GetGroundPosition(location, nil) )
	ParticleManager:SetParticleControl( particle, 1, GetGroundPosition(location, nil))
	ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster(location, "Hero_OgreMagi.Fireblast.Target", self:GetCaster())


	local damage = self:GetSpecialValueFor( "fireblast_damage" )
	if self:GetCaster():HasModifier("modifier_ogremagi_blast_1") then 
		damage = damage + self.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_1")]
	end
	damage = damage*self.legendary_damage


	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location, nil, self.legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	for _,unit in pairs(units) do 


		if unit:IsCreep() and self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
			damage = damage*self.legendary_creep
		end

		ApplyDamage( { victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self } )
		
		if self:GetCaster():HasModifier("modifier_ogremagi_blast_4") and not unit:IsBuilding() then 
			if RollPseudoRandomPercentage(self.fire_chance, 548, unit) then 
				unit:AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_fireblast_fire", {duration = self.fire_duration})
			end
		end

	end

return
end

local debuff = false
local dont_stun = false

if data.debuff == 1 then 
	debuff = true
end

if data.dont_stun == 1 then 
	dont_stun = true
end

self:Impact(target,debuff,dont_stun)

end


function ogre_magi_fireblast_custom:OnSpellStart(new_target, dont_stun, point)
	if not IsServer() then return end

	local target = nil 

	if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
		target = self:GetCursorPosition()
		if point ~= nil then 
			target = point
		end
	else 

		target = self:GetCursorTarget()

		if new_target ~= nil then 
			target = new_target
		end
	end



	local debuff = false
	self:GetCaster():EmitSound("Hero_OgreMagi.Fireblast.Cast")

	if self:GetCaster():HasModifier("modifier_ogre_magi_multicast_custom_proc") and new_target == nil then 
		self:GetCaster():RemoveModifierByName("modifier_ogre_magi_multicast_custom_proc")
		debuff = true
	end
		
	if self:GetCaster():HasModifier("modifier_ogremagi_blast_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_fireblast_speed", {duration = self.speed_duration})
	end	


	if self:GetCaster():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_5") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_bloodlust_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_bloodlust_custom_legendary_resist", {duration = ability.legendary_resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_2") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell_count", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 

		local caster = self:GetCaster()
		local point = target
		if point == self:GetCaster():GetAbsOrigin() then 
			point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*100
		end

		-- load data
		local radius = self.legendary_width
		local speed = self.legendary_speed
		local range = self.legendary_range
		local vision = 280

		-- get direction
		local direction = point-caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local origin = caster:GetAbsOrigin()

		origin.z = origin.z + 100

		-- linear projectile
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = origin,

			bDeleteOnHit = false,

			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC  + DOTA_UNIT_TARGET_BUILDING,

			EffectName = "particles/ogre_fireball.vpcf",
			fDistance = range,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,

			bProvidesVision = true,
			iVisionRadius = vision,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {debuff = debuff, dont_stun = dont_stun}
		}
		ProjectileManager:CreateLinearProjectile(info)


	else 


		if target:TriggerSpellAbsorb( self ) then return end
		self:Impact(target, debuff, dont_stun)

	end

end

















function ogre_magi_unrefined_fireblast_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() and self:GetCaster():GetUnitName() == "npc_dota_hero_ogre_magi" then
        self:SetHidden(false)        
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function ogre_magi_unrefined_fireblast_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end


function ogre_magi_unrefined_fireblast_custom:GetManaCost( level )
	local pct = self:GetSpecialValueFor( "scepter_mana" ) / 100
	return math.floor( self:GetCaster():GetMaxMana() * pct )
end













function ogre_magi_unrefined_fireblast_custom:Impact(target, debuff, dont_stun)
if not IsServer() then return end

if debuff then 
	local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
	target:AddNewModifier( self:GetCaster(), ability,  "modifier_ogre_magi_multicast_custom_proc_damage",  {duration = ability.proc_damage_duration * ( 1 - target:GetStatusResistance() )} )
end

local duration = self:GetSpecialValueFor( "stun_duration" )

self.damage = self:GetSpecialValueFor( "fireblast_damage" )

local main_ability = self:GetCaster():FindAbilityByName("ogre_magi_fireblast_custom")

if self:GetCaster():HasModifier("modifier_ogremagi_blast_1") then 
	self.damage = self.damage + main_ability.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_1")]
end

	

if not dont_stun then 
	target:AddNewModifier( self:GetCaster(), self,  "modifier_stunned",  {duration = duration * ( 1 - target:GetStatusResistance() )} )
end


if target:IsCreep() and self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
	self.damage = self.damage*self.legendary_creep
end

if target:IsBuilding() then 
	self.damage = self.damage*self:GetSpecialValueFor("building_damage")/100
end


local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
ParticleManager:ReleaseParticleIndex( particle )

ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = self.damage, damage_type = self:GetAbilityDamageType(), ability = self } )

if self:GetCaster():HasModifier("modifier_ogremagi_blast_4") and not target:IsBuilding() then 
	if RollPseudoRandomPercentage(main_ability.fire_chance, 548, unit) then 
		target:AddNewModifier(self:GetCaster(), main_ability, "modifier_ogre_magi_fireblast_fire", {duration = main_ability.fire_duration})
	end
end

target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end



function ogre_magi_unrefined_fireblast_custom:OnProjectileHit_ExtraData( target, location, data)

if not target then 

	local main_ability = self:GetCaster():FindAbilityByName("ogre_magi_fireblast_custom")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, GetGroundPosition(location, nil) )
	ParticleManager:SetParticleControl( particle, 1, GetGroundPosition(location, nil) )
	ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster(location, "Hero_OgreMagi.Fireblast.Target", self:GetCaster())

	local damage = self:GetSpecialValueFor( "fireblast_damage" )
	if self:GetCaster():HasModifier("modifier_ogremagi_blast_1") then 
		damage = damage + main_ability.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_1")]
	end
	damage = damage*main_ability.legendary_damage


	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location, nil, main_ability.legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	for _,unit in pairs(units) do 

		if unit:IsCreep() and self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
			damage = damage*self.legendary_creep
		end

		ApplyDamage( { victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self } )
		
		if self:GetCaster():HasModifier("modifier_ogremagi_blast_4") and not unit:IsBuilding() then 
			if RollPseudoRandomPercentage(main_ability.fire_chance, 548, unit) then 
				unit:AddNewModifier(self:GetCaster(), main_ability, "modifier_ogre_magi_fireblast_fire", {duration = main_ability.fire_duration})
			end
		end

	end


return
end

local debuff = false
local dont_stun = false

if data.debuff == 1 then 
	debuff = true
end

if data.dont_stun == 1 then 
	dont_stun = true
end

self:Impact(target,debuff,dont_stun)

end










function ogre_magi_unrefined_fireblast_custom:OnSpellStart(new_target, dont_stun, point)
if not IsServer() then return end

local main_ability = self:GetCaster():FindAbilityByName("ogre_magi_fireblast_custom")

	local target = nil 

	if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 
		target = self:GetCursorPosition()
		if point ~= nil then 
			target = point
		end
	else 

		target = self:GetCursorTarget()

		if new_target ~= nil then 
			target = new_target
		end
	end



	local debuff = false
	self:GetCaster():EmitSound("Hero_OgreMagi.Fireblast.Cast")

	if self:GetCaster():HasModifier("modifier_ogre_magi_multicast_custom_proc") and new_target == nil then 
		self:GetCaster():RemoveModifierByName("modifier_ogre_magi_multicast_custom_proc")
		debuff = true
	end
		
	if self:GetCaster():HasModifier("modifier_ogremagi_blast_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), main_ability, "modifier_ogre_magi_fireblast_speed", {duration = main_ability.speed_duration})
	end	


	if self:GetCaster():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_5") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_bloodlust_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_bloodlust_custom_legendary_resist", {duration = ability.legendary_resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_2") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell_count", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_blast_7") then 

		local caster = self:GetCaster()
		local point = target

		if point == self:GetCaster():GetAbsOrigin() then 
			point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*100
		end
		-- load data
		local radius = main_ability.legendary_width
		local speed = main_ability.legendary_speed
		local range = main_ability.legendary_range
		local vision = 280

		-- get direction
		local direction = point-caster:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		local origin = caster:GetAbsOrigin()

		origin.z = origin.z + 100

		-- linear projectile
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin = origin,

			bDeleteOnHit = false,

			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,

			EffectName = "particles/ogre_fireball_agh.vpcf",
			fDistance = range,
			fStartRadius = radius,
			fEndRadius = radius,
			vVelocity = direction * speed,

			bProvidesVision = true,
			iVisionRadius = vision,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = {debuff = debuff, dont_stun = dont_stun}
		}
		ProjectileManager:CreateLinearProjectile(info)


	else 


		if target:TriggerSpellAbsorb( self ) then return end
		self:Impact(target, debuff, dont_stun)

	end
end


















modifier_ogre_magi_fireblast_tracker = class({})
function modifier_ogre_magi_fireblast_tracker:IsHidden() 
	return not self:GetParent():HasModifier("modifier_ogremagi_blast_5") or self:GetParent():GetHealthPercent() < self:GetAbility().fullhp_health
end
function modifier_ogre_magi_fireblast_tracker:IsPurgable() return false end
function modifier_ogre_magi_fireblast_tracker:GetTexture() return "buffs/fireblast_fullhp" end
function modifier_ogre_magi_fireblast_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ogre_magi_fireblast_tracker:OnTakeDamage(params)
if not IsServer() then return end

if self:GetParent() == params.unit 
	and self:GetParent():HasModifier("modifier_ogremagi_blast_6") 
	and not self:GetParent():PassivesDisabled() 
	and not self:GetParent():HasModifier("modifier_ogre_magi_fireblast_lowhp_cd") 
	and self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health 
	and not self:GetParent():HasModifier("modifier_death") then 

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ogre_magi_fireblast_lowhp_cd", {duration = self:GetAbility().lowhp_cd})

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetParent():GetAbsOrigin(),nil,self:GetAbility().lowhp_range,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,0,0,false)

	self:GetParent():EmitSound("Ogre.Blast_knock")
 
    local particle = ParticleManager:CreateParticle("particles/ogre_knockback.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 5, self:GetCaster():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)


	for _,enemy in pairs(enemies) do
		self:GetAbility():Impact(enemy, false, false)
			
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_fireblast_knockback", {duration = self:GetAbility().knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
    			
	end



end

function modifier_ogre_magi_fireblast_tracker:OnTooltip()
return self:GetAbility().fullhp_cd
end



if self:GetCaster() ~= params.attacker then return end
if not self:GetCaster():HasModifier("modifier_ogremagi_blast_2") then return end
if not params.inflictor then return end
if params.inflictor:GetName() ~= "ogre_magi_fireblast_custom" and params.inflictor:GetName() ~= "ogre_magi_unrefined_fireblast_custom" then return end

local heal = params.damage*self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_2")]
if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().heal_creeps
end

self:GetParent():Heal(heal, self:GetParent())
self:GetParent():GiveMana(heal*self:GetAbility().heal_mana)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)



end





modifier_ogre_magi_fireblast_fire = class({})
function modifier_ogre_magi_fireblast_fire:IsHidden() return false end
function modifier_ogre_magi_fireblast_fire:IsPurgable() return true end
function modifier_ogre_magi_fireblast_fire:GetTexture() return "buffs/fireblast_fire" end
function modifier_ogre_magi_fireblast_fire:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end


function modifier_ogre_magi_fireblast_fire:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self.damage = self:GetAbility().fire_damage[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_4")]
self:GetParent():EmitSound("Ogre.Blast_fire")
self:StartIntervalThink(self:GetAbility().fire_interval)
end


function modifier_ogre_magi_fireblast_fire:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().fire_max then return end

self:IncrementStackCount()
end

function modifier_ogre_magi_fireblast_fire:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Ogre.Blast_fire")
end

function modifier_ogre_magi_fireblast_fire:OnIntervalThink()
if not IsServer() then return end

local damage = self.damage*self:GetStackCount()

ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() } )

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)
end


function modifier_ogre_magi_fireblast_fire:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_ogre_magi_fireblast_fire:OnTooltip()
return self:GetAbility().fire_damage[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_4")]*self:GetStackCount()
end


function modifier_ogre_magi_fireblast_fire:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/ogre_fire_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

if self.effect_cast then 
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end

end








modifier_ogre_magi_fireblast_lowhp_cd = class({})
function modifier_ogre_magi_fireblast_lowhp_cd:IsHidden() return false end
function modifier_ogre_magi_fireblast_lowhp_cd:IsPurgable() return false end
function modifier_ogre_magi_fireblast_lowhp_cd:RemoveOnDeath() return false end
function modifier_ogre_magi_fireblast_lowhp_cd:IsDebuff() return true end
function modifier_ogre_magi_fireblast_lowhp_cd:GetTexture() return "buffs/fireblast_lowhp" end
function modifier_ogre_magi_fireblast_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true 
end




modifier_ogre_magi_fireblast_knockback = class({})

function modifier_ogre_magi_fireblast_knockback:IsHidden() return true end

function modifier_ogre_magi_fireblast_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_ogre_magi_fireblast_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_ogre_magi_fireblast_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_ogre_magi_fireblast_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_ogre_magi_fireblast_knockback:OnDestroy()
 if not IsServer() then return end
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


modifier_ogre_magi_fireblast_speed = class({})
function modifier_ogre_magi_fireblast_speed:IsHidden() return false end
function modifier_ogre_magi_fireblast_speed:IsPurgable() return false end
function modifier_ogre_magi_fireblast_speed:GetTexture() return "buffs/chains_speed" end
function modifier_ogre_magi_fireblast_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_ogre_magi_fireblast_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()
end


function modifier_ogre_magi_fireblast_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_ogre_magi_fireblast_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_blast_3")]*self:GetStackCount()
end