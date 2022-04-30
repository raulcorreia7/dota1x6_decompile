

modifier_legion_moment_defence = class({})


function modifier_legion_moment_defence:IsHidden() return true end
function modifier_legion_moment_defence:IsPurgable() return false end



function modifier_legion_moment_defence:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_moment_defence:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_defence:RemoveOnDeath() return false end