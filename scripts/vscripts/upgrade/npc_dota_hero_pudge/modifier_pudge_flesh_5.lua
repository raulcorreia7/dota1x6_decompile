

modifier_pudge_flesh_5 = class({})


function modifier_pudge_flesh_5:IsHidden() return true end
function modifier_pudge_flesh_5:IsPurgable() return false end



function modifier_pudge_flesh_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("custom_pudge_flesh_heap")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_pudge_flesh_heap_damage", {})
  end

end


function modifier_pudge_flesh_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_flesh_5:RemoveOnDeath() return false end