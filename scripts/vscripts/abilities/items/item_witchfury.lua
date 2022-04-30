LinkLuaModifier("item_witchfury_passive", "abilities/items/item_witchfury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_witchfury_root", "abilities/items/item_witchfury", LUA_MODIFIER_MOTION_NONE)

item_witchfury = class({})


function item_witchfury:GetIntrinsicModifierName()
return "item_witchfury_passive"
end






item_witchfury_passive = class({})
function item_witchfury_passive:IsHidden() return true end
function item_witchfury_passive:IsPurgable() return false end
function item_witchfury_passive:RemoveOnDeath() return false end
function item_witchfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function item_witchfury_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_TAKEDAMAGE
    
}
end

function item_witchfury_passive:GetModifierBonusStats_Intellect()
return self:GetAbility():GetSpecialValueFor("int_bonus")
end

function item_witchfury_passive:GetModifierBonusStats_Strength()
return self:GetAbility():GetSpecialValueFor("str_bonus")
end
function item_witchfury_passive:GetModifierBonusStats_Agility()
return self:GetAbility():GetSpecialValueFor("agi_bonus")
end

function item_witchfury_passive:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility():GetSpecialValueFor("speed_bonus")
end
function item_witchfury_passive:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor("armor_bonus")
end
function item_witchfury_passive:GetModifierProjectileSpeedBonus()
return self:GetAbility():GetSpecialValueFor("proj_bonus")
end




function item_witchfury_passive:OnCreated()
  self.record = nil
end


function item_witchfury_passive:OnAttack(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_item_witch_blade") or self:GetParent():HasModifier("modifier_item_revenants_brooch") then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker ~= self:GetParent() then return end
if not self:GetAbility():IsFullyCastable() then return end

self.record = params.record
self:GetAbility():UseResources(false, false, true)
end


function item_witchfury_passive:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker ~= self:GetParent() then return end
if params.record ~= self.record then return end

params.target:EmitSound("Item.WitchBlade.Target")
local duration = self:GetAbility():GetSpecialValueFor("root")
if params.target:IsBuilding() then 
  duration = self:GetAbility():GetSpecialValueFor("buildings_duration")
end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "item_witchfury_root", {duration = duration})
self.record = nil
end


function item_witchfury_passive:CheckState()
    local state = {}
if not self:GetParent():IsRealHero() then return end
    
    if self:GetAbility():IsFullyCastable() then
        state = {[MODIFIER_STATE_CANNOT_MISS] = true}
    end

    return state
end




item_witchfury_root = class({})
function item_witchfury_root:IsHidden() return false end
function item_witchfury_root:IsPurgable() return true end
function item_witchfury_root:GetEffectName() return "particles/items3_fx/witch_blade_debuff.vpcf" end

function item_witchfury_root:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetAbility():GetSpecialValueFor("int_damage")
self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.building = self:GetAbility():GetSpecialValueFor("buildings")

if self:GetParent():IsBuilding() then 
  self.interval = self:GetAbility():GetSpecialValueFor("buildings_interval")

end

self.ground_particle = ParticleManager:CreateParticle("particles/sf_ulti_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.ground_particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.ground_particle, false, false, -1, true, false)


self:StartIntervalThink(self.interval)

end
function item_witchfury_root:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetCaster():GetIntellect()*self.damage

if self:GetParent():IsBuilding() then 
  damage = damage*self.building/100
end

local damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE }
ApplyDamage(damageTable)

SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), damage, nil)
  

end

function item_witchfury_root:CheckState()
if not self:GetParent():IsBuilding() then 
  return
  {
    [MODIFIER_STATE_ROOTED] = true
  }
end
return


end