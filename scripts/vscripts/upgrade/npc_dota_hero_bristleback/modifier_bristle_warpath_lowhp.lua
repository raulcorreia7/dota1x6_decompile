

modifier_bristle_warpath_lowhp = class({})


function modifier_bristle_warpath_lowhp:IsHidden() return true end
function modifier_bristle_warpath_lowhp:IsPurgable() return false end



function modifier_bristle_warpath_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_lowhp:RemoveOnDeath() return false end