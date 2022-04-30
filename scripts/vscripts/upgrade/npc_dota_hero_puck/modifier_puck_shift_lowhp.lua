

modifier_puck_shift_lowhp = class({})


function modifier_puck_shift_lowhp:IsHidden() return true end
function modifier_puck_shift_lowhp:IsPurgable() return false end



function modifier_puck_shift_lowhp:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_shift_lowhp:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_shift_lowhp:RemoveOnDeath() return false end