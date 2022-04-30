

modifier_troll_rage_legendary = class({})


function modifier_troll_rage_legendary:IsHidden() return true end
function modifier_troll_rage_legendary:IsPurgable() return false end



function modifier_troll_rage_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)


  local ability = self:GetParent():FindAbilityByName("troll_warlord_berserkers_rage_custom")
  if self:GetParent():IsRangedAttacker() then 
  	self:GetParent():AddNewModifier(self:GetParent(),  ability, "modifier_troll_warlord_berserkers_rage_ranged", {})
  end
  
end


function modifier_troll_rage_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_troll_rage_legendary:RemoveOnDeath() return false end