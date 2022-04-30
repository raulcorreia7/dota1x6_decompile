

modifier_up_secondary = class({})


function modifier_up_secondary:IsHidden() return true end
function modifier_up_secondary:IsPurgable() return false end

function modifier_up_secondary:DeclareFunctions()
if not IsServer() then return end
  if self:GetParent():GetPrimaryAttribute() == 1 then  return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
  if self:GetParent():GetPrimaryAttribute() == 0 then return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
  if self:GetParent():GetPrimaryAttribute() == 2 then return {  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end

 end

function modifier_up_secondary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_secondary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_secondary:GetModifierBonusStats_Agility () return 6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end
function modifier_up_secondary:GetModifierBonusStats_Strength() return 6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end
function modifier_up_secondary:GetModifierBonusStats_Intellect() return 6*self:GetStackCount()*(1+0.2*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) end

function modifier_up_secondary:RemoveOnDeath() return false end