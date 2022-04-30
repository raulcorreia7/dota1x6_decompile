

modifier_puck_coil_cooldowns = class({})


function modifier_puck_coil_cooldowns:IsHidden() return true end
function modifier_puck_coil_cooldowns:IsPurgable() return false end



function modifier_puck_coil_cooldowns:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_puck_coil_cooldowns:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_puck_coil_cooldowns:RemoveOnDeath() return false end