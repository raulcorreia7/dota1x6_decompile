LinkLuaModifier("modifier_troll_warlord_fervor_custom", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_speed", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_armor", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_max", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_legendary", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_legendary_timer", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_bash", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_heal", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_attack", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_incoming", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)



troll_warlord_fervor_custom = class({})

troll_warlord_fervor_custom.heal = {0.02,0.03,0.04}
troll_warlord_fervor_custom.heal_timer = 2


troll_warlord_fervor_custom.incoming_damage = {-6,-9,-12}
troll_warlord_fervor_custom.incoming_duration = 1

troll_warlord_fervor_custom.armor_duration = 2
troll_warlord_fervor_custom.armor_max_init = 2
troll_warlord_fervor_custom.armor_max_inc = 2
troll_warlord_fervor_custom.armor_armor = -1

troll_warlord_fervor_custom.max_duration_init = 1
troll_warlord_fervor_custom.max_duration_inc = 2
troll_warlord_fervor_custom.max_bva = 1.2

troll_warlord_fervor_custom.legendary_duration = 8
troll_warlord_fervor_custom.legendary_damage_inc = 4
troll_warlord_fervor_custom.legendary_chance = 15
troll_warlord_fervor_custom.legendary_stun = 2
troll_warlord_fervor_custom.legendary_attack = 2
troll_warlord_fervor_custom.legendary_cd = 60
troll_warlord_fervor_custom.legendary_bash = 0.1

troll_warlord_fervor_custom.stack_resist = 2
troll_warlord_fervor_custom.stack_move = 2

troll_warlord_fervor_custom.first_speed = 5
troll_warlord_fervor_custom.first_hit = 2




function troll_warlord_fervor_custom:GetIntrinsicModifierName()
	return "modifier_troll_warlord_fervor_custom"
end

function troll_warlord_fervor_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_troll_fervor_legendary") then
		return self.legendary_cd
	end
	return 0
end


function troll_warlord_fervor_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_troll_fervor_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function troll_warlord_fervor_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_fervor_custom_legendary", {duration = self.legendary_duration})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_fervor_custom_legendary_timer", {duration = self.legendary_attack})
end

modifier_troll_warlord_fervor_custom = class({})

function modifier_troll_warlord_fervor_custom:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_fervor_custom:IsHidden() return true end




function modifier_troll_warlord_fervor_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end


function modifier_troll_warlord_fervor_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self.record == nil or params.record ~= self.record then return end
if params.inflictor ~= nil then return end

local heal = params.damage*self:GetAbility().bash_heal

self:GetCaster():Heal(heal, self:GetCaster())
SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )
end


function modifier_troll_warlord_fervor_custom:OnAttackLanded( params )
if not IsServer() then return end
if params.attacker~=self:GetParent() then return end



if self:GetParent():HasModifier("modifier_troll_fervor_3") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_armor", {duration = self:GetAbility().armor_duration})
end

if self:GetParent():HasModifier("modifier_troll_fervor_2") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_incoming", {duration = self:GetAbility().incoming_duration})
end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_speed", {target =  params.target:entindex(), duration = self:GetAbility():GetSpecialValueFor("duration")})
end





modifier_troll_warlord_fervor_custom_speed = class({})

function modifier_troll_warlord_fervor_custom_speed:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_speed:RemoveOnDeath() return false end
function modifier_troll_warlord_fervor_custom_speed:IsHidden() return self:GetStackCount() == 0 end

function modifier_troll_warlord_fervor_custom_speed:OnCreated(table)

self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
if not IsServer() then return end


	self:SetStackCount(0)

	if self:GetCaster():HasModifier("modifier_troll_fervor_6") then 
		self:SetStackCount(self:GetAbility().first_hit)
	end



	if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_heal") then 
		self:GetParent():RemoveModifierByName("modifier_troll_warlord_fervor_custom_heal")
	end

	self.currentTarget = table.target
end

function modifier_troll_warlord_fervor_custom_speed:OnRefresh(table)
if not IsServer() then return end
	if self.currentTarget == table.target then 
		self:MoreStack()
	else 
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
		end

		self:OnCreated(table)
	end


end


