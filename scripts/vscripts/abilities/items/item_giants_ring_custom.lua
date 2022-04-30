LinkLuaModifier("modifier_item_giants_ring_custom", "abilities/items/item_giants_ring_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_giants_ring_custom", "abilities/items/item_giants_ring_custom", LUA_MODIFIER_MOTION_NONE)

item_giants_ring_custom = class({})

function item_giants_ring_custom:GetIntrinsicModifierName()
	return "modifier_item_giants_ring_custom"
end

function item_giants_ring_custom:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("Giant.Ring")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_giants_ring_custom", {duration = self:GetSpecialValueFor("duration")})
end


modifier_item_giants_ring_custom = class({})

function modifier_item_giants_ring_custom:IsHidden() return true end
function modifier_item_giants_ring_custom:IsPurgable() return false end
function modifier_item_giants_ring_custom:RemoveOnDeath() return false end
function modifier_item_giants_ring_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_giants_ring_custom:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(0.5)
end

function modifier_item_giants_ring_custom:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():IsAlive() then 
local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("damage_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
for _,enemy in pairs(enemies) do
    local damageTable = { victim = enemy, attacker = self:GetParent(), damage = self:GetParent():GetStrength()*self:GetAbility():GetSpecialValueFor("pct_str_damage_per_second")*0.5/100, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }
    ApplyDamage(damageTable)
end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl( effect_cast, 1, Vector(120,1,1))
ParticleManager:ReleaseParticleIndex( effect_cast )

end

function modifier_item_giants_ring_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
    }

    return funcs
end


function modifier_item_giants_ring_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_strength") end
end
function modifier_item_giants_ring_custom:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("movement_speed") end
end



function modifier_item_giants_ring_custom:GetModifierModelScale() 
if self:GetCaster():HasModifier("modifier_giants_ring_custom") then 
    return self:GetAbility():GetSpecialValueFor("active_scale")
end

return self:GetAbility():GetSpecialValueFor("model_scale") 
end


modifier_giants_ring_custom = class({})
function modifier_giants_ring_custom:IsHidden() return false end
function modifier_giants_ring_custom:IsPurgable() return false end

function modifier_giants_ring_custom:CheckState()
return
{
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end