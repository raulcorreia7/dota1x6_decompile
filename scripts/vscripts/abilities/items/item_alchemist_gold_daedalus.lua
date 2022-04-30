LinkLuaModifier("modifier_item_alchemist_gold_daedalus", "abilities/items/item_alchemist_gold_daedalus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_daedalus_debuff", "abilities/items/item_alchemist_gold_daedalus", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_daedalus = class({})

function item_alchemist_gold_daedalus:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_daedalus"
end

modifier_item_alchemist_gold_daedalus	= class({})

function modifier_item_alchemist_gold_daedalus:IsPurgable()		return false end
function modifier_item_alchemist_gold_daedalus:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_daedalus:IsHidden()	return true end

function modifier_item_alchemist_gold_daedalus:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor("crit_multiplier")
	self.corruption_duration = self:GetAbility():GetSpecialValueFor("corruption_duration")
	self.record = nil
end

function modifier_item_alchemist_gold_daedalus:GetCritDamage() return self:GetAbility():GetSpecialValueFor("crit_multiplier") end
function modifier_item_alchemist_gold_daedalus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,

	}

	return funcs
end

function modifier_item_alchemist_gold_daedalus:GetModifierPreAttack_BonusDamage(keys)
	return self.bonus_damage
end


function modifier_item_alchemist_gold_daedalus:GetModifierProcAttack_Feedback(params)
if params.attacker ~= self:GetParent() then return end
local target = params.target

	target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_alchemist_gold_daedalus_debuff", {duration = self.corruption_duration})
	target:EmitSound("Item_Desolator.Target")

	local mod = target:FindModifierByName("modifier_item_alchemist_gold_daedalus_debuff")
	if mod and params.record == self.record then 
		target:EmitSound("DOTA_Item.Daedelus.Crit")
		mod:SetStackCount(mod:GetStackCount() + self:GetAbility():GetSpecialValueFor("crit_armor"))
	end

end

function modifier_item_alchemist_gold_daedalus:GetModifierPreAttack_CriticalStrike( params )
    if not IsServer() then return end

    local random = RollPseudoRandomPercentage(self.crit_chance,109,self:GetParent())
    if random then
    	local target = params.target
    	
		self.record = params.record
    	return self.crit_multiplier
    end
    return 0
end

modifier_item_alchemist_gold_daedalus_debuff	= class({})

function modifier_item_alchemist_gold_daedalus_debuff:IsPurgable()		return true end



function modifier_item_alchemist_gold_daedalus_debuff:OnCreated()
	self.corruption_armor = self:GetAbility():GetSpecialValueFor("corruption_armor")
	self:SetStackCount(-1*self.corruption_armor)
end

function modifier_item_alchemist_gold_daedalus_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_alchemist_gold_daedalus_debuff:GetModifierPhysicalArmorBonus()
    return -1*self:GetStackCount()
end