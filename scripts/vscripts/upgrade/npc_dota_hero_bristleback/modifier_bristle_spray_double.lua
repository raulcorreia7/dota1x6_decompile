

modifier_bristle_spray_double = class({})


function modifier_bristle_spray_double:IsHidden() return true end
function modifier_bristle_spray_double:IsPurgable() return false end



function modifier_bristle_spray_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_spray_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_spray_double:RemoveOnDeath() return false end