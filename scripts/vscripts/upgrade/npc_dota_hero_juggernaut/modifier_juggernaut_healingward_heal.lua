
modifier_juggernaut_healingward_heal = class({})


function modifier_juggernaut_healingward_heal:IsHidden() return true end
function modifier_juggernaut_healingward_heal:IsPurgable() return false end



function modifier_juggernaut_healingward_heal:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_juggernaut_healingward_heal:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_healingward_heal:RemoveOnDeath() return false end