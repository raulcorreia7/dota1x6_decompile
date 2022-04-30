

modifier_legion_odds_triple = class({})


function modifier_legion_odds_triple:IsHidden() return true end
function modifier_legion_odds_triple:IsPurgable() return false end



function modifier_legion_odds_triple:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_odds_triple:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_triple:RemoveOnDeath() return false end