LinkLuaModifier("modifier_troll_warlord_battle_trance_custom", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_debuff", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_tracker", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_slow", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_block", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)



troll_warlord_battle_trance_custom = class({})

troll_warlord_battle_trance_custom.duration_init = 0
troll_warlord_battle_trance_custom.duration_inc = 0.5

troll_warlord_battle_trance_custom.resist_init = 0
troll_warlord_battle_trance_custom.resist_inc = 10

troll_warlord_battle_trance_custom.slow_init = -20
troll_warlord_battle_trance_custom.slow_inc = -20
troll_warlord_battle_trance_custom.slow_damage_init = 5
troll_warlord_battle_trance_custom.slow_damage_inc = 10
troll_warlord_battle_trance_custom.slow_range = 600
troll_warlord_battle_trance_custom.slow_duration = 4

troll_warlord_battle_trance_custom.lowhp_heal = 0.3

troll_warlord_battle_trance_custom.legendary_cd = 30
troll_warlord_battle_trance_custom.legendary_range = 600
troll_warlord_battle_trance_custom.legendary_duration = 3

troll_warlord_battle_trance_custom.cd = {0.1 , 0.2, 0.3}


function troll_warlord_battle_trance_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_battle_trance_custom_tracker"
end

function troll_warlord_battle_trance_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_troll_trance_legendary") then 
	return self.legendary_range
end 
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end





function troll_warlord_battle_trance_custom:GetCooldown(iLevel)

local k = 1
if self:GetCaster():HasModifier("modifier_troll_trance_3") then 
	k = k - self.cd[self:GetCaster():GetUpgradeStack("modifier_troll_trance_3")]
end

if self:GetCaster():HasModifier("modifier_troll_trance_legendary") then  
  return self.legendary_cd*k
end

 return self.BaseClass.GetCooldown(self, iLevel)*k
 
end



function troll_warlord_battle_trance_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_troll_trance_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end



