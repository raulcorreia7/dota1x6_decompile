

modifier_bristle_warpath_resist = class({})


function modifier_bristle_warpath_resist:IsHidden() return true end
function modifier_bristle_warpath_resist:IsPurgable() return false end



function modifier_bristle_warpath_resist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_resist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_resist:RemoveOnDeath() return false end