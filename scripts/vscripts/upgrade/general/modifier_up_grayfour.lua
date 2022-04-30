

modifier_up_grayfour = class({})


function modifier_up_grayfour:IsHidden() return true end
function modifier_up_grayfour:IsPurgable() return false end


function modifier_up_grayfour:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_up_grayfour:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_grayfour:RemoveOnDeath() return false end
  