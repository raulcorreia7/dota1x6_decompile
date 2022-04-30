

modifier_legion_moment_legendary = class({})


function modifier_legion_moment_legendary:IsHidden() return true end
function modifier_legion_moment_legendary:IsPurgable() return false end



function modifier_legion_moment_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.StackOnIllusion = true
  local ability = self:GetParent():FindAbilityByName("custom_legion_commander_moment_of_courage")
  if ability then 
  	ability:SetActivated(false)
  end
end



function modifier_legion_moment_legendary:RemoveOnDeath() return false end