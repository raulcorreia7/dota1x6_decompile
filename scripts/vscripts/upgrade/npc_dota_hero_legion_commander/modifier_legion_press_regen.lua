

modifier_legion_press_regen = class({})


function modifier_legion_press_regen:IsHidden() return true end
function modifier_legion_press_regen:IsPurgable() return false end



function modifier_legion_press_regen:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_press_regen:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_regen:RemoveOnDeath() return false end