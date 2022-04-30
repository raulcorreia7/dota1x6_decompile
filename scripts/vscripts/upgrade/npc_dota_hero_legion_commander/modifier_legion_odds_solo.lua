

modifier_legion_odds_solo = class({})


function modifier_legion_odds_solo:IsHidden() return true end
function modifier_legion_odds_solo:IsPurgable() return false end



function modifier_legion_odds_solo:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_odds_solo:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_solo:RemoveOnDeath() return false end