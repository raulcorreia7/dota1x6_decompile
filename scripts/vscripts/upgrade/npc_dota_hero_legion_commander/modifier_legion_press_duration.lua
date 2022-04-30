

modifier_legion_press_duration = class({})


function modifier_legion_press_duration:IsHidden() return true end
function modifier_legion_press_duration:IsPurgable() return false end



function modifier_legion_press_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_press_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_duration:RemoveOnDeath() return false end