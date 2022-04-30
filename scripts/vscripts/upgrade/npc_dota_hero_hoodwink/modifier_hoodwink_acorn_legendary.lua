

modifier_hoodwink_acorn_legendary = class({})


function modifier_hoodwink_acorn_legendary:IsHidden() return true end
function modifier_hoodwink_acorn_legendary:IsPurgable() return false end



function modifier_hoodwink_acorn_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  
  local main_ability = self:GetParent():FindAbilityByName("hoodwink_acorn_shot_custom")

  if main_ability then  
  	
  	if main_ability:GetAutoCastState() then 
  		main_ability:ToggleAutoCast()
  	end 
  	main_ability:UpdateVectorValues()
  end

  local main_ability_2 = self:GetParent():FindAbilityByName("hoodwink_acorn_shot_custom_2")

  if main_ability_2 then  
  	
  	if main_ability_2:GetAutoCastState() then 
  		main_ability_2:ToggleAutoCast()
  	end 
  	main_ability_2:UpdateVectorValues()
  end


end


function modifier_hoodwink_acorn_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_hoodwink_acorn_legendary:RemoveOnDeath() return false end