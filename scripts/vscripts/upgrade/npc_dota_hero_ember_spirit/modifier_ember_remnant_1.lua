

modifier_ember_remnant_1 = class({})


function modifier_ember_remnant_1:IsHidden() return true end
function modifier_ember_remnant_1:IsPurgable() return false end



function modifier_ember_remnant_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

if self:GetParent():HasScepter() then 
	self:Swap("ember_spirit_fire_remnant_custom_ult_scepter","ember_spirit_fire_remnant_custom_ult_scepter_1")
else 
	self:Swap("ember_spirit_fire_remnant_custom","ember_spirit_fire_remnant_custom_1")
end


end


function modifier_ember_remnant_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
  



  if self:GetStackCount() == 2 then 
  
		if self:GetParent():HasScepter() then 
			self:Swap("ember_spirit_fire_remnant_custom_ult_scepter_1","ember_spirit_fire_remnant_custom_ult_scepter_2")
		else 
			self:Swap("ember_spirit_fire_remnant_custom_1","ember_spirit_fire_remnant_custom_2")
		end
  end

  if self:GetStackCount() == 3 then 
  	
		if self:GetParent():HasScepter() then 
			self:Swap("ember_spirit_fire_remnant_custom_ult_scepter_2","ember_spirit_fire_remnant_custom_ult_scepter_3")
		else 
			self:Swap("ember_spirit_fire_remnant_custom_2","ember_spirit_fire_remnant_custom_3")
		end

  end

end

function modifier_ember_remnant_1:Swap(name1, name2)
if not IsServer() then return end

local ability1 = self:GetParent():FindAbilityByName(name1)
local ability2 = self:GetParent():FindAbilityByName(name2)

ability1:SetHidden(true)
ability2:SetHidden(false)
ability2:SetLevel(ability1:GetLevel())

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())

self:GetParent():SwapAbilities(name1, name2, false, true)

end


function modifier_ember_remnant_1:RemoveOnDeath() return false end