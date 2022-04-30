

modifier_bristle_spray_heal = class({})


function modifier_bristle_spray_heal:IsHidden() return true end
function modifier_bristle_spray_heal:IsPurgable() return false end



function modifier_bristle_spray_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_bristle_spray_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_spray_heal:RemoveOnDeath() return false end