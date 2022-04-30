

modifier_bristle_goo_ground = class({})


function modifier_bristle_goo_ground:IsHidden() return true end
function modifier_bristle_goo_ground:IsPurgable() return false end



function modifier_bristle_goo_ground:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)  

end


function modifier_bristle_goo_ground:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_goo_ground:RemoveOnDeath() return false end