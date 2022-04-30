

modifier_void_pulse_4 = class({})


function modifier_void_pulse_4:IsHidden() return true end
function modifier_void_pulse_4:IsPurgable() return false end



function modifier_void_pulse_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("void_spirit_resonant_pulse_custom")

if ability then 
	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_void_spirit_resonant_pulse_aura", {})
end

end


function modifier_void_pulse_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_void_pulse_4:RemoveOnDeath() return false end