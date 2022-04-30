

modifier_pudge_flesh_4 = class({})


function modifier_pudge_flesh_4:IsHidden() return true end
function modifier_pudge_flesh_4:IsPurgable() return false end



function modifier_pudge_flesh_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("custom_pudge_flesh_heap")

  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_flesh_heap_hit_ready", {})
  end

end


function modifier_pudge_flesh_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_flesh_4:RemoveOnDeath() return false end