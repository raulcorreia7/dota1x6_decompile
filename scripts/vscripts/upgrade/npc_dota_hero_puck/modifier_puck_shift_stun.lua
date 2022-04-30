

modifier_puck_shift_stun = class({})


function modifier_puck_shift_stun:IsHidden() return true end
function modifier_puck_shift_stun:IsPurgable() return false end



function modifier_puck_shift_stun:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_shift_stun:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_shift_stun:RemoveOnDeath() return false end