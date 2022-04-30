

modifier_pudge_rot_legendary = class({})


function modifier_pudge_rot_legendary:IsHidden() return true end
function modifier_pudge_rot_legendary:IsPurgable() return false end



function modifier_pudge_rot_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)


  local ability = self:GetParent():FindAbilityByName("custom_pudge_rot")
  if ability then 

	if self:GetParent():HasModifier("modifier_custom_pudge_rot") then 
		self:GetParent():RemoveModifierByName("modifier_custom_pudge_rot")
	end

  	if ability:GetToggleState() == true then 
  		ability:ToggleAbility()
  	end

  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_custom_pudge_rot", {})
  end

end


function modifier_pudge_rot_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_pudge_rot_legendary:RemoveOnDeath() return false end