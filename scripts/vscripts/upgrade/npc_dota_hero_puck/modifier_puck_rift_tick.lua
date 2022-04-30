

modifier_puck_rift_tick = class({})


function modifier_puck_rift_tick:IsHidden() return true end
function modifier_puck_rift_tick:IsPurgable() return false end



function modifier_puck_rift_tick:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_rift_tick:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_rift_tick:RemoveOnDeath() return false end