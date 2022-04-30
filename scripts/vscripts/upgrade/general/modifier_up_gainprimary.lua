
modifier_up_gainprimary = class({})

modifier_up_gainprimary.gain = 0.5


function modifier_up_gainprimary:IsHidden() return true end
function modifier_up_gainprimary:IsPurgable() return false end

function modifier_up_gainprimary:DeclareFunctions()
if not IsServer() then return end
  if self:GetParent():GetPrimaryAttribute() == 1 then  return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS  } end
  if self:GetParent():GetPrimaryAttribute() == 0 then return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
  if self:GetParent():GetPrimaryAttribute() == 2 then return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS } end

 end

function modifier_up_gainprimary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_gainprimary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_gainprimary:GetModifierBonusStats_Agility () return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end
function modifier_up_gainprimary:GetModifierBonusStats_Strength() return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end
function modifier_up_gainprimary:GetModifierBonusStats_Intellect() return self.gain*self:GetParent():GetLevel()*self:GetStackCount() end


function modifier_up_gainprimary:RemoveOnDeath() return false end