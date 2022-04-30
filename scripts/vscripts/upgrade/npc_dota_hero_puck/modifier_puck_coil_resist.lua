

modifier_puck_coil_resist = class({})


function modifier_puck_coil_resist:IsHidden() return true end
function modifier_puck_coil_resist:IsPurgable() return false end



function modifier_puck_coil_resist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_coil_resist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_coil_resist:RemoveOnDeath() return false end