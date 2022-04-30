

modifier_puck_coil_duration = class({})


function modifier_puck_coil_duration:IsHidden() return true end
function modifier_puck_coil_duration:IsPurgable() return false end



function modifier_puck_coil_duration:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_coil_duration:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_coil_duration:RemoveOnDeath() return false end