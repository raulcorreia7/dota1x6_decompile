LinkLuaModifier("modifier_item_bracer_custom", "abilities/items/item_bracer_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bracer_custom_heal", "abilities/items/item_bracer_custom", LUA_MODIFIER_MOTION_NONE)

item_bracer_custom = class({})

function item_bracer_custom:GetIntrinsicModifierName()
	return "modifier_item_bracer_custom"
end

function item_bracer_custom:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("DOTA_Item.TranquilBoots.Activate")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_bracer_custom_heal", {duration = self:GetSpecialValueFor("duration")})
end


modifier_item_bracer_custom = class({})

function modifier_item_bracer_custom:IsHidden() return true end
function modifier_item_bracer_custom:IsPurgable() return false end
function modifier_item_bracer_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_bracer_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end


function modifier_item_bracer_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("str") end
end
function modifier_item_bracer_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("agi") end
end
function modifier_item_bracer_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("int") end
end
function modifier_item_bracer_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("damage") end
end


function modifier_item_bracer_custom:GetModifierConstantHealthRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("regen") end
end

modifier_item_bracer_custom_heal = class({})
function modifier_item_bracer_custom_heal:IsHidden() return false end
function modifier_item_bracer_custom_heal:IsPurgable() return true end
function modifier_item_bracer_custom_heal:GetEffectName() return "particles/items2_fx/tranquil_boots.vpcf" end

function modifier_item_bracer_custom_heal:OnCreated(table)

self.heal = self:GetAbility():GetSpecialValueFor("heal")/self:GetAbility():GetSpecialValueFor("duration")

if not IsServer() then return end

for _,mod in pairs(self:GetParent():FindAllModifiers()) do 
    if mod:GetName() == "modifier_item_bracer_custom" then 
        self:IncrementStackCount()
    end
end

end

function modifier_item_bracer_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}

end

function modifier_item_bracer_custom_heal:GetModifierConstantHealthRegen()
return self.heal*self:GetStackCount()
end