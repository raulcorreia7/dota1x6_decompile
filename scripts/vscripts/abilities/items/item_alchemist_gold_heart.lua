LinkLuaModifier("modifier_item_alchemist_gold_heart", "abilities/items/item_alchemist_gold_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_heart_buff", "abilities/items/item_alchemist_gold_heart", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_heart = class({})

function item_alchemist_gold_heart:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_heart"
end

function item_alchemist_gold_heart:OnSpellStart()
local caster = self:GetCaster()
if not IsServer() then return end

caster:EmitSound("Huskar.Passive_LowHp")
caster:AddNewModifier(caster, self, "modifier_item_alchemist_gold_heart_buff", {duration = self:GetSpecialValueFor("duration")})
end

modifier_item_alchemist_gold_heart	= class({})

function modifier_item_alchemist_gold_heart:IsPurgable()		return false end
function modifier_item_alchemist_gold_heart:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_heart:IsHidden()	return true end

function modifier_item_alchemist_gold_heart:OnCreated()
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_regen = self:GetAbility():GetSpecialValueFor("bonus_regen")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	self.bonus_spell = self:GetAbility():GetSpecialValueFor("bonus_spell")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_resist = self:GetAbility():GetSpecialValueFor("bonus_resist")
	self.active_resist = self:GetAbility():GetSpecialValueFor("active_resist")
	self.active_regen = self:GetAbility():GetSpecialValueFor("active_regen")
end

function modifier_item_alchemist_gold_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
 		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
 		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_item_alchemist_gold_heart:GetModifierLifestealRegenAmplify_Percentage() 
    return self.bonus_regen
end
function modifier_item_alchemist_gold_heart:GetModifierHealAmplify_PercentageTarget() 
    return self.bonus_regen
end

function modifier_item_alchemist_gold_heart:GetModifierHPRegenAmplify_Percentage() 
    return self.bonus_regen
end

function modifier_item_alchemist_gold_heart:GetModifierStatusResistanceStacking()
if self:GetParent():HasModifier("modifier_item_sange_and_yasha") or 
	self:GetParent():HasModifier("modifier_item_kaya_and_sange") or self:GetParent():HasModifier("modifier_item_trident")
or self:GetParent():HasModifier("modifier_item_sange") then return 0 end

if self:GetParent():HasModifier("modifier_item_alchemist_gold_heart_buff") then 
	return self.active_resist	
end

return self.bonus_resist
end

function modifier_item_alchemist_gold_heart:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_alchemist_gold_heart:GetModifierBonusStats_Intellect()
	return self.bonus_int
end


function modifier_item_alchemist_gold_heart:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_alchemist_gold_heart:GetModifierHealthRegenPercentage()

if self:GetParent():HasModifier("modifier_item_alchemist_gold_heart_buff") then 
	return self.active_regen	
end
	return self.health_regen_pct
end


function modifier_item_alchemist_gold_heart:GetModifierSpellAmplify_Percentage()
	return self.bonus_spell
end


function modifier_item_alchemist_gold_heart:GetModifierMPRegenAmplify_Percentage()
 return self.bonus_mana_regen
end




modifier_item_alchemist_gold_heart_buff = class({})

function modifier_item_alchemist_gold_heart_buff:IsPurgable() return false end

function modifier_item_alchemist_gold_heart_buff:OnCreated()
	self.active_resist = self:GetAbility():GetSpecialValueFor("active_resist")
	self.active_regen = self:GetAbility():GetSpecialValueFor("active_regen")
end


function modifier_item_alchemist_gold_heart_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_item_alchemist_gold_heart_buff:OnTooltip() return
self.active_regen
end

function modifier_item_alchemist_gold_heart_buff:OnTooltip2() return
self.active_resist
end
function modifier_item_alchemist_gold_heart_buff:GetEffectName() return "particles/huskar_lowhp.vpcf" end