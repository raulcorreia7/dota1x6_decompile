

modifier_legion_press_after = class({})


function modifier_legion_press_after:IsHidden() return true end
function modifier_legion_press_after:IsPurgable() return false end



function modifier_legion_press_after:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_press_after:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_after:RemoveOnDeath() return false end