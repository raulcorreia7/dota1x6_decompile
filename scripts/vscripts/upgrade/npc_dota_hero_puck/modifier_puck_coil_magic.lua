

modifier_puck_coil_magic = class({})


function modifier_puck_coil_magic:IsHidden() return true end
function modifier_puck_coil_magic:IsPurgable() return false end



function modifier_puck_coil_magic:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_coil_magic:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_coil_magic:RemoveOnDeath() return false end