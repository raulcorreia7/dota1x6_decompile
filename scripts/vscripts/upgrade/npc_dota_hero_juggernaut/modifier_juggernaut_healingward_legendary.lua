
modifier_juggernaut_healingward_legendary = class({})


function modifier_juggernaut_healingward_legendary:IsHidden() return true end
function modifier_juggernaut_healingward_legendary:IsPurgable() return false end



function modifier_juggernaut_healingward_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  
end


function modifier_juggernaut_healingward_legendary:RemoveOnDeath() return false end