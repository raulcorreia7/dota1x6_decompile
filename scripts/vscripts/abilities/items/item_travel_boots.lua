LinkLuaModifier("modifier_item_travel_boots_custom", "abilities/items/item_travel_boots", LUA_MODIFIER_MOTION_NONE)

item_travel_boots_custom = class({})

function item_travel_boots_custom:GetIntrinsicModifierName()
	return "modifier_item_travel_boots_custom"
end

modifier_item_travel_boots_custom = class({})




function modifier_item_travel_boots_custom:IsHidden() return true end
function modifier_item_travel_boots_custom:IsPurgable() return false end

function modifier_item_travel_boots_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
end

function modifier_item_travel_boots_custom:GetModifierMoveSpeedBonus_Special_Boots() 
	if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end 
end

---------------------------------------------------------------------------------------------------------------------------------------------

LinkLuaModifier("modifier_item_travel_boots_2_custom", "abilities/items/item_travel_boots", LUA_MODIFIER_MOTION_NONE)

item_travel_boots_2_custom = class({})

function item_travel_boots_2_custom:GetIntrinsicModifierName()
	return "modifier_item_travel_boots_2_custom"
end

modifier_item_travel_boots_2_custom = class({})


function modifier_item_travel_boots_2_custom:IsHidden() return true end
function modifier_item_travel_boots_2_custom:IsPurgable() return false end

function modifier_item_travel_boots_2_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
end

function modifier_item_travel_boots_2_custom:GetModifierMoveSpeedBonus_Special_Boots() 
	if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end 
end
