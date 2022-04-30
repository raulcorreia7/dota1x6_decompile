LinkLuaModifier("modifier_item_ocean_heart_custom", "abilities/items/item_ocean_heart_custom", LUA_MODIFIER_MOTION_NONE)

item_ocean_heart_custom = class({})

function item_ocean_heart_custom:GetIntrinsicModifierName()
	return "modifier_item_ocean_heart_custom"
end


modifier_item_ocean_heart_custom = class({})

function modifier_item_ocean_heart_custom:IsHidden() return true end
function modifier_item_ocean_heart_custom:IsPurgable() return false end
function modifier_item_ocean_heart_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_ocean_heart_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end


function modifier_item_ocean_heart_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("all_stats") end
end
function modifier_item_ocean_heart_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("all_stats") end
end
function modifier_item_ocean_heart_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("all_stats") end
end
function modifier_item_ocean_heart_custom:GetModifierConstantHealthRegen() return self:GetAbility():GetSpecialValueFor("hp_regen") end
function modifier_item_ocean_heart_custom:GetModifierConstantManaRegen() return self:GetAbility():GetSpecialValueFor("mp_regen") end

