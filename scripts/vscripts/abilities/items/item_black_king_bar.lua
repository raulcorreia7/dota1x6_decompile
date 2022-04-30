LinkLuaModifier("modifier_item_black_king_bar_custom", "abilities/items/item_black_king_bar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_black_king_bar_custom_active", "abilities/items/item_black_king_bar", LUA_MODIFIER_MOTION_NONE)

item_black_king_bar_custom = class({})

function item_black_king_bar_custom:GetIntrinsicModifierName() return "modifier_item_black_king_bar_custom" end

function item_black_king_bar_custom:OnSpellStart()
    if not IsServer() then return end
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():EmitSound("DOTA_Item.BlackKingBar.Activate")
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_black_king_bar_custom_active", {duration = duration})
end

modifier_item_black_king_bar_custom = class({})

function modifier_item_black_king_bar_custom:IsHidden() return true end
function modifier_item_black_king_bar_custom:IsPurgable() return false end
function modifier_item_black_king_bar_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE  end

function modifier_item_black_king_bar_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_black_king_bar_custom:GetModifierBonusStats_Strength() 
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_strength") end 
end

function modifier_item_black_king_bar_custom:GetModifierPreAttack_BonusDamage() 
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_damage") end 
end

modifier_item_black_king_bar_custom_active = class({})

function modifier_item_black_king_bar_custom_active:IsPurgable() return false end

function modifier_item_black_king_bar_custom_active:OnCreated()
    if not IsServer() then return end
    if not self:GetAbility() then 
        self:Destroy() 
    end
end

function modifier_item_black_king_bar_custom_active:OnRefresh()
    if not IsServer() then return end
    self:OnCreated()
end

function modifier_item_black_king_bar_custom_active:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_black_king_bar_custom_active:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_black_king_bar_custom_active:CheckState()
    return {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
end

function modifier_item_black_king_bar_custom_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_item_black_king_bar_custom_active:GetModifierModelScale()
    if self:GetAbility() then 
        return self:GetAbility():GetSpecialValueFor("model_scale") 
    end
end

function modifier_item_black_king_bar_custom_active:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf"
end

function modifier_item_black_king_bar_custom_active:StatusEffectPriority()
    return 99999
end


