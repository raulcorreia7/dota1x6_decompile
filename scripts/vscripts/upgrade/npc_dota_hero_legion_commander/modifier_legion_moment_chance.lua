

modifier_legion_moment_chance = class({})


function modifier_legion_moment_chance:IsHidden() return true end
function modifier_legion_moment_chance:IsPurgable() return false end



function modifier_legion_moment_chance:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_legion_moment_chance:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_chance:RemoveOnDeath() return false end