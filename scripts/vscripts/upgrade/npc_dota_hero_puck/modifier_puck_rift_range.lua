

modifier_puck_rift_range = class({})


function modifier_puck_rift_range:IsHidden() return true end
function modifier_puck_rift_range:IsPurgable() return false end



function modifier_puck_rift_range:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_range:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_range:RemoveOnDeath() return false end