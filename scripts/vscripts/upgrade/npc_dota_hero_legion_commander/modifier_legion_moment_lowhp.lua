

modifier_legion_moment_lowhp = class({})


function modifier_legion_moment_lowhp:IsHidden() return true end
function modifier_legion_moment_lowhp:IsPurgable() return false end



function modifier_legion_moment_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
   local ability = self:GetParent():FindAbilityByName("custom_legion_commander_moment_of_courage")
   if ability then 
   	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_moment_of_courage_lowhp", {})
   end
end


function modifier_legion_moment_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_lowhp:RemoveOnDeath() return false end