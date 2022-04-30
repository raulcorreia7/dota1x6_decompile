

modifier_bristle_back_return = class({})


function modifier_bristle_back_return:IsHidden() return true end
function modifier_bristle_back_return:IsPurgable() return false end



function modifier_bristle_back_return:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)


end


function modifier_bristle_back_return:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_return:RemoveOnDeath() return false end