function troll_warlord_battle_trance_custom:OnSpellStart()
	if not IsServer() then return end


	local target = nil
	if self:GetCursorTarget() ~= nil then 
		target = self:GetCursorTarget()
	end

	local trance_duration	= self:GetSpecialValueFor("trance_duration")

	if target ~= self:GetCaster() and target ~= nil then 
		trance_duration = self.legendary_duration
	end

	if self:GetCaster():HasModifier("modifier_troll_trance_1") then 
		trance_duration = trance_duration + self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_troll_trance_1")
	end

	if self:GetCaster():HasModifier("modifier_troll_trance_6") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom_block", {duration = trance_duration})
	end

	self:GetCaster():EmitSound("Hero_TrollWarlord.BattleTrance.Cast")

	if target == nil or target == self:GetCaster() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom", {duration = trance_duration})
		self:GetCaster():Purge(false, true, false, false, false)
	else
		if not target:TriggerSpellAbsorb(self) then 

			target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom", {duration = trance_duration})
		end
	end


	local cast_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(cast_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(cast_pfx)
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

	if self:GetCaster():HasModifier("modifier_troll_trance_4") then 
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.slow_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,enemy in pairs(enemies) do 
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom_slow", {duration = (1 - enemy:GetStatusResistance())*self.slow_duration})
		end
	end

end

modifier_troll_warlord_battle_trance_custom = class({})

function modifier_troll_warlord_battle_trance_custom:IsPurgable()	return false end

function modifier_troll_warlord_battle_trance_custom:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_troll_warlord_battle_trance_custom:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetParent()
	self.parent		= self:GetParent()
	self.lifesteal		= self.ability:GetSpecialValueFor("lifesteal") / 100
	self.attack_speed	= self.ability:GetSpecialValueFor("attack_speed")
	self.movement_speed	= self.ability:GetSpecialValueFor("movement_speed")
	self.range			= self.ability:GetSpecialValueFor("range")
	if not IsServer() then return end
	self.target = nil
	self.RemoveForDuel = true
	self:OnIntervalThink()
	self:StartIntervalThink(0.1)
end

function modifier_troll_warlord_battle_trance_custom:OnIntervalThink()
	if not IsServer() then return end



	if self.target and not self.target:IsNull() and not self.target:IsAttackImmune() and self.target:IsAlive() and not self.target:IsInvulnerable() and self.caster:CanEntityBeSeenByMyTeam(self.target) then
		self.caster:MoveToTargetToAttack(self.target)
		if not self.target:HasModifier("modifier_troll_warlord_battle_trance_custom_debuff") and (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() <= self.range then
			self.target:AddNewModifier(self.caster, self.ability, "modifier_troll_warlord_battle_trance_custom_debuff", {})
		elseif self.target:HasModifier("modifier_troll_warlord_battle_trance_custom_debuff") and (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.range then
			self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
		end
		return
	elseif self.target and not self.target:IsNull() and self.target:HasModifier("modifier_troll_warlord_battle_trance_custom_debuff") then
		self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
	end
	self.caster:MoveToTargetToAttack(self.target)
	if self.caster:GetAttackTarget() and (self.target and not self.target:IsNull() and self.target:IsAlive() and not self.target:IsAttackImmune()) and  self.caster:GetAttackTarget():IsAlive() and not self.caster:GetAttackTarget():IsInvulnerable() and self.caster:CanEntityBeSeenByMyTeam(self.caster:GetAttackTarget()) then
		self.target = self.caster:GetAttackTarget()
		self.caster:MoveToTargetToAttack(self.target)
		return
	end
	local hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
	if #hero_enemies > 0 then
		for enemy = 1, #hero_enemies do
			if hero_enemies[enemy] and self.caster:CanEntityBeSeenByMyTeam(hero_enemies[enemy]) and hero_enemies[enemy]:GetUnitName() ~= "npc_teleport" then
				self.caster:MoveToTargetToAttack(hero_enemies[enemy])
				self.target = hero_enemies[enemy]
				return
			end
		end
	end

	local non_hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
	if #non_hero_enemies > 0 then
		for enemy = 1, #non_hero_enemies do
			if non_hero_enemies[enemy] and self.caster:CanEntityBeSeenByMyTeam(non_hero_enemies[enemy]) and non_hero_enemies[enemy]:GetUnitName() ~= "npc_teleport" then
				self.caster:MoveToTargetToAttack(non_hero_enemies[enemy])
				self.target = non_hero_enemies[enemy]
				return
			end
		end
	end
	
	if self.target and not self.target:IsNull() then
		if self.target:HasModifier("modifier_troll_warlord_battle_trance_custom_debuff") then
			self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
		end	
		self.target	= nil
	end
end

function modifier_troll_warlord_battle_trance_custom:OnDestroy()
	if not IsServer() then return end
	if self.target and not self.target:IsNull() and self.target:HasModifier("modifier_troll_warlord_battle_trance_custom_debuff") then
		self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
	end	

	if self:GetCaster() == self:GetParent() and self:GetParent():HasModifier("modifier_troll_trance_5") then 
		local heal = self:GetAbility().lowhp_heal*self:GetParent():GetMaxHealth()

		self:GetCaster():Heal(heal, self:GetCaster())
		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end

	self:GetParent():SetForceAttackTarget(nil)
end

function modifier_troll_warlord_battle_trance_custom:GetPriority()
	return 10
end

function modifier_troll_warlord_battle_trance_custom:CheckState()
if self:GetParent() == self:GetCaster() then 

	if self:GetCaster():HasModifier("modifier_troll_trance_6") then 
		if self.target == nil then return end
		return {[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true , [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else 
		if self.target == nil then return {[MODIFIER_STATE_MUTED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
		return {[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, [MODIFIER_STATE_MUTED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	end
else 
	if self.target == nil then return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
	return {[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, [MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
end

end

function modifier_troll_warlord_battle_trance_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end


function modifier_troll_warlord_battle_trance_custom:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_troll_trance_2") and self:GetCaster() == self:GetParent() then 
	bonus = self:GetAbility().resist_init + self:GetAbility().resist_inc*self:GetCaster():GetUpgradeStack("modifier_troll_trance_2")
end

return bonus
end


function modifier_troll_warlord_battle_trance_custom:OnAttackStart(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	self.target = params.target
end

function modifier_troll_warlord_battle_trance_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_troll_warlord_battletrance.vpcf"
end

function modifier_troll_warlord_battle_trance_custom:StatusEffectPriority()
	return 10
end

function modifier_troll_warlord_battle_trance_custom:OnTakeDamage(params)
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.unit:IsBuilding() then return end
	if params.inflictor == nil then 
		local heal = params.damage*self.lifesteal
		self:GetParent():Heal(heal, self:GetAbility())
	end
end 

function modifier_troll_warlord_battle_trance_custom:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_troll_warlord_battle_trance_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_troll_warlord_battle_trance_custom:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_troll_warlord_battle_trance_custom:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
	return 1
end

modifier_troll_warlord_battle_trance_custom_debuff = class({})

function modifier_troll_warlord_battle_trance_custom_debuff:IsHidden()		return true end
function modifier_troll_warlord_battle_trance_custom_debuff:IgnoreTenacity()	return false end
function modifier_troll_warlord_battle_trance_custom_debuff:GetPriority()		return MODIFIER_PRIORITY_ULTRA end

function modifier_troll_warlord_battle_trance_custom_debuff:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_troll_warlord_battle_trance_custom_debuff:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 50, FrameTime(), true)
end


modifier_troll_warlord_battle_trance_custom_slow = class({})
function modifier_troll_warlord_battle_trance_custom_slow:IsHidden() return false end
function modifier_troll_warlord_battle_trance_custom_slow:IsPurgable() return true end
function modifier_troll_warlord_battle_trance_custom_slow:GetTexture() return "buffs/trance_slow" end


function modifier_troll_warlord_battle_trance_custom_slow:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_troll_warlord_battle_trance_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_troll_warlord_battle_trance_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_troll_trance_4")
end

function modifier_troll_warlord_battle_trance_custom_slow:GetModifierIncomingDamage_Percentage()
return self:GetAbility().slow_damage_init + self:GetAbility().slow_damage_inc*self:GetCaster():GetUpgradeStack("modifier_troll_trance_4")
end

modifier_troll_warlord_battle_trance_custom_tracker = class({})
function modifier_troll_warlord_battle_trance_custom_tracker:IsHidden() return true end
function modifier_troll_warlord_battle_trance_custom_tracker:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_troll_warlord_battle_trance_custom_tracker:GetMinHealth()
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetParent():HasModifier("modifier_troll_trance_5") then return end
if not self:GetAbility():IsFullyCastable() then return end
return 1
end

function modifier_troll_warlord_battle_trance_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():HasModifier("modifier_troll_trance_5") then return end
if self:GetParent():GetHealth() > 1 then return end
if not self:GetAbility():IsFullyCastable() then return end

self:GetParent():CastAbilityNoTarget(self:GetAbility(), 1)

end




modifier_troll_warlord_battle_trance_custom_block = class({})
function modifier_troll_warlord_battle_trance_custom_block:IsHidden() return false end
function modifier_troll_warlord_battle_trance_custom_block:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_block:GetTexture() return "buffs/trance_block" end

function modifier_troll_warlord_battle_trance_custom_block:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/qop_linken_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)


end

function modifier_troll_warlord_battle_trance_custom_block:OnDestroy()
if not IsServer() then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

end


function modifier_troll_warlord_battle_trance_custom_block:DeclareFunctions()
return
{
MODIFIER_PROPERTY_ABSORB_SPELL
}
end

function modifier_troll_warlord_battle_trance_custom_block:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/qop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
self:Destroy()
return 1 
end




modifier_troll_warlord_battle_trance_custom_return = class({})
function modifier_troll_warlord_battle_trance_custom_return:IsHidden() return false end
function modifier_troll_warlord_battle_trance_custom_return:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_return:GetTexture() return "buffs/trance_return" end
function modifier_troll_warlord_battle_trance_custom_return:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_troll_warlord_battle_trance_custom_return:OnTooltip()
return 100*(self:GetAbility().return_init + self:GetAbility().return_inc*self:GetParent():GetUpgradeStack("modifier_troll_trance_3"))
end

function modifier_troll_warlord_battle_trance_custom_return:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() == params.unit then
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

	local target = params.attacker
	local damage_return = self:GetAbility().return_init + self:GetAbility().return_inc*self:GetParent():GetUpgradeStack("modifier_troll_trance_3")
   ApplyDamage({victim = target, attacker = self:GetParent(), damage = params.original_damage*damage_return, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self:GetAbility()})


end

end

