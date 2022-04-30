LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker_red", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker_purple", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura_red", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura_purple", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_mixing", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_tick", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_damage", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_root_timer", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_root", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_acid_spray_custom = class({})
alchemist_acid_spray_red_custom = class({})
alchemist_acid_spray_purple_custom = class({})

alchemist_acid_spray_custom.cd = {2,4,6}

alchemist_acid_spray_custom.damage = {10,20,30}

alchemist_acid_spray_custom.damage_reduction = {-4,-8,-12}

alchemist_acid_spray_custom.tick_max = {5,10}
alchemist_acid_spray_custom.tick_armor = -1
alchemist_acid_spray_custom.tick_slow = -5

alchemist_acid_spray_custom.heal = 0.015

alchemist_acid_spray_custom.root_duration = 1.5
alchemist_acid_spray_custom.root_timer = 4

alchemist_acid_spray_custom.legendary_damage = 1.8

function alchemist_acid_spray_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function alchemist_acid_spray_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self.cd[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_1")]
end

return self.BaseClass.GetCooldown( self, level ) - bonus
end



function alchemist_acid_spray_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
self:CreateSpray("modifier_alchemist_acid_spray_custom_thinker", point, self)
end


function alchemist_acid_spray_custom:CreateSpray(name, point, ability)
if not IsServer() then return end
CreateModifierThinker( self:GetCaster(), ability, name, { duration = self:GetSpecialValueFor( "duration" ) }, point, self:GetCaster():GetTeamNumber(), false )
end

function alchemist_acid_spray_custom:DoDamage(point)
if not IsServer() then return end
local damage = self:GetSpecialValueFor( "damage" )

if self:GetCaster():HasModifier("modifier_alchemist_spray_3") then
	damage = damage + self.damage[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_3")]
end

if self:GetCaster():HasModifier("modifier_alchemist_spray_legendary") then 
	damage = damage*self.legendary_damage
end


local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self }
	

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )


for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	ApplyDamage( damageTable )
	enemy:EmitSound("Hero_Alchemist.AcidSpray.Damage")

	if self:GetCaster():HasModifier("modifier_alchemist_spray_4") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_acid_spray_custom_tick", {duration = 1.2})
	end
	if self:GetCaster():HasModifier("modifier_alchemist_spray_2") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_acid_spray_custom_damage", {duration = 1.2})
	end
end


if (self:GetCaster():GetAbsOrigin() - point):Length2D() <= self:GetSpecialValueFor("radius") and self:GetCaster():HasModifier("modifier_alchemist_spray_5") then
	local heal = self:GetCaster():GetMaxHealth()*(self.heal)

	self:GetCaster():Heal(heal, self:GetCaster())
	SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
end

end




