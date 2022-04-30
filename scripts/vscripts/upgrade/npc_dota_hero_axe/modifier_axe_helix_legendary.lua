

modifier_axe_helix_legendary = class({})


function modifier_axe_helix_legendary:IsHidden() return true end
function modifier_axe_helix_legendary:IsPurgable() return false end



function modifier_axe_helix_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("axe_counter_helix_custom")
  if ability then 
  	ability:SetActivated(false)
  end
end


function modifier_axe_helix_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_axe_helix_legendary:RemoveOnDeath() return false end