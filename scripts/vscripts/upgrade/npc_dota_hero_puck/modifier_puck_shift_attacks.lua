

modifier_puck_shift_attacks = class({})


function modifier_puck_shift_attacks:IsHidden() return true end
function modifier_puck_shift_attacks:IsPurgable() return false end



function modifier_puck_shift_attacks:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_shift_attacks:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_shift_attacks:RemoveOnDeath() return false end