function alchemist_acid_spray_red_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function alchemist_acid_spray_red_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
	bonus = ability.cd[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_1")]
end

return self.BaseClass.GetCooldown( self, level ) - bonus
end



function alchemist_acid_spray_red_custom:OnSpellStart()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
local point = self:GetCursorPosition()

ability:CreateSpray("modifier_alchemist_acid_spray_custom_thinker_red", point, self)
end



function alchemist_acid_spray_purple_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function alchemist_acid_spray_purple_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
	bonus = ability.cd[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_1")]
end

return self.BaseClass.GetCooldown( self, level ) - bonus
end



function alchemist_acid_spray_purple_custom:OnSpellStart()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
local point = self:GetCursorPosition()

ability:CreateSpray("modifier_alchemist_acid_spray_custom_thinker_purple", point, self)
end





modifier_alchemist_acid_spray_custom_thinker = class({})

function modifier_alchemist_acid_spray_custom_thinker:OnCreated()
if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
	self:AddParticle( particle, false, false, -1, false, false )

	self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )

	self:OnIntervalThink()
	self:StartIntervalThink( interval )
end



function modifier_alchemist_acid_spray_custom_thinker:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura"
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchTeam()
if self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
else 
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_alchemist_acid_spray_custom_thinker:OnIntervalThink()
if not IsServer() then return end
self.main_ability:DoDamage(self:GetParent():GetAbsOrigin())
end








modifier_alchemist_acid_spray_custom_thinker_red = class({})

function modifier_alchemist_acid_spray_custom_thinker_red:OnCreated()
if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	local particle = ParticleManager:CreateParticle( "particles/alch_spray_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
	--ParticleManager:SetParticleControl( particle, 15, Vector( 180, 92, 179 ) )
	ParticleManager:SetParticleControl( particle, 15, Vector( 220, 20, 60 ) )
	ParticleManager:SetParticleControl( particle, 16, Vector( 1, 0, 0 ) )
	self:AddParticle( particle, false, false, -1, false, false )

	self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )

	self:OnIntervalThink()
	self:StartIntervalThink( interval )
end



function modifier_alchemist_acid_spray_custom_thinker_red:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura_red"
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchTeam()
if self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
else 
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

end 

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker_red:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_alchemist_acid_spray_custom_thinker_red:OnIntervalThink()
if not IsServer() then return end
self.main_ability:DoDamage(self:GetParent():GetAbsOrigin())
end








modifier_alchemist_acid_spray_custom_thinker_purple = class({})

function modifier_alchemist_acid_spray_custom_thinker_purple:OnCreated()
if not IsServer() then return end

	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:SetParticleControl( particle, 15, Vector( 180, 92, 179 ) )
	--ParticleManager:SetParticleControl( particle, 15, Vector( 220, 20, 60 ) )
	ParticleManager:SetParticleControl( particle, 16, Vector( 1, 0, 0 ) )
	self:AddParticle( particle, false, false, -1, false, false )

	self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )

	self:OnIntervalThink()
	self:StartIntervalThink( interval )
end



function modifier_alchemist_acid_spray_custom_thinker_purple:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura_purple"
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchTeam()
if self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
else 
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker_purple:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_alchemist_acid_spray_custom_thinker_purple:OnIntervalThink()
if not IsServer() then return end
self.main_ability:DoDamage(self:GetParent():GetAbsOrigin())
end










modifier_alchemist_acid_spray_custom_aura = class({})

function modifier_alchemist_acid_spray_custom_aura:GetTexture() return "alchemist_acid_spray" end

function modifier_alchemist_acid_spray_custom_aura:OnCreated()
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then 
		self.armor = -self.armor
	end

	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	self:StartIntervalThink(FrameTime())
end

function modifier_alchemist_acid_spray_custom_aura:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") and self:GetCaster():HasModifier("modifier_alchemist_spray_6") 
	and not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root") and self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_acid_spray_custom_root_timer", {duration = self.main_ability.root_timer})
end

end

function modifier_alchemist_acid_spray_custom_aura:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") then 

	local mod = self:GetParent():FindModifierByName("modifier_alchemist_acid_spray_custom_root_timer")
	mod.root = false
	mod:Destroy()
end

end



function modifier_alchemist_acid_spray_custom_aura:GetEffectName()
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_alchemist_spray_5") then
	return "particles/alch_armor.vpcf"
else 
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

end

function modifier_alchemist_acid_spray_custom_aura:GetEffectAttachType()
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_alchemist_spray_5") then
	return PATTACH_OVERHEAD_FOLLOW
else 
	return PATTACH_ABSORIGIN_FOLLOW
end

	
end

function modifier_alchemist_acid_spray_custom_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

	}

	return funcs
end

function modifier_alchemist_acid_spray_custom_aura:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_alchemist_acid_spray_custom_aura:CheckState()
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") then 
		return
		{
			[MODIFIER_STATE_SILENCED] = true
		}
	end
end




modifier_alchemist_acid_spray_custom_aura_red = class({})


function modifier_alchemist_acid_spray_custom_aura_red:OnCreated()
	self.armor = -self:GetAbility():GetSpecialValueFor( "resist" )
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then 
		self.armor = -self.armor
	end

	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	self:StartIntervalThink(FrameTime())
end

function modifier_alchemist_acid_spray_custom_aura_red:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") and self:GetCaster():HasModifier("modifier_alchemist_spray_6") 
	and not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root") and self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
	self:GetParent():AddNewModifier(self:GetCaster(), self.main_ability, "modifier_alchemist_acid_spray_custom_root_timer", {duration = self.main_ability.root_timer})
