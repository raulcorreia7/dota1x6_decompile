

modifier_bristle_warpath_max = class({})


function modifier_bristle_warpath_max:IsHidden() return true end
function modifier_bristle_warpath_max:IsPurgable() return false end



function modifier_bristle_warpath_max:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_max:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_max:RemoveOnDeath() return false end