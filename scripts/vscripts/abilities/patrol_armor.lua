LinkLuaModifier("modifier_patrol_armor", "abilities/patrol_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_patrol_armor_buff", "abilities/patrol_armor", LUA_MODIFIER_MOTION_NONE)


patrol_armor = class({})

function patrol_armor:GetIntrinsicModifierName() return "modifier_patrol_armor" end

modifier_patrol_armor = class({})
function modifier_patrol_armor:IsPurgable() return false end
function modifier_patrol_armor:IsHidden() return true end


function modifier_patrol_armor:OnCreated(table)
if not IsServer() then return end
	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

	self.armor = ability:GetSpecialValueFor("armor_second")

	if GameRules:GetDOTATime(false, false) < patrol_second_tier then 
		self.armor = ability:GetSpecialValueFor("armor_first")
	end

	self.radius = ability:GetSpecialValueFor("radius")

	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_patrol_armor:OnIntervalThink()
	if not IsServer() then return end
	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

	local heroes = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)


	if #heroes > 1 and not self:GetParent():HasModifier("modifier_patrol_armor_buff") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_patrol_armor_buff", {})
	end

	if #heroes <= 1 and self:GetParent():HasModifier("modifier_patrol_armor_buff") then
		self:GetParent():RemoveModifierByName("modifier_patrol_armor_buff") 
	end

end


function modifier_patrol_armor:CheckState()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_patrol_armor_buff") then return end
if GameRules:GetDOTATime(false, false) > patrol_second_tier then 
return
{
	[MODIFIER_STATE_INVULNERABLE] = true

}
end
return
end


function modifier_patrol_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_patrol_armor:GetModifierIncomingDamage_Percentage(params)

local hero = players[params.attacker:GetTeamNumber()]

if hero and (hero:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius then
	return -200
end

if self:GetParent():HasModifier("modifier_patrol_armor_buff") then 
	return self.armor
end

end







modifier_patrol_armor_buff = class({})

function modifier_patrol_armor_buff:IsHidden() return false end
function modifier_patrol_armor_buff:IsPurgable() return false end
function modifier_patrol_armor_buff:GetEffectName()
	return "particles/items2_fx/medallion_of_courage_friend.vpcf"
end
function modifier_patrol_armor_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

