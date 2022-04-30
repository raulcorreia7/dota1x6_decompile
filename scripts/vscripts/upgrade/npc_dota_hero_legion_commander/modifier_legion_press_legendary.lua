

modifier_legion_press_legendary = class({})


function modifier_legion_press_legendary:IsHidden() return true end
function modifier_legion_press_legendary:IsPurgable() return false end



function modifier_legion_press_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_press_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_press_legendary:RemoveOnDeath() return false end