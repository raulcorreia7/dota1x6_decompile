

modifier_bristle_back_spray = class({})


function modifier_bristle_back_spray:IsHidden() return true end
function modifier_bristle_back_spray:IsPurgable() return false end



function modifier_bristle_back_spray:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_back_spray:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_spray:RemoveOnDeath() return false end