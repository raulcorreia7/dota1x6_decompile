

modifier_legion_odds_creep = class({})


function modifier_legion_odds_creep:IsHidden() return true end
function modifier_legion_odds_creep:IsPurgable() return false end



function modifier_legion_odds_creep:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_odds_creep:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_creep:RemoveOnDeath() return false end