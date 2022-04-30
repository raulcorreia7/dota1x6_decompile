

modifier_up_orangepoints = class({})


function modifier_up_orangepoints:IsHidden() return true end
function modifier_up_orangepoints:IsPurgable() return false end


function modifier_up_orangepoints:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_orangepoints:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_orangepoints:RemoveOnDeath() return false end
  