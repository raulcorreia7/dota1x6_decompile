

modifier_bristle_warpath_bash = class({})


function modifier_bristle_warpath_bash:IsHidden() return true end
function modifier_bristle_warpath_bash:IsPurgable() return false end



function modifier_bristle_warpath_bash:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_warpath_bash:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_warpath_bash:RemoveOnDeath() return false end