end

end

function modifier_alchemist_acid_spray_custom_aura_red:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura") and 
	not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") then 

	local mod = self:GetParent():FindModifierByName("modifier_alchemist_acid_spray_custom_root_timer")
	mod.root = false
	mod:Destroy()
end

end



function modifier_alchemist_acid_spray_custom_aura_red:GetEffectName() 
if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() and self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	return "particles/items4_fx/ascetic_cap.vpcf" 
end

end

function modifier_alchemist_acid_spray_custom_aura_red:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alchemist_acid_spray_custom_aura_red:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING

	}

	return funcs
end

function modifier_alchemist_acid_spray_custom_aura_red:GetModifierStatusResistanceStacking()
	return self.armor
end





modifier_alchemist_acid_spray_custom_aura_purple = class({})


function modifier_alchemist_acid_spray_custom_aura_purple:OnCreated()


	self.str_percentage = -self:GetAbility():GetSpecialValueFor( "strength" )
	if self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then 
		self.str_percentage = -self.str_percentage
	end
	self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

	self:StartIntervalThink(FrameTime())
end

function modifier_alchemist_acid_spray_custom_aura_purple:OnIntervalThink()
if not IsServer() then return end
self.str  = 0
if not self:GetParent():IsHero() then return end

self.str   = self:GetParent():GetStrength() * self.str_percentage * 0.01

 self:GetParent():CalculateStatBonus(true)

if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") and self:GetCaster():HasModifier("modifier_alchemist_spray_6") 
	and not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root") and self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
	self:GetParent():AddNewModifier(self:GetCaster(), self.main_ability, "modifier_alchemist_acid_spray_custom_root_timer", {duration = self.main_ability.root_timer})
end

end

function modifier_alchemist_acid_spray_custom_aura_purple:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	not self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_root_timer") then 

	local mod = self:GetParent():FindModifierByName("modifier_alchemist_acid_spray_custom_root_timer")
	mod.root = false
	mod:Destroy()
end

end



function modifier_alchemist_acid_spray_custom_aura_purple:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_alchemist_acid_spray_custom_aura_purple:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_alchemist_acid_spray_custom_aura_purple:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_alchemist_acid_spray_custom_aura_purple:GetModifierBonusStats_Strength()
  return self.str
end


function modifier_alchemist_acid_spray_custom_aura_purple:OnTooltip()
return self.str_percentage
end






modifier_alchemist_acid_spray_custom_tick = class({})
function modifier_alchemist_acid_spray_custom_tick:IsHidden() return false end
function modifier_alchemist_acid_spray_custom_tick:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_tick:GetTexture() return "buffs/acid_tick" end
function modifier_alchemist_acid_spray_custom_tick:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}

end

function modifier_alchemist_acid_spray_custom_tick:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self:GetAbility().tick_armor
end

function modifier_alchemist_acid_spray_custom_tick:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().tick_slow
end

