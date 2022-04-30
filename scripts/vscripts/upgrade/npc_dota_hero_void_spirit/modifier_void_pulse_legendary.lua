

modifier_void_pulse_legendary = class({})


function modifier_void_pulse_legendary:IsHidden() return true end
function modifier_void_pulse_legendary:IsPurgable() return false end



function modifier_void_pulse_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_void_pulse_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_void_pulse_legendary:RemoveOnDeath() return false end