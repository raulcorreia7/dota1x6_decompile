

modifier_bristle_back_damage = class({})


function modifier_bristle_back_damage:IsHidden() return true end
function modifier_bristle_back_damage:IsPurgable() return false end



function modifier_bristle_back_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("bristleback_bristleback_custom")

  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_bristleback_bristleback_damage_tracker", {})
  end

end


function modifier_bristle_back_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_damage:RemoveOnDeath() return false end