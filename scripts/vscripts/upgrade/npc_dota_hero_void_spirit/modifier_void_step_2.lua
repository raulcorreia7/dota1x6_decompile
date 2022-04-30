

modifier_void_step_2 = class({})


function modifier_void_step_2:IsHidden() return true end
function modifier_void_step_2:IsPurgable() return false end



function modifier_void_step_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self:Swap("void_spirit_astral_step_custom","void_spirit_astral_step_custom_1")

end


function modifier_void_step_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
  if self:GetStackCount() == 2 then 
  	self:Swap("void_spirit_astral_step_custom_1","void_spirit_astral_step_custom_2")
  end

  if self:GetStackCount() == 3 then 
  	self:Swap("void_spirit_astral_step_custom_2","void_spirit_astral_step_custom_3")
  end

end

function modifier_void_step_2:Swap(name1, name2)
if not IsServer() then return end

local ability1 = self:GetParent():FindAbilityByName(name1)
local ability2 = self:GetParent():FindAbilityByName(name2)

ability1:SetHidden(true)
ability2:SetHidden(false)
ability2:SetLevel(ability1:GetLevel())

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())

self:GetParent():SwapAbilities(name1, name2, false, true)

end


function modifier_void_step_2:RemoveOnDeath() return false end