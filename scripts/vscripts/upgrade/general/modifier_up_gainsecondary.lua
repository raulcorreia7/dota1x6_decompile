

modifier_up_gainsecondary = class({})

modifier_up_gainsecondary.gain = 0.5

function modifier_up_gainsecondary:IsHidden() return true end
function modifier_up_gainsecondary:IsPurgable() return false end

function modifier_up_gainsecondary:DeclareFunctions()
if not IsServer() then return end
  if self:GetParent():GetPrimaryAttribute() == 1 then  return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
  if self:GetParent():GetPrimaryAttribute() == 0 then return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
  if self:GetParent():GetPrimaryAttribute() == 2 then return {  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end

 end

function modifier_up_gainsecondary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_gainsecondary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_gainsecondary:GetModifierBonusStats_Agility () return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end
function modifier_up_gainsecondary:GetModifierBonusStats_Strength() return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end
function modifier_up_gainsecondary:GetModifierBonusStats_Intellect() return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end

function modifier_up_gainsecondary:RemoveOnDeath() return false end