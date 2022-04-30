

modifier_huskar_spears_legendary = class({})


function modifier_huskar_spears_legendary:IsHidden() return true end
function modifier_huskar_spears_legendary:IsPurgable() return false end



function modifier_huskar_spears_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
  local ab = self:GetParent():FindAbilityByName("custom_huskar_burning_spear")

  if ab then
  if ab:GetAutoCastState() then 
  	ab:ToggleAutoCast()
  end 
  self:GetParent():AddNewModifier(self:GetParent(), ab, "modifier_custom_huskar_burning_spear_legendary", {}) 
end
end



function modifier_huskar_spears_legendary:RemoveOnDeath() return false end