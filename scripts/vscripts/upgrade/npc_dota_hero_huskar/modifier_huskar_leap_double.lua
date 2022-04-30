

modifier_huskar_leap_double = class({})


function modifier_huskar_leap_double:IsHidden() return true end
function modifier_huskar_leap_double:IsPurgable() return false end



function modifier_huskar_leap_double:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   local ability = self:GetParent():FindAbilityByName("custom_huskar_life_break") 
   if ability then 
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_huskar_life_lowhp_tracker", {}) 
end

end


function modifier_huskar_leap_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_double:RemoveOnDeath() return false end