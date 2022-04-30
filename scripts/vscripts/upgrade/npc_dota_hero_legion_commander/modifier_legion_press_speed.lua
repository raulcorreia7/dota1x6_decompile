

modifier_legion_press_speed = class({})


function modifier_legion_press_speed:IsHidden() return true end
function modifier_legion_press_speed:IsPurgable() return false end



function modifier_legion_press_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_press_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_speed:RemoveOnDeath() return false end