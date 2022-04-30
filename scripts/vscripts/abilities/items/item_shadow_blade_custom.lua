LinkLuaModifier("item_shadow_blade_custom_surge", "abilities/items/item_shadow_blade_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_shadow_blade_custom_passive", "abilities/items/item_shadow_blade_custom", LUA_MODIFIER_MOTION_NONE)

item_shadow_blade_custom = class({})


function item_shadow_blade_custom:OnSpellStart()
if not IsServer() then return end
    self:GetCaster():EmitSound("DOTA_Item.InvisibilitySword.Activate")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "item_shadow_blade_custom_surge", {duration = self:GetSpecialValueFor("duration")})


end


function item_shadow_blade_custom:GetIntrinsicModifierName() return  
"item_shadow_blade_custom_passive"
end



item_shadow_blade_custom_surge = class({})



function item_shadow_blade_custom_surge:GetEffectName() return "particles/silver_edge_speed_.vpcf" end
function item_shadow_blade_custom_surge:IsHidden()     return false end
function item_shadow_blade_custom_surge:IsPurgable()   return false end

function item_shadow_blade_custom_surge:OnCreated(table)

self.speed = self:GetAbility():GetSpecialValueFor("movement_speed")
self.damage = self:GetAbility():GetSpecialValueFor("windwalk_bonus_damage")
end

function item_shadow_blade_custom_surge:CheckState() return 
{[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function item_shadow_blade_custom_surge:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
   MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
}
end



function item_shadow_blade_custom_surge:GetModifierMoveSpeedBonus_Percentage() return self.speed end

function item_shadow_blade_custom_surge:GetModifierProcAttack_BonusDamage_Physical(params)
if params.attacker == self:GetParent() then 
    self:Destroy()
    return self.damage
end
end





item_shadow_blade_custom_passive = class({})
function item_shadow_blade_custom_passive:IsHidden() return true end
function item_shadow_blade_custom_passive:IsPurgable() return false end
function item_shadow_blade_custom_passive:RemoveOnDeath() return false end
function item_shadow_blade_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function item_shadow_blade_custom_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    
}
end
function item_shadow_blade_custom_passive:GetModifierPreAttack_BonusDamage() return
self:GetAbility():GetSpecialValueFor("bonus_damage")
end


function item_shadow_blade_custom_passive:GetModifierAttackSpeedBonus_Constant() return
self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

