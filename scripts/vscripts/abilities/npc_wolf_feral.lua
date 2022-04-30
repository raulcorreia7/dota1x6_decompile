LinkLuaModifier("modifier_feral_passive", "abilities/npc_wolf_feral.lua", LUA_MODIFIER_MOTION_NONE)

npc_wolf_feral = class({})


function npc_wolf_feral:GetIntrinsicModifierName() return "modifier_feral_passive" end
 
modifier_feral_passive = class ({})

function modifier_feral_passive:IsHidden() 
if self:GetStackCount() > 0 then return false
else return true end end

function modifier_feral_passive:IsPurgable() return false end
function modifier_feral_passive:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.armor = self:GetAbility():GetSpecialValueFor("armor")
self.magic = self:GetAbility():GetSpecialValueFor("magic")
end

function modifier_feral_passive:DeclareFunctions() return {

    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_TOOLTIP2,
    MODIFIER_PROPERTY_MODEL_SCALE
} end

function modifier_feral_passive:OnDeath( param )
    if not IsServer() then end 
    if param.unit:GetTeamNumber() == self:GetParent():GetTeamNumber()
      and (param.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()  <= 1500 
     then
        self:SetStackCount(self:GetStackCount()+1)
    end
end

function modifier_feral_passive:GetModifierModelScale() return 10*self:GetStackCount() end
function modifier_feral_passive:GetModifierMagicalResistanceBonus() return self.magic*self:GetStackCount() end
function modifier_feral_passive:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()*self.speed end
function modifier_feral_passive:GetModifierPhysicalArmorBonus() return self:GetStackCount()*self.armor end
function modifier_feral_passive:OnTooltip() return self:GetStackCount()*self.magic end
function modifier_feral_passive:OnTooltip2() return self:GetStackCount()*self.armor end