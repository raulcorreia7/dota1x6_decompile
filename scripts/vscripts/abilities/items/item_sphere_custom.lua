LinkLuaModifier("item_sphere_custom_passive", "abilities/items/item_sphere_custom", LUA_MODIFIER_MOTION_NONE)


item_sphere_custom = class({})

function item_sphere_custom:GetIntrinsicModifierName() return
    "item_sphere_custom_passive"
end



item_sphere_custom_passive = class({})
function item_sphere_custom_passive:IsHidden() return true end
function item_sphere_custom_passive:IsPurgable() return false end
function item_sphere_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function item_sphere_custom_passive:RemoveOnDeath() return false end
function item_sphere_custom_passive:DeclareFunctions()
return
{
   MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
   MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
   MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
   MODIFIER_PROPERTY_ABSORB_SPELL

}
end



function item_sphere_custom_passive:GetModifierBonusStats_Agility () return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function item_sphere_custom_passive:GetModifierBonusStats_Strength() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
function item_sphere_custom_passive:GetModifierBonusStats_Intellect() return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function item_sphere_custom_passive:GetModifierConstantManaRegen() return
    self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end

function item_sphere_custom_passive:GetModifierConstantHealthRegen() return
    self:GetAbility():GetSpecialValueFor("bonus_health_regen") end


function item_sphere_custom_passive:GetAbsorbSpell(params)
if not IsServer() then return end
--if self:GetParent():HasModifier("modifier_item_mirror_shield") then return 0 end

if self:GetParent():IsIllusion() then return end
if self:GetParent():HasModifier("modifier_antimage_counterspell_custom_active") then return 0 end

if not self:GetAbility():IsFullyCastable() then return 0 end
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return 0 end

local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

self:GetAbility():UseResources(false, false, true)

return 1 

end