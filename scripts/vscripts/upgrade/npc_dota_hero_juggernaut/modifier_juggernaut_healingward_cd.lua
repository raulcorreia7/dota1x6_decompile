
modifier_juggernaut_healingward_cd = class({})


function modifier_juggernaut_healingward_cd:IsHidden() return true end
function modifier_juggernaut_healingward_cd:IsPurgable() return false end



function modifier_juggernaut_healingward_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)



end


function modifier_juggernaut_healingward_cd:OnRefresh(table)
if not IsServer() then return end

  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_juggernaut_healingward_cd:RemoveOnDeath() return false end