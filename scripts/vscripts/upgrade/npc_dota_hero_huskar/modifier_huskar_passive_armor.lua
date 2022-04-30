LinkLuaModifier("modifier_custom_huskar_berserkers_blood_armor", "abilities/huskar/custom_huskar_berserkers_blood", LUA_MODIFIER_MOTION_NONE)

modifier_huskar_passive_armor = class({})


function modifier_huskar_passive_armor:IsHidden() return true end
function modifier_huskar_passive_armor:IsPurgable() return false end



function modifier_huskar_passive_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ab = self:GetParent():FindAbilityByName("custom_huskar_berserkers_blood")
  if ab then  
  	self:GetParent():AddNewModifier(self:GetParent(), ab, "modifier_custom_huskar_berserkers_blood_armor", {}) 
end

end


function modifier_huskar_passive_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_passive_armor:RemoveOnDeath() return false end