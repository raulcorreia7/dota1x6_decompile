LinkLuaModifier("modifier_custom_shadowstrike_poison", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_slow", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_legendary_count", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_auto", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_auto_cd", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_auto_ready", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_auto_tracker", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_root", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_poison_heal", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowstrike_proc", "abilities/queen_of_pain/custom_queenofpain_shadow_strike", LUA_MODIFIER_MOTION_NONE)



custom_queenofpain_shadow_strike = class({})

custom_queenofpain_shadow_strike.building_damage = 0.5

custom_queenofpain_shadow_strike.damage_init = 0
custom_queenofpain_shadow_strike.damage_inc = 10

custom_queenofpain_shadow_strike.heal_init = 0
custom_queenofpain_shadow_strike.heal_inc = 10

custom_queenofpain_shadow_strike.purge_duration = 3

custom_queenofpain_shadow_strike.legendary_radius = 300

custom_queenofpain_shadow_strike.auto_cd_init = 24
custom_queenofpain_shadow_strike.auto_cd_inc = 4
custom_queenofpain_shadow_strike.auto_radius = 700
custom_queenofpain_shadow_strike.auto_damage = 1

custom_queenofpain_shadow_strike.blink_root = 1

custom_queenofpain_shadow_strike.poison_heal = -5
custom_queenofpain_shadow_strike.poison_max = 10
custom_queenofpain_shadow_strike.poison_duration = 5

custom_queenofpain_shadow_strike.proc_damage = 2
custom_queenofpain_shadow_strike.proc_lifesteal = 0.02
custom_queenofpain_shadow_strike.proc_duration = 5
custom_queenofpain_shadow_strike.proc_max_init = 0
custom_queenofpain_shadow_strike.proc_max_inc = 8


function custom_queenofpain_shadow_strike:GetIntrinsicModifierName()
return "modifier_custom_shadowstrike_auto_tracker"
end


function custom_queenofpain_shadow_strike:GetBehavior()
  if self:GetCaster():HasModifier("modifier_queen_Dagger_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 
end


function custom_queenofpain_shadow_strike:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_queen_Dagger_legendary") then 
	return self.legendary_radius
end

return 0
end

function custom_queenofpain_shadow_strike:ThrowDagger(target, sound, init_damage, root)
local caster = self:GetCaster()

if sound and sound == true then 
	caster:EmitSound("Hero_QueenOfPain.ShadowStrike")
end



local projectile_speed = self:GetSpecialValueFor("projectile_speed")

	
local projectile =
	{
		Target 				= target,
		Source 				= caster,
		Ability 			= self,
		EffectName 			= "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf",
		iMoveSpeed			= projectile_speed,
		vSourceLoc 			= caster:GetAbsOrigin(),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		flExpireTime 		= GameRules:GetGameTime() + 20,
		bProvidesVision 	= false,
		ExtraData			= {damage_multi = init_damage, root = root}
	}
	ProjectileManager:CreateTrackingProjectile(projectile)

end




function custom_queenofpain_shadow_strike:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = self:GetCursorTarget()
if new_target ~= nil then 
	target = new_target
end


caster:EmitSound("Hero_QueenOfPain.ShadowStrike")

local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(caster_pfx, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(caster_pfx, 1, target:GetAbsOrigin())
ParticleManager:SetParticleControl(caster_pfx, 3, Vector(projectile_speed, 0, 0))
ParticleManager:ReleaseParticleIndex(caster_pfx)

local root = false 	

if self:GetCaster():HasModifier("modifier_custom_blink_spell") then 
	root = true 
	self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
end


self:ThrowDagger(target,false,1,root)

if caster:HasModifier("modifier_queen_Dagger_legendary") then

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self.legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() and enemy ~= target then 
			self:ThrowDagger(enemy,false,1,root)	
		end
	end


end


end




function custom_queenofpain_shadow_strike:OnProjectileHit_ExtraData(target, location, ExtraData)
if not IsServer() then return end
if not target or target:IsMagicImmune() then return end
if target:TriggerSpellAbsorb(self) then return end
			
local caster = self:GetCaster()

local damage = self:GetSpecialValueFor("strike_damage")
local duration = self:GetSpecialValueFor("duration") + self.purge_duration*self:GetCaster():GetUpgradeStack("modifier_queen_Dagger_aoe")


if ExtraData.damage_multi then 
	damage = damage*ExtraData.damage_multi
end

if ExtraData.root and  ExtraData.root == 1  then 
	target:AddNewModifier(caster, self, "modifier_custom_shadowstrike_root", {duration = self.blink_root})	

	target:EmitSound("QoP.Blink_root")
end

if target:IsBuilding() then 
	damage = damage*self.building_damage
end

ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

target:AddNewModifier(caster, self, "modifier_custom_shadowstrike_poison", {duration = duration})

if self:GetCaster():HasModifier("modifier_queen_Dagger_legendary") then 
	target:AddNewModifier(caster, self, "modifier_custom_shadowstrike_legendary_count", {duration = duration})
else 
	target:AddNewModifier(caster, self, "modifier_custom_shadowstrike_slow", {duration = duration, new = true})

end

end


modifier_custom_shadowstrike_poison = class({})

function modifier_custom_shadowstrike_poison:IsHidden() return true end

function modifier_custom_shadowstrike_poison:IsPurgable() 
if not self:GetCaster() then return true end
if self:GetCaster():HasModifier("modifier_queen_Dagger_aoe") then 
	return false 
end
return true
end


function modifier_custom_shadowstrike_poison:GetAttributes() 
if not self:GetCaster() then return end
if self:GetCaster():HasModifier("modifier_queen_Dagger_legendary") then 
	return MODIFIER_ATTRIBUTE_MULTIPLE
else 
	return
end

end

function modifier_custom_shadowstrike_poison:OnCreated(table)
 self.RemoveForDuel = true
if not self:GetAbility() or not self:GetCaster() then return end
local parent = self:GetParent()

self.sec_damage_total = self:GetAbility():GetSpecialValueFor("duration_damage")
if self:GetCaster():HasModifier("modifier_queen_Dagger_damage") then 
	self.sec_damage_total = self.sec_damage_total + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Dagger_damage")
end


self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
	self.caster = self.caster.owner
end

self.ability = self:GetAbility()




self.damage_interval = self:GetAbility():GetSpecialValueFor("damage_interval")

self:StartIntervalThink(self.damage_interval)
end


function modifier_custom_shadowstrike_poison:OnDestroy()
if not IsServer() then return end
if not self:GetCaster() then return end
if not self.caster:HasModifier("modifier_queen_Dagger_legendary") then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_shadowstrike_legendary_count")
if not mod then return end

mod:DecrementStackCount()
if mod:GetStackCount() == 0 then 
	mod:Destroy()
end

end

function modifier_custom_shadowstrike_poison:OnIntervalThink()
if not IsServer() then return end


if self:GetCaster() and self:GetCaster():IsAlive() and not self:GetParent():IsIllusion() then 

	local heal = self:GetAbility():GetSpecialValueFor("heal")
 	if self:GetCaster():HasModifier("modifier_queen_Dagger_heal") then	
		 heal = heal + (self:GetAbility().heal_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Dagger_heal") + self:GetAbility().heal_init)
 	end

 	if self:GetParent():IsCreep() then 
 		heal = heal*self:GetAbility():GetSpecialValueFor("creep_heal")
 	end

	 local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
 	ParticleManager:ReleaseParticleIndex(trail_pfx)

 	self:GetCaster():Heal(heal, self:GetCaster())
 	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)
end

local damage = self.sec_damage_total

if self:GetParent():IsBuilding() then 
	damage = damage*self:GetAbility().building_damage
end

ApplyDamage({victim = self:GetParent(), attacker = self.caster, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), damage, nil)
end









modifier_custom_shadowstrike_slow = class({})

function modifier_custom_shadowstrike_slow:IsHidden() return false
end

function modifier_custom_shadowstrike_slow:IsPurgable() 
if not self:GetCaster() then return true end
if self:GetCaster():HasModifier("modifier_queen_Dagger_aoe") then 
	return false 
end
return true
end

function modifier_custom_shadowstrike_slow:GetTexture() return "queenofpain_shadow_strike" end


function modifier_custom_shadowstrike_slow:OnCreated(table)
 self.RemoveForDuel = true
if not table.new or table.new == false  then return end 
if not self:GetAbility() then return end

self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
	self.caster = self.caster.owner
end

self.ability = self:GetAbility()

local parent = self:GetParent()


self:SetStackCount(self:GetAbility():GetSpecialValueFor("movement_slow"))

if not self.dagger_pfx then
	self.dagger_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", PATTACH_POINT_FOLLOW, self.caster)

	for _, cp in pairs({ 0, 2, 3 }) do
		ParticleManager:SetParticleControlEnt(self.dagger_pfx, cp, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	end
	
	self:AddParticle(self.dagger_pfx, false, false, 0, true, false)
end

self:StartIntervalThink(1)
end

function modifier_custom_shadowstrike_slow:OnRefresh(table)
if table.new then 	
	self:OnCreated({new = table.new})
end
end

function modifier_custom_shadowstrike_slow:OnIntervalThink()
	self:SetStackCount(self:GetStackCount()*0.8)
end

function modifier_custom_shadowstrike_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_custom_shadowstrike_slow:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount() end



modifier_custom_shadowstrike_legendary_count = class({})
function modifier_custom_shadowstrike_legendary_count:IsHidden() return false end
function modifier_custom_shadowstrike_legendary_count:IsPurgable() 
if not self:GetCaster() then return true end
if self:GetCaster():HasModifier("modifier_queen_Dagger_aoe") then 
	return false 
end
return true
end

function modifier_custom_shadowstrike_legendary_count:OnRefresh(table)

self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")
if not IsServer() then return end
	self:IncrementStackCount()

end





function modifier_custom_shadowstrike_legendary_count:OnCreated(table)
 self.RemoveForDuel = true

if not self:GetAbility() then return end

self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
	self.caster = self.caster.owner
end

self.ability = self:GetAbility()

local parent = self:GetParent()

self:SetStackCount(1)

self.slow = self:GetAbility():GetSpecialValueFor("movement_slow")

if not self.dagger_pfx then
	self.dagger_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", PATTACH_POINT_FOLLOW, self.caster)

	for _, cp in pairs({ 0, 2, 3 }) do
		ParticleManager:SetParticleControlEnt(self.dagger_pfx, cp, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	end
	
	self:AddParticle(self.dagger_pfx, false, false, 0, true, false)
end

self:StartIntervalThink(1)
end



function modifier_custom_shadowstrike_legendary_count:OnIntervalThink()
	self.slow = self.slow*0.8
end

function modifier_custom_shadowstrike_legendary_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_custom_shadowstrike_legendary_count:GetModifierMoveSpeedBonus_Percentage() return self.slow end




















modifier_custom_shadowstrike_auto = class({})
function modifier_custom_shadowstrike_auto:IsHidden() return true end
function modifier_custom_shadowstrike_auto:IsPurgable() return false end
function modifier_custom_shadowstrike_auto:RemoveOnDeath() return false end

function modifier_custom_shadowstrike_auto:OnCreated(table)
if not IsServer() then return end
self.max = (self:GetAbility().auto_cd_init - self:GetAbility().auto_cd_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Dagger_auto"))*2

local mod = self:GetParent():FindModifierByName("modifier_custom_shadowstrike_auto_ready")
	if mod then 
		mod:Destroy()
	end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowstrike_auto_cd", {duration = self.max/2})

self.radius = self:GetAbility().auto_radius
self.damage = self:GetAbility().auto_damage

self.count = 0

self:StartIntervalThink(0.5)
end

function modifier_custom_shadowstrike_auto:OnRefresh(table)
	self:OnCreated()
end

function modifier_custom_shadowstrike_auto:OnIntervalThink()
if not IsServer() then return end

self.enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

if self.count < self.max then 
	self.count = self.count + 1
end

if self.count == self.max then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowstrike_auto_ready", {})
end


if self.count >= self.max and self:GetParent():IsAlive() and #self.enemies > 0 and self:GetAbility():GetLevel() > 0 then 
	local random = RandomInt(1, #self.enemies)
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)

	local mod = self:GetParent():FindModifierByName("modifier_custom_shadowstrike_auto_ready")
	if mod then 
		mod:Destroy()
	end

	self:GetAbility():ThrowDagger(self.enemies[random], true, self.damage, false)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowstrike_auto_cd", {duration = self.max/2})

	self.count = 0
end

end



modifier_custom_shadowstrike_auto_tracker = class({})
function modifier_custom_shadowstrike_auto_tracker:IsHidden() return true end
function modifier_custom_shadowstrike_auto_tracker:IsPurgable() return false end
function modifier_custom_shadowstrike_auto_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_custom_shadowstrike_auto_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.inflictor ~= self:GetAbility() then return end



if self:GetParent():HasModifier("modifier_queen_Dagger_poison") then	
	params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowstrike_poison_heal", {duration = self:GetAbility().poison_duration})

end

if self:GetParent():HasModifier("modifier_queen_Dagger_proc") then	
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowstrike_proc", {duration = self:GetAbility().proc_duration})

end



end

modifier_custom_shadowstrike_auto_cd = class({})
function modifier_custom_shadowstrike_auto_cd:IsHidden() return false end
function modifier_custom_shadowstrike_auto_cd:IsPurgable() return true end
function modifier_custom_shadowstrike_auto_cd:IsDebuff() return true end
function modifier_custom_shadowstrike_auto_cd:RemoveOnDeath() return false end
function modifier_custom_shadowstrike_auto_cd:GetTexture() return "buffs/qop_dagger_auto" end



modifier_custom_shadowstrike_auto_ready = class({})
function modifier_custom_shadowstrike_auto_ready:IsHidden() return false end
function modifier_custom_shadowstrike_auto_ready:IsPurgable() return true end
function modifier_custom_shadowstrike_auto_ready:RemoveOnDeath() return false end
function modifier_custom_shadowstrike_auto_ready:GetTexture() return "buffs/qop_dagger_auto" end

modifier_custom_shadowstrike_root = class({})
function modifier_custom_shadowstrike_root:IsHidden() return false end
function modifier_custom_shadowstrike_root:IsPurgable() return true end
function modifier_custom_shadowstrike_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end


modifier_custom_shadowstrike_poison_heal = class({})
function modifier_custom_shadowstrike_poison_heal:IsHidden() return false end
function modifier_custom_shadowstrike_poison_heal:IsPurgable() 
return true
end

function modifier_custom_shadowstrike_poison_heal:GetTexture() 
return "buffs/dagger_heal"
end

function modifier_custom_shadowstrike_poison_heal:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end
function modifier_custom_shadowstrike_poison_heal:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().poison_max then 
	self:IncrementStackCount()	
end

end

function modifier_custom_shadowstrike_poison_heal:DeclareFunctions()
return
{
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_custom_shadowstrike_poison_heal:GetModifierLifestealRegenAmplify_Percentage() return self:GetStackCount()*self:GetAbility().poison_heal
 end
function modifier_custom_shadowstrike_poison_heal:GetModifierHealAmplify_PercentageTarget() return self:GetStackCount()*self:GetAbility().poison_heal
 end
function modifier_custom_shadowstrike_poison_heal:GetModifierHPRegenAmplify_Percentage() return self:GetStackCount()*self:GetAbility().poison_heal end




modifier_custom_shadowstrike_proc = class({})
function modifier_custom_shadowstrike_proc:IsHidden() return false end
function modifier_custom_shadowstrike_proc:IsPurgable() return true end
function modifier_custom_shadowstrike_proc:GetTexture() return "buffs/qop_dagger_proc" end
function modifier_custom_shadowstrike_proc:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end
function modifier_custom_shadowstrike_proc:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().proc_max_init + self:GetAbility().proc_max_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Dagger_proc") then return end
self:IncrementStackCount()
end

function modifier_custom_shadowstrike_proc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_shadowstrike_proc:GetModifierSpellAmplify_Percentage() return
self:GetAbility().proc_damage*self:GetStackCount()
end

function modifier_custom_shadowstrike_proc:OnTakeDamage(param)
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent() == param.unit then return end
if bit.band(param.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if self:GetParent() == param.attacker and param.inflictor and not param.unit:IsBuilding()  then 

  	local heal = self:GetAbility().proc_lifesteal*self:GetStackCount()

    self:GetParent():Heal(param.damage * (heal), self:GetParent())
    local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )

end
end