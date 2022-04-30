

modifier_puck_orb_legendary = class({})


function modifier_puck_orb_legendary:IsHidden() return true end
function modifier_puck_orb_legendary:IsPurgable() return false end



function modifier_puck_orb_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("custom_puck_illusory_barrier")
  if not ability then return end

  ability:SetHidden(false)  

  if ability then 
  	ability:UpdateVectorValues()
  end



  local main_ability = self:GetParent():FindAbilityByName("custom_puck_illusory_orb")

  if main_ability then 
  	main_ability:UpdateVectorValues()
  end

end




function modifier_puck_orb_legendary:RemoveOnDeath() return false end