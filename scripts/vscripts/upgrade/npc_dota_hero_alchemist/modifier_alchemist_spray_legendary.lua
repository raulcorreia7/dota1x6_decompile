

modifier_alchemist_spray_legendary = class({})


function modifier_alchemist_spray_legendary:IsHidden() return true end
function modifier_alchemist_spray_legendary:IsPurgable() return false end



function modifier_alchemist_spray_legendary:OnCreated(table)
if not IsServer() then return end
  	self:SetStackCount(1)
	  local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_mixing")
	  if ability then
	  	ability:SetActivated(true)
	  	ability:SetHidden(false) 
	  end
end

function modifier_alchemist_spray_legendary:RemoveOnDeath() return false end