function modifier_troll_warlord_fervor_custom_speed:OnDestroy()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_troll_warlord_fervor_custom_heal") then 
	self:GetParent():RemoveModifierByName("modifier_troll_warlord_fervor_custom_heal")
end

end


function modifier_troll_warlord_fervor_custom_speed:MoreStack()
if not IsServer() then return end
	if self:GetStackCount() < self.max_stacks then 
		self:IncrementStackCount()
		if self:GetParent():HasModifier("modifier_troll_fervor_4") and self:GetStackCount() == self.max_stacks then 
			local duration = self:GetAbility().max_duration_init + self:GetAbility().max_duration_inc*self:GetCaster():GetUpgradeStack("modifier_troll_fervor_4")
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_max", {duration = duration})
		end

		if self:GetParent():HasModifier("modifier_troll_fervor_1") and self:GetStackCount() == self.max_stacks then 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_heal", {duration = self:GetAbility().heal_timer})
		end

		if self:GetStackCount() == self.max_stacks and self:GetParent():HasModifier("modifier_troll_fervor_5") then 
			
			self.particle = ParticleManager:CreateParticle("particles/items4_fx/ascetic_cap.vpcf" , PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  			self:AddParticle(self.particle, false, false, -1, false, false)
		end

	end
end


function modifier_troll_warlord_fervor_custom_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
         MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
         MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_troll_warlord_fervor_custom_speed:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_6") then 
		bonus = self:GetAbility().first_speed
	end

	return self:GetStackCount() * (self.stack_multiplier + bonus)
end

function modifier_troll_warlord_fervor_custom_speed:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_5") then 
		bonus = self:GetAbility().stack_move
	end

	return self:GetStackCount() * bonus
end


function modifier_troll_warlord_fervor_custom_speed:GetModifierStatusResistanceStacking() 
if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_5") then 
		bonus = self:GetAbility().stack_resist
	end

	return self:GetStackCount() * bonus
end





modifier_troll_warlord_fervor_custom_armor = class({})

function modifier_troll_warlord_fervor_custom_armor:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_armor:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_armor:GetTexture() return "buffs/fervor_armor" end

function modifier_troll_warlord_fervor_custom_armor:OnCreated(table)
self.max = self:GetAbility().armor_max_init + self:GetAbility().armor_max_inc*self:GetCaster():GetUpgradeStack("modifier_troll_fervor_3")
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_troll_warlord_fervor_custom_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self.max then 
	self:IncrementStackCount()
end
end

function modifier_troll_warlord_fervor_custom_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_troll_warlord_fervor_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount() * self:GetAbility().armor_armor
end


modifier_troll_warlord_fervor_custom_max  = class({})
function modifier_troll_warlord_fervor_custom_max:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_max:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_max:GetTexture() return "buffs/fervor_max" end

function modifier_troll_warlord_fervor_custom_max:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end



function modifier_troll_warlord_fervor_custom_max:GetModifierBaseAttackTimeConstant()
return self:GetAbility().max_bva
end



function modifier_troll_warlord_fervor_custom_max:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Troll.Fervor_max")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)

self.effect_impact = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControlEnt(self.effect_impact, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.effect_impact, false, false, -1, false, false)
end





modifier_troll_warlord_fervor_custom_legendary = class({})
function modifier_troll_warlord_fervor_custom_legendary:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_legendary:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_legendary:IsPurchasable() return false end
function modifier_troll_warlord_fervor_custom_legendary:GetEffectName() return 
"particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf"
end
function modifier_troll_warlord_fervor_custom_legendary:GetStatusEffectName() return 
"particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"
end

function modifier_troll_warlord_fervor_custom_legendary:StatusEffectPriority() return 20 end

function modifier_troll_warlord_fervor_custom_legendary:GetTexture() return "buffs/warpath_lowhp" end

function modifier_troll_warlord_fervor_custom_legendary:OnCreated(table)
if not IsServer() then return end

local ability = self:GetParent():FindAbilityByName("troll_warlord_berserkers_rage_custom")
if ability then 
	ability:SetActivated(false)
end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_rampage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	


self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
self:GetParent():EmitSound("Troll.Fervor_legendary")

local parent = self:GetParent()

Timers:CreateTimer(0.2, function()
 
if parent then 
 	parent:EmitSound("Troll.Fervor_legendary_alt") 
end

end)


self.particle_burn = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_rampage_resistance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_burn, false, false, -1, false, false)

