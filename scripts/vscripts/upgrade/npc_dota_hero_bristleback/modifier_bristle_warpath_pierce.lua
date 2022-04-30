

modifier_bristle_warpath_pierce = class({})


function modifier_bristle_warpath_pierce:IsHidden() return true end
function modifier_bristle_warpath_pierce:IsPurgable() return false end



function modifier_bristle_warpath_pierce:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_pierce:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_pierce:RemoveOnDeath() return false end