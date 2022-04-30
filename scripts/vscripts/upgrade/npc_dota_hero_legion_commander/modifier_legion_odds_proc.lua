

modifier_legion_odds_proc = class({})


function modifier_legion_odds_proc:IsHidden() return true end
function modifier_legion_odds_proc:IsPurgable() return false end



function modifier_legion_odds_proc:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_legion_odds_proc:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_proc:RemoveOnDeath() return false end