function modifier_alchemist_acid_spray_custom_tick:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_alchemist_acid_spray_custom_tick:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().tick_max[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_4")] then return end
self:IncrementStackCount()
end




modifier_alchemist_acid_spray_custom_damage = class({})
function modifier_alchemist_acid_spray_custom_damage:IsHidden() return false end
function modifier_alchemist_acid_spray_custom_damage:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_damage:GetTexture() return "buffs/sonic_reduce" end
function modifier_alchemist_acid_spray_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_alchemist_acid_spray_custom_damage:GetModifierTotalDamageOutgoing_Percentage()
return self:GetAbility().damage_reduction[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_2")]
end







modifier_alchemist_acid_spray_custom_root_timer = class({})
function modifier_alchemist_acid_spray_custom_root_timer:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_root_timer:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_root_timer:OnCreated(table)
if not IsServer() then return end
self.root = true
self.t = 0

self.effect_cast = ParticleManager:CreateParticle( "particles/alch_root_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0,self.t, 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:StartIntervalThink(1)
end


function modifier_alchemist_acid_spray_custom_root_timer:OnIntervalThink()
if not IsServer() then return end
	self.t = self.t + 1
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self.t, 0 ) )
end




function modifier_alchemist_acid_spray_custom_root_timer:OnDestroy()
if not IsServer() then return end
if self.root == false then return end
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_acid_spray_custom_root", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().root_duration})
end



modifier_alchemist_acid_spray_custom_root = class({})
function modifier_alchemist_acid_spray_custom_root:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_root:IsPurgable() return true end
function modifier_alchemist_acid_spray_custom_root:GetTexture() return "buffs/reflection_speed" end
function modifier_alchemist_acid_spray_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end


function modifier_alchemist_acid_spray_custom_root:GetEffectName() return "particles/alch_root.vpcf" end

function modifier_alchemist_acid_spray_custom_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end













-- Способность Замешивание для легендарного таланта

alchemist_acid_spray_mixing = class({})

function alchemist_acid_spray_mixing:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
        self:SetActivated(false)
        self:SetHidden(true) 
    end
end

function alchemist_acid_spray_mixing:GetIntrinsicModifierName()
	return "modifier_alchemist_acid_spray_custom_mixing_visual"
end

function alchemist_acid_spray_mixing:OnSpellStart()
	if not IsServer() then return end
	self:EndCooldown()
	self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	local duration = self:GetSpecialValueFor("time_mixing")
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_alchemist_acid_spray_custom_mixing", { duration = duration } )
end




modifier_alchemist_acid_spray_custom_mixing = class({})

function modifier_alchemist_acid_spray_custom_mixing:IsHidden()
	return true
end

function modifier_alchemist_acid_spray_custom_mixing:IsPurgable()
	return false
end

function modifier_alchemist_acid_spray_custom_mixing:OnCreated( kv )
	if not IsServer() then return end


  	self.t = -1
  	self.timer = self:GetAbility():GetSpecialValueFor("time_mixing")*2
  	--self:StartIntervalThink(0.5)
  	--self:OnIntervalThink()



	self:GetParent():EmitSound("Alch.Mix")

	local ability_acid = self:GetParent():FindAbilityByName("alchemist_acid_spray_custom")
	local ability_acid_red = self:GetParent():FindAbilityByName("alchemist_acid_spray_red_custom")
	local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")

	if ability_acid then
		ability_acid:SetActivated(false)
	end
	if ability_acid_red then
		ability_acid_red:SetActivated(false)
	end
	if ability_acid_purple then
		ability_acid_purple:SetActivated(false)
	end

	self:GetAbility():SetActivated(false)
	self:GetAbility():StartCooldown(self:GetRemainingTime())
end

function modifier_alchemist_acid_spray_custom_mixing:OnDestroy()
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self:GetAbility():SetActivated(true)

	self:GetParent():StopSound("Alch.Mix")

	local ability_acid = self:GetParent():FindAbilityByName("alchemist_acid_spray_custom")
	local ability_acid_red = self:GetParent():FindAbilityByName("alchemist_acid_spray_red_custom")
	local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")


	
	if ability_acid then
		ability_acid:SetActivated(true) 
	end
	if ability_acid_red then
		ability_acid_red:SetActivated(true)
	end
	if ability_acid_purple then
		ability_acid_purple:SetActivated(true)
	end
	


	if not ability_acid:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_custom", "alchemist_acid_spray_red_custom", false, true)
		ability_acid:SetHidden(true)
		ability_acid_red:SetHidden(false)
		return
	end

	if not ability_acid_red:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_red_custom", "alchemist_acid_spray_purple_custom", false, true)
		ability_acid_red:SetHidden(true)
		ability_acid_purple:SetHidden(false)
		return
	end

	if not ability_acid_purple:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_purple_custom", "alchemist_acid_spray_custom", false, true)
		ability_acid_purple:SetHidden(true)
		ability_acid:SetHidden(false)
		return
	end

end




function modifier_alchemist_acid_spray_custom_mixing:OnIntervalThink()
if not IsServer() then return end
  self.t = self.t + 1
  local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end
