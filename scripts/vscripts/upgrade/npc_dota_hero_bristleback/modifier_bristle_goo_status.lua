

modifier_bristle_goo_status = class({})


function modifier_bristle_goo_status:IsHidden() return true end
function modifier_bristle_goo_status:IsPurgable() return false end



function modifier_bristle_goo_status:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_goo_status:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_goo_status:RemoveOnDeath() return false end