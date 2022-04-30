

modifier_ember_remnant_legendary = class({})


function modifier_ember_remnant_legendary:IsHidden() return true end
function modifier_ember_remnant_legendary:IsPurgable() return false end



function modifier_ember_remnant_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("ember_spirit_fire_remnant_burst")
  if not ability then return end

  ability:SetHidden(false)  

  if not ability:IsTrained() then      
      ability:SetLevel(1)
  end
  
end


function modifier_ember_remnant_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_ember_remnant_legendary:RemoveOnDeath() return false end