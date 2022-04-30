

modifier_skeleton_reincarnation_2 = class({})


function modifier_skeleton_reincarnation_2:IsHidden() return true end
function modifier_skeleton_reincarnation_2:IsPurgable() return false end



function modifier_skeleton_reincarnation_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("skeleton_king_reincarnation_custom")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_skeleton_king_reincarnation_custom_damage", {})
  end

end


function modifier_skeleton_reincarnation_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_skeleton_reincarnation_2:RemoveOnDeath() return false end