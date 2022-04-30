

modifier_hoodwink_scurry_legendary = class({})


function modifier_hoodwink_scurry_legendary:IsHidden() return true end
function modifier_hoodwink_scurry_legendary:IsPurgable() return false end



function modifier_hoodwink_scurry_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

   local ability = self:GetParent():FindAbilityByName("hoodwink_scurry_custom")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_hoodwink_scurry_custom_legendary_timer", {})
  end
end


function modifier_hoodwink_scurry_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_hoodwink_scurry_legendary:RemoveOnDeath() return false end