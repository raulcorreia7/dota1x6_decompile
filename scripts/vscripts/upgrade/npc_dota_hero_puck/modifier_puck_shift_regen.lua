

modifier_puck_shift_regen = class({})


function modifier_puck_shift_regen:IsHidden() return true end
function modifier_puck_shift_regen:IsPurgable() return false end



function modifier_puck_shift_regen:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_shift_regen:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_shift_regen:RemoveOnDeath() return false end