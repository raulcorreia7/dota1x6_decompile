

modifier_huskar_spears_blast = class({})


function modifier_huskar_spears_blast:IsHidden() return true end
function modifier_huskar_spears_blast:IsPurgable() return false end



function modifier_huskar_spears_blast:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("custom_huskar_burning_spear") 
   if ability then 
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_huskar_burning_spear_heal", {}) 
end

end


function modifier_huskar_spears_blast:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_spears_blast:RemoveOnDeath() return false end