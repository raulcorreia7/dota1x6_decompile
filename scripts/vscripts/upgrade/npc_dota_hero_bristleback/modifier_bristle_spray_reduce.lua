

modifier_bristle_spray_reduce = class({})


function modifier_bristle_spray_reduce:IsHidden() return true end
function modifier_bristle_spray_reduce:IsPurgable() return false end



function modifier_bristle_spray_reduce:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_spray_reduce:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_spray_reduce:RemoveOnDeath() return false end