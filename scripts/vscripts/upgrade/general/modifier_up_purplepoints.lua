

modifier_up_purplepoints = class({})


function modifier_up_purplepoints:IsHidden() return true end
function modifier_up_purplepoints:IsPurgable() return false end


function modifier_up_purplepoints:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_purplepoints:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_purplepoints:RemoveOnDeath() return false end
  