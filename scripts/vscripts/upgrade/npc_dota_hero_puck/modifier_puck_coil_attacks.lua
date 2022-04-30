

modifier_puck_coil_attacks = class({})


function modifier_puck_coil_attacks:IsHidden() return true end
function modifier_puck_coil_attacks:IsPurgable() return false end



function modifier_puck_coil_attacks:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_coil_attacks:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_coil_attacks:RemoveOnDeath() return false end