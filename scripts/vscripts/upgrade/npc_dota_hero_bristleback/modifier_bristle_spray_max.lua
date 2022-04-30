

modifier_bristle_spray_max = class({})


function modifier_bristle_spray_max:IsHidden() return true end
function modifier_bristle_spray_max:IsPurgable() return false end



function modifier_bristle_spray_max:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_spray_max:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_spray_max:RemoveOnDeath() return false end