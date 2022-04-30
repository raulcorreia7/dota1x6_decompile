

modifier_up_graypoints = class({})


function modifier_up_graypoints:IsHidden() return true end
function modifier_up_graypoints:IsPurgable() return false end


function modifier_up_graypoints:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_graypoints:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_graypoints:RemoveOnDeath() return false end
  