

modifier_legion_odds_cd = class({})


function modifier_legion_odds_cd:IsHidden() return true end
function modifier_legion_odds_cd:IsPurgable() return false end



function modifier_legion_odds_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_odds_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_cd:RemoveOnDeath() return false end