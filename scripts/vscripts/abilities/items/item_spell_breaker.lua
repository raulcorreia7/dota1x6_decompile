LinkLuaModifier("modifier_item_spell_breaker", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spell_breaker_shield", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)

item_spell_breaker = class({})

function item_spell_breaker:GetIntrinsicModifierName()
	return "modifier_item_spell_breaker"
end

function item_spell_breaker:OnSpellStart()
if not IsServer() then return end
    self:GetParent():EmitSound("Hero_Antimage.Counterspell.Cast")
    self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_spell_breaker_shield", {duration = self:GetSpecialValueFor("duration_active")})
end


modifier_item_spell_breaker = class({})

function modifier_item_spell_breaker:IsHidden() return true end
function modifier_item_spell_breaker:IsPurgable() return false end
function modifier_item_spell_breaker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_spell_breaker:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return funcs
end


function modifier_item_spell_breaker:GetModifierMagicalResistanceBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_magical_armor") end
end
function modifier_item_spell_breaker:GetModifierHealthBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("health_bonus") end
end
function modifier_item_spell_breaker:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
end
function modifier_item_spell_breaker:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_damage") end
end


function modifier_item_spell_breaker:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
end

function modifier_item_spell_breaker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end
if self:GetParent():IsIllusion() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_mage_slayer_debuff", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("duration")})

end


modifier_item_spell_breaker_shield = class({})
function modifier_item_spell_breaker_shield:IsHidden() return false end
function modifier_item_spell_breaker_shield:IsPurgable() return true end


function modifier_item_spell_breaker_shield:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("resist_active")*-1
if not IsServer() then return end



local particle = ParticleManager:CreateParticle("particles/spell_breaker.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetAbsOrigin(),false)
ParticleManager:SetParticleControl(particle, 1 , Vector(100,1,1))
self:AddParticle(particle, false, false, -1, false, false)   



end

function modifier_item_spell_breaker_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_item_spell_breaker_shield:GetModifierIncomingDamage_Percentage(params)

--if self:GetParent() ~= params.unit then return end
if params.inflictor == nil then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

return self.damage
end

function modifier_item_spell_breaker_shield:OnTooltip()
return self.damage
end