
modifier_juggernaut_healingward_return = class({})


function modifier_juggernaut_healingward_return:IsHidden() return true end
function modifier_juggernaut_healingward_return:IsPurgable() return false end



function modifier_juggernaut_healingward_return:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end

function modifier_juggernaut_healingward_return:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_healingward_return:RemoveOnDeath() return false end