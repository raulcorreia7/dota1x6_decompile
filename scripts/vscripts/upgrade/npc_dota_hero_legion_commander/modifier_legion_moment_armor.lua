

modifier_legion_moment_armor = class({})


function modifier_legion_moment_armor:IsHidden() return true end
function modifier_legion_moment_armor:IsPurgable() return false end



function modifier_legion_moment_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_moment_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_armor:RemoveOnDeath() return false end