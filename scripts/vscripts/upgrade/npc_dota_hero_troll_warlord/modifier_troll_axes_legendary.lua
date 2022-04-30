

modifier_troll_axes_legendary = class({})


function modifier_troll_axes_legendary:IsHidden() return true end
function modifier_troll_axes_legendary:IsPurgable() return false end



function modifier_troll_axes_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

	self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_melee_custom"):SetActivated(true)
	self:GetCaster():FindAbilityByName("troll_warlord_whirling_axes_ranged_custom"):SetActivated(true)
end


function modifier_troll_axes_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_troll_axes_legendary:RemoveOnDeath() return false end