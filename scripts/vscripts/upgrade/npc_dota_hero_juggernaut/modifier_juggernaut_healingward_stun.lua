
modifier_juggernaut_healingward_stun = class({})


function modifier_juggernaut_healingward_stun:IsHidden() return true end
function modifier_juggernaut_healingward_stun:IsPurgable() return false end



function modifier_juggernaut_healingward_stun:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_healingward_stun:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_healingward_stun:RemoveOnDeath() return false end