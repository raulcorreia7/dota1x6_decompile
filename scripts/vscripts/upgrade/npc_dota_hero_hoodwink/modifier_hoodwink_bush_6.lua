

modifier_hoodwink_bush_6 = class({})


function modifier_hoodwink_bush_6:IsHidden() return true end
function modifier_hoodwink_bush_6:IsPurgable() return false end



function modifier_hoodwink_bush_6:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("hoodwink_bushwhack_custom")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_hoodwink_bushwhack_custom_speed", {})
  end

end


function modifier_hoodwink_bush_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_hoodwink_bush_6:RemoveOnDeath() return false end