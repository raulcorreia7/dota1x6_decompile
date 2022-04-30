

modifier_puck_rift_purge = class({})


function modifier_puck_rift_purge:IsHidden() return true end
function modifier_puck_rift_purge:IsPurgable() return false end



function modifier_puck_rift_purge:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_purge:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_purge:RemoveOnDeath() return false end