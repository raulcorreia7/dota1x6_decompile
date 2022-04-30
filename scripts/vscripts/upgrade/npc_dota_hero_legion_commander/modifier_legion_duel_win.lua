

modifier_legion_duel_win = class({})


function modifier_legion_duel_win:IsHidden() return true end
function modifier_legion_duel_win:IsPurgable() return false end



function modifier_legion_duel_win:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_legion_duel_win:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_win:RemoveOnDeath() return false end