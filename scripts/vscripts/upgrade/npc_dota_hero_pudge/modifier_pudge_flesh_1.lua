

modifier_pudge_flesh_1 = class({})


function modifier_pudge_flesh_1:IsHidden() return true end
function modifier_pudge_flesh_1:IsPurgable() return false end



function modifier_pudge_flesh_1:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("custom_pudge_flesh_heap")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_pudge_flesh_heap_creep", {})
  end
end


function modifier_pudge_flesh_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_flesh_1:RemoveOnDeath() return false end