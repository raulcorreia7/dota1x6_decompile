LinkLuaModifier("modifier_item_seer_stone_custom", "abilities/items/item_seer_stone_custom", LUA_MODIFIER_MOTION_NONE)

item_seer_stone_custom = class({})

function item_seer_stone_custom:GetIntrinsicModifierName()
	return "modifier_item_seer_stone_custom"
end

function item_seer_stone_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function item_seer_stone_custom:OnSpellStart()
if not IsServer() then return end
EmitSoundOnLocationForPlayer("Item.SeerStone",self:GetCursorPosition(), self:GetCaster():GetPlayerOwnerID())


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)

self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/seer_stone.vpcf", PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber())
ParticleManager:SetParticleControl(self.particle, 0, self:GetCursorPosition())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetSpecialValueFor("duration")+0.5, self:GetSpecialValueFor("radius"), 0))
end


modifier_item_seer_stone_custom = class({})

function modifier_item_seer_stone_custom:IsHidden() return true end
function modifier_item_seer_stone_custom:IsPurgable() return false end
function modifier_item_seer_stone_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_seer_stone_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_CAST_RANGE_BONUS,

    }

    return funcs
end


function modifier_item_seer_stone_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("mana_regen") end
end



function modifier_item_seer_stone_custom:GetModifierCastRangeBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("cast_range_bonus") end
end


function modifier_item_seer_stone_custom:GetModifierSpellAmplify_Percentage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("spell_bonus") end
end

function modifier_item_seer_stone_custom:GetBonusDayVision()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("vision_bonus") end
end

function modifier_item_seer_stone_custom:GetBonusNightVision()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("vision_bonus") end
end