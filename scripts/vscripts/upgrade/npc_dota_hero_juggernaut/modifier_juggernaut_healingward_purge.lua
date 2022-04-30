
modifier_juggernaut_healingward_purge = class({})


function modifier_juggernaut_healingward_purge:IsHidden() return true end
function modifier_juggernaut_healingward_purge:IsPurgable() return false end



function modifier_juggernaut_healingward_purge:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end



function modifier_juggernaut_healingward_purge:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_juggernaut_healingward_purge:RemoveOnDeath() return false end