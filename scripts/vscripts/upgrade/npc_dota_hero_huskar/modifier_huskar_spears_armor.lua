

modifier_huskar_spears_armor = class({})


function modifier_huskar_spears_armor:IsHidden() return true end
function modifier_huskar_spears_armor:IsPurgable() return false end



function modifier_huskar_spears_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   local ability = self:GetParent():FindAbilityByName("custom_huskar_burning_spear") 
   if ability then 
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_huskar_burning_spear_armor", {}) 
end
end


function modifier_huskar_spears_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_spears_armor:RemoveOnDeath() return false end