

modifier_up_health = class({})



function modifier_up_health:IsHidden() return true end
function modifier_up_health:IsPurgable() return false end


function modifier_up_health:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_HEALTH_BONUS

    } end

function modifier_up_health:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_health:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_health:GetModifierHealthBonus() return 150*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end

function modifier_up_health:RemoveOnDeath() return false end