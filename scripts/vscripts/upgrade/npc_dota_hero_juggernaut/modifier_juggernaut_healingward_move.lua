
modifier_juggernaut_healingward_move = class({})


function modifier_juggernaut_healingward_move:IsHidden() return true end
function modifier_juggernaut_healingward_move:IsPurgable() return false end



function modifier_juggernaut_healingward_move:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_healingward_move:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_healingward_move:RemoveOnDeath() return false end