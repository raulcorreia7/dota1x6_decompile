LinkLuaModifier("modifier_item_null_talisman_custom", "abilities/items/item_null_talisman_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_null_talisman_custom_mana", "abilities/items/item_null_talisman_custom", LUA_MODIFIER_MOTION_NONE)

item_null_talisman_custom = class({})

function item_null_talisman_custom:GetIntrinsicModifierName()
	return "modifier_item_null_talisman_custom"
end

function item_null_talisman_custom:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("DOTA_Item.ClarityPotion.Activate")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_null_talisman_custom_mana", {duration = self:GetSpecialValueFor("duration")})
end


modifier_item_null_talisman_custom = class({})

function modifier_item_null_talisman_custom:IsHidden() return true end
function modifier_item_null_talisman_custom:IsPurgable() return false end
function modifier_item_null_talisman_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_null_talisman_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }

    return funcs
end


function modifier_item_null_talisman_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("str") end
end
function modifier_item_null_talisman_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("agi") end
end
function modifier_item_null_talisman_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("int") end
end
function modifier_item_null_talisman_custom:GetModifierSpellAmplify_Percentage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("spell") end
end


function modifier_item_null_talisman_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("regen") end
end

modifier_item_null_talisman_custom_mana = class({})
function modifier_item_null_talisman_custom_mana:IsHidden() return false end
function modifier_item_null_talisman_custom_mana:IsPurgable() return true end
function modifier_item_null_talisman_custom_mana:GetEffectName() return "particles/items_fx/healing_clarity.vpcf" end

function modifier_item_null_talisman_custom_mana:OnCreated(table)
self.mana = self:GetAbility():GetSpecialValueFor("mana")/self:GetAbility():GetSpecialValueFor("duration")
if not IsServer() then return end

for _,mod in pairs(self:GetParent():FindAllModifiers()) do 
    if mod:GetName() == "modifier_item_null_talisman_custom" then 
        self:IncrementStackCount()
    end
end

end

function modifier_item_null_talisman_custom_mana:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}

end

function modifier_item_null_talisman_custom_mana:GetModifierConstantManaRegen()
return self.mana*self:GetStackCount()
end