

modifier_up_damage = class({})

function modifier_up_damage:IsHidden() return true end
function modifier_up_damage:IsPurgable() return false end


function modifier_up_damage:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

    } end

function modifier_up_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_damage:GetModifierPreAttack_BonusDamage() return 10*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end

function modifier_up_damage:RemoveOnDeath() return false end