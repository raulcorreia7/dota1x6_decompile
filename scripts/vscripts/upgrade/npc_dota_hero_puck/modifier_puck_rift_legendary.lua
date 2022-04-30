

modifier_puck_rift_legendary = class({})


function modifier_puck_rift_legendary:IsHidden() return true end
function modifier_puck_rift_legendary:IsPurgable() return false end



function modifier_puck_rift_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("custom_puck_waning_rift")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_puck_waning_rift_legendary", {})
  end
 
end


function modifier_puck_rift_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_legendary:RemoveOnDeath() return false end