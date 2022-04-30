

modifier_bristle_goo_proc = class({})


function modifier_bristle_goo_proc:IsHidden() return true end
function modifier_bristle_goo_proc:IsPurgable() return false end



function modifier_bristle_goo_proc:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_goo_proc:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_goo_proc:RemoveOnDeath() return false end