LinkLuaModifier( "modifier_axe_counter_helix_custom", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shard_debuff", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_legendary", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_slow", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_crit", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_armor", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_armor_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )

axe_counter_helix_custom = class({})

axe_counter_helix_custom.shard_debuff_duration = 6
axe_counter_helix_custom.shard_debuff_damage_reduction = -5
axe_counter_helix_custom.bonus_chance_from_shard = 6

axe_counter_helix_custom.legendary_interval = 0.3
axe_counter_helix_custom.legendary_damage = 1
axe_counter_helix_custom.legendary_resist = 70
axe_counter_helix_custom.legendary_cd = 8
axe_counter_helix_custom.legendary_attack_count = 4
axe_counter_helix_custom.legendary_attack_max = 6
axe_counter_helix_custom.legendary_helix_count = 5

axe_counter_helix_custom.armor = {1,1.5,2}
axe_counter_helix_custom.armor_duration = 8

axe_counter_helix_custom.chance_init = 0
axe_counter_helix_custom.chance_inc = 3

axe_counter_helix_custom.damage = {20,40,60}

axe_counter_helix_custom.heal = 0.03
axe_counter_helix_custom.heal_health = 30
axe_counter_helix_custom.heal_amp = 2

axe_counter_helix_custom.attack_slow = -10
axe_counter_helix_custom.attack_slow_max = 5
axe_counter_helix_custom.attack_slow_duration = 4

axe_counter_helix_custom.crit_count = {5,4}
axe_counter_helix_custom.crit_damage = 0.7
axe_counter_helix_custom.crit_stun = 0.5


function axe_counter_helix_custom:GetIntrinsicModifierName()
	return "modifier_axe_counter_helix_custom"
end

function axe_counter_helix_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then 
		return self.legendary_cd
	end
    return self.BaseClass.GetCooldown( self, level )
end


function axe_counter_helix_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function axe_counter_helix_custom:OnSpellStart()
if not IsServer() then return end

local duration = 0

duration = (self.legendary_helix_count - 1)*self.legendary_interval + FrameTime()

for _,mod_c in pairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do
	mod_c:Destroy()
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_legendary", {duration = duration })

end

function axe_counter_helix_custom:Spin(k_damage)
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_3)
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)

local radius = self:GetSpecialValueFor( "radius" )
local damage = self:GetSpecialValueFor("damage")


if self:GetCaster():HasModifier("modifier_axe_helix_5") then 

	local heal = self.heal*self:GetCaster():GetMaxHealth()
	if self:GetCaster():GetHealthPercent() <= self.heal_health then 
		heal = heal*self.heal_amp
	end

	self:GetCaster():Heal(heal, self:GetCaster())
	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

	local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
end

if self:GetCaster():HasModifier("modifier_axe_helix_1") then 
	damage = damage + self.damage[self:GetCaster():GetUpgradeStack("modifier_axe_helix_1")]
end

local illusion = 1
if self:GetCaster():IsIllusion() then 
	illusion = self:GetSpecialValueFor("damage_illusions")
end


local attack = false 
if self:GetCaster():HasModifier("modifier_axe_helix_4") then 

	local mod = self:GetCaster():FindModifierByName("modifier_axe_counter_helix_custom_crit")

	if mod and mod:GetStackCount() == self.crit_count[self:GetCaster():GetUpgradeStack("modifier_axe_helix_4")] - 1 then 
		attack = true
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_crit", {})
end

if attack == true then 

	damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*(self.crit_damage)
end

local damageTable = { attacker = self:GetCaster(), damage = damage*k_damage/illusion, damage_type = DAMAGE_TYPE_PURE, ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE, }

if self:GetCaster():HasModifier("modifier_axe_helix_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_armor", {duration = self.armor_duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_armor_count", {duration = self.armor_duration})
end


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	ApplyDamage( damageTable )


	if attack == true then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_bashed", {duration = (1 - enemy:GetStatusResistance())*self.crit_stun})
		enemy:EmitSound("BB.Goo_stun")
	end

	if self:GetCaster():HasModifier("modifier_axe_helix_6") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_slow", {duration = self.attack_slow_duration*(1 - enemy:GetStatusResistance())})
	end

	if self:GetCaster():HasShard() then
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_shard_debuff", {duration = self.shard_debuff_duration })
	end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )



if attack == false then 
	self:GetCaster():EmitSound("Hero_Axe.CounterHelix")
else 
	self:GetCaster():EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")
end

end










modifier_axe_counter_helix_custom = class({})

function modifier_axe_counter_helix_custom:IsPurgable()
	return false
end

function modifier_axe_counter_helix_custom:IsHidden() return true end


function modifier_axe_counter_helix_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_axe_counter_helix_custom:OnAttackLanded( params )
if not IsServer() then return end

if self:GetCaster() == params.attacker and self:GetParent():HasModifier("modifier_axe_helix_legendary") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack_count", {duration = self:GetAbility().legendary_attack_count})



	local mod = self:GetCaster():FindModifierByName("modifier_axe_counter_helix_custom_attack_count")

	if mod and mod:GetStackCount() > self:GetAbility().legendary_attack_max then 

		for _,all_counts in ipairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do 
	     	 all_counts:Destroy()
	      	break
	    end
	end



	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack", {duration = self:GetAbility().legendary_attack_count})
end

local proc = false
if params.target == self:GetCaster() or (params.attacker == self:GetCaster() and self:GetCaster():HasModifier("modifier_axe_helix_6") and not self:GetParent():HasModifier("modifier_tidehunter_anchor_smash_caster")) then 
	proc = true
end
if proc == false then return end
if self:GetCaster():PassivesDisabled() then return end
if not self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_axe_helix_legendary") then return end
if self:GetParent():HasModifier("modifier_axe_counter_helix_custom_legendary") then return end
if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
if params.attacker:IsOther() or params.attacker:IsBuilding() then return end
if self:GetParent():HasModifier("modifier_axe_counter_helix_custom_cd") then return end

local chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )
local bonus_chance = 0

if self:GetParent():HasShard() then
	bonus_chance = self:GetAbility().bonus_chance_from_shard
end

if self:GetParent():HasModifier("modifier_axe_helix_2") then 
	bonus_chance = bonus_chance + self:GetAbility().chance_init + self:GetAbility().chance_inc*self:GetParent():GetUpgradeStack("modifier_axe_helix_2")
end


chance = chance + bonus_chance

if RollPseudoRandomPercentage(chance, 543, self:GetParent()) then 
	self:GetAbility():Spin(1)

	if self:GetParent():HasModifier("modifier_axe_helix_legendary") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_counter_helix_custom_cd", {duration = self:GetAbility():GetSpecialValueFor("cooldown")*self:GetParent():GetCooldownReduction()})
	else 
		self:GetAbility():UseResources( false, false, true )
	end
end

end




modifier_axe_counter_helix_custom_shard_debuff = class({})

function modifier_axe_counter_helix_custom_shard_debuff:IsPurgable() return true end

function modifier_axe_counter_helix_custom_shard_debuff:OnCreated()
	self.damage_reduction = self:GetAbility().shard_debuff_damage_reduction
	self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_shard_debuff:OnRefresh()
	self.damage_reduction = self:GetAbility().shard_debuff_damage_reduction
	if self:GetStackCount() < 5 then
		self:IncrementStackCount()
	end
end

function modifier_axe_counter_helix_custom_shard_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_axe_counter_helix_custom_shard_debuff:GetModifierTotalDamageOutgoing_Percentage(params)
if params.inflictor ~= nil then return end
if params.target and params.target == self:GetCaster() then 
	return self:GetStackCount() * self.damage_reduction
end

end


modifier_axe_counter_helix_custom_legendary = class({})
function modifier_axe_counter_helix_custom_legendary:IsHidden() return false end
function modifier_axe_counter_helix_custom_legendary:IsPurgable() return false end

function modifier_axe_counter_helix_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true




self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().legendary_interval)
end

function modifier_axe_counter_helix_custom_legendary:OnIntervalThink()
if not IsServer() then return end
local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )



	self:GetAbility():Spin(self:GetAbility().legendary_damage)
end

function modifier_axe_counter_helix_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_axe_counter_helix_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_axe_counter_helix_custom_legendary:GetModifierStatusResistanceStacking()
return self:GetAbility().legendary_resist
end

modifier_axe_counter_helix_custom_cd = class({})
function modifier_axe_counter_helix_custom_cd:IsHidden() return true end
function modifier_axe_counter_helix_custom_cd:IsPurgable() return false end
function modifier_axe_counter_helix_custom_cd:IsDebuff() return true end





modifier_axe_counter_helix_custom_attack = class({})
function modifier_axe_counter_helix_custom_attack:IsHidden() return true end
function modifier_axe_counter_helix_custom_attack:IsPurgable() return false end
function modifier_axe_counter_helix_custom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_counter_helix_custom_attack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_axe_counter_helix_custom_attack_count")
if mod then 
	mod:DecrementStackCount()

	if mod:GetStackCount() < self:GetAbility().legendary_attack_max then 
		self:GetAbility():SetActivated(false)
	end

	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end


end

modifier_axe_counter_helix_custom_attack_count = class({})
function modifier_axe_counter_helix_custom_attack_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_attack_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_attack_count:GetTexture() return "buffs/helix_attack" end
function modifier_axe_counter_helix_custom_attack_count:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/axe_spin.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


self:SetStackCount(1)

end

function modifier_axe_counter_helix_custom_attack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().legendary_attack_max then 
	self:GetAbility():SetActivated(true)
end



end





function modifier_axe_counter_helix_custom_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_axe_counter_helix_custom_attack_count:OnTooltip() return self:GetStackCount() end

function modifier_axe_counter_helix_custom_attack_count:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(false)
end

function modifier_axe_counter_helix_custom_attack_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

local max = 6
local stack = math.min(math.floor(self:GetStackCount()), max)


for i = 1,max do 
	
	if i <= stack then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end











modifier_axe_counter_helix_custom_slow = class({})
function modifier_axe_counter_helix_custom_slow:IsHidden() return false end
function modifier_axe_counter_helix_custom_slow:IsPurgable() return true end
function modifier_axe_counter_helix_custom_slow:GetTexture() return "buffs/helix_attack" end
function modifier_axe_counter_helix_custom_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_slow_max then return end
self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_counter_helix_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().attack_slow*self:GetStackCount()
end




modifier_axe_counter_helix_custom_crit = class({})
function modifier_axe_counter_helix_custom_crit:IsHidden() return false end
function modifier_axe_counter_helix_custom_crit:IsPurgable() return true end
function modifier_axe_counter_helix_custom_crit:GetTexture() return "buffs/helix_speed" end

function modifier_axe_counter_helix_custom_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_axe_counter_helix_custom_crit:OnTooltip()
return self:GetAbility().crit_count[self:GetCaster():GetUpgradeStack("modifier_axe_helix_4")]
end


function modifier_axe_counter_helix_custom_crit:OnCreated()
if not IsServer() then return end
self.RemoveForDuel = true 
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_crit:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().crit_count[self:GetCaster():GetUpgradeStack("modifier_axe_helix_4")] then 
	self:Destroy()
end


end




modifier_axe_counter_helix_custom_armor = class({})
function modifier_axe_counter_helix_custom_armor:IsHidden() return true end
function modifier_axe_counter_helix_custom_armor:IsPurgable() return false end
function modifier_axe_counter_helix_custom_armor:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_counter_helix_custom_armor:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_axe_counter_helix_custom_armor:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_axe_counter_helix_custom_armor_count")

if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


end

modifier_axe_counter_helix_custom_armor_count = class({})
function modifier_axe_counter_helix_custom_armor_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_armor_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_armor_count:GetTexture() return "buffs/helix_armor" end
function modifier_axe_counter_helix_custom_armor_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_armor_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_armor_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}

end

function modifier_axe_counter_helix_custom_armor_count:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*(self:GetAbility().armor[self:GetCaster():GetUpgradeStack("modifier_axe_helix_3")])
end