self.particle_peffect = ParticleManager:CreateParticle("particles/troll_fervor_buf.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end





function modifier_troll_warlord_fervor_custom_legendary:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_fervor_custom_legendary_timer")

if mod then 
	mod:Destroy()
end

local ability = self:GetParent():FindAbilityByName("troll_warlord_berserkers_rage_custom")
if ability then 
	ability:SetActivated(true)
end
end

function modifier_troll_warlord_fervor_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end



function modifier_troll_warlord_fervor_custom_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:IncrementStackCount()

if RollPseudoRandomPercentage(self:GetAbility().legendary_chance, 543, self:GetParent()) then


	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = self:GetAbility().legendary_bash})
	params.target:EmitSound("Ogre.Bloodlust_hit")


	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0,  params.target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )

end


end

function modifier_troll_warlord_fervor_custom_legendary:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility().legendary_damage_inc*self:GetStackCount()
end





modifier_troll_warlord_fervor_custom_legendary_timer = class({})
function modifier_troll_warlord_fervor_custom_legendary_timer:IsHidden() return true end
function modifier_troll_warlord_fervor_custom_legendary_timer:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_legendary_timer:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_START
}

end

function modifier_troll_warlord_fervor_custom_legendary_timer:OnAttackStart(params)
if self:GetParent() ~= params.attacker then return end

self:SetDuration(self:GetAbility().legendary_attack, true)
end

function modifier_troll_warlord_fervor_custom_legendary_timer:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_fervor_custom_legendary")

if mod then 
	mod:Destroy()
	self:GetParent():EmitSound("Troll.Fervor_legendary_stun")
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility().legendary_stun*(1 - self:GetParent():GetStatusResistance())})
end

end


modifier_troll_warlord_fervor_custom_bash = class({})
function modifier_troll_warlord_fervor_custom_bash:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_bash:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_bash:GetTexture() return "buffs/fervor_bash" end
function modifier_troll_warlord_fervor_custom_bash:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.target = table.target
self:SetStackCount(1)
end


function modifier_troll_warlord_fervor_custom_bash:OnRefresh(table)
if not IsServer() then return end

if self.target == table.target then 
	self:IncrementStackCount()
else 
	self:SetStackCount(1)
	self.target = table.target
end

end


function modifier_troll_warlord_fervor_custom_bash:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_troll_warlord_fervor_custom_bash:OnTooltip()
return self:GetAbility().bash_max
end


modifier_troll_warlord_fervor_custom_heal = class({})
function modifier_troll_warlord_fervor_custom_heal:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_heal:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_heal:GetTexture() return "buffs/inner_heal" end
function modifier_troll_warlord_fervor_custom_heal:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

local heal = self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_troll_fervor_1")]*self:GetCaster():GetMaxHealth()

self:GetCaster():Heal(heal, self:GetCaster())
SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)
self:GetCaster():EmitSound("Troll.Fervor_heal")

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end

function modifier_troll_warlord_fervor_custom_heal:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_fervor_custom_speed")

if mod and mod:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max_stacks") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_heal", {duration = self:GetAbility().heal_timer})
end

end


function modifier_troll_warlord_fervor_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_troll_warlord_fervor_custom_heal:OnTooltip()
return self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_troll_fervor_1")]*self:GetCaster():GetMaxHealth()
end



modifier_troll_warlord_fervor_custom_attack = class({})
function modifier_troll_warlord_fervor_custom_attack:IsHidden() return true end
function modifier_troll_warlord_fervor_custom_attack:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_troll_warlord_fervor_custom_attack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self:GetCaster() then return end
if self:GetCaster():IsNull() then return end

self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, false)
end


modifier_troll_warlord_fervor_custom_incoming = class({})
function modifier_troll_warlord_fervor_custom_incoming:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_incoming:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_incoming:GetTexture() return "buffs/fervor_damage" end


function modifier_troll_warlord_fervor_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_troll_warlord_fervor_custom_incoming:GetModifierIncomingDamage_Percentage()
	return self:GetAbility().incoming_damage[self:GetParent():GetUpgradeStack("modifier_troll_fervor_2")]
end