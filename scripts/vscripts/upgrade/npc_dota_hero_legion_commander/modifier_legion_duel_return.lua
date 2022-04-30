

modifier_legion_duel_return = class({})


function modifier_legion_duel_return:IsHidden() return true end
function modifier_legion_duel_return:IsPurgable() return false end



function modifier_legion_duel_return:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_legion_duel_return:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_return:RemoveOnDeath() return false end