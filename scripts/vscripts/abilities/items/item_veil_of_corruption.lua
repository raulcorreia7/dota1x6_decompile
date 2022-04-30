LinkLuaModifier("modifier_item_veil_of_corruption", "abilities/items/item_veil_of_corruption", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_veil_of_corruption_debuff", "abilities/items/item_veil_of_corruption", LUA_MODIFIER_MOTION_NONE)

item_veil_of_corruption = class({})

function item_veil_of_corruption:GetIntrinsicModifierName()
	return "modifier_item_veil_of_corruption"
end

function item_veil_of_corruption:GetAOERadius()
return self:GetSpecialValueFor("debuff_radius")
end

function item_veil_of_corruption:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("DOTA_Item.VeilofDiscord.Activate")
    self:GetParent():EmitSound("Veil.Cast")

    local particle = ParticleManager:CreateParticle( "particles/veil_of_corruption.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl( particle, 0, self:GetCursorPosition() )
    ParticleManager:SetParticleControl( particle, 1, Vector( self:GetSpecialValueFor("debuff_radius"), 1, 1 ) )
    ParticleManager:ReleaseParticleIndex( particle )

    local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("debuff_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

    for _,enemy in pairs(enemies) do
        enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_veil_of_corruption_debuff", {duration = (1 - enemy:GetStatusResistance())*self:GetSpecialValueFor("resist_debuff_duration")})
    end
end


modifier_item_veil_of_corruption = class({})

function modifier_item_veil_of_corruption:IsHidden() return true end
function modifier_item_veil_of_corruption:IsPurgable() return false end
function modifier_item_veil_of_corruption:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_veil_of_corruption:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }

    return funcs
end


function modifier_item_veil_of_corruption:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end
function modifier_item_veil_of_corruption:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end
function modifier_item_veil_of_corruption:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end
function modifier_item_veil_of_corruption:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_armor") end
end


function modifier_item_veil_of_corruption:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("mana_regen") end
end





modifier_item_veil_of_corruption_debuff = class({})
function modifier_item_veil_of_corruption_debuff:IsHidden() return false end
function modifier_item_veil_of_corruption_debuff:IsPurgable() return true end

function modifier_item_veil_of_corruption_debuff:OnCreated(table)
self.resist = self:GetAbility():GetSpecialValueFor("status_resist")*-1
self.damage = self:GetAbility():GetSpecialValueFor("spell_amp")
if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/veil_of_corr_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(particle, false, false, -1, false, false)   


end

function modifier_item_veil_of_corruption_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}

end


function modifier_item_veil_of_corruption_debuff:GetModifierStatusResistanceStacking() 
    return self.resist 
end

function modifier_item_veil_of_corruption_debuff:GetModifierIncomingDamage_Percentage(params)

--if self:GetParent() ~= params.unit then return end
if params.inflictor == nil then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

return self.damage
end

function modifier_item_veil_of_corruption_debuff:OnTooltip()
return self.damage
end