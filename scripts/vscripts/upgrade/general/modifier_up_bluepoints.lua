

modifier_up_bluepoints = class({})


function modifier_up_bluepoints:IsHidden() return true end
function modifier_up_bluepoints:IsPurgable() return false end


function modifier_up_bluepoints:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_bluepoints:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_bluepoints:RemoveOnDeath() return false end
  