

modifier_legion_duel_speed = class({})


function modifier_legion_duel_speed:IsHidden() return true end
function modifier_legion_duel_speed:IsPurgable() return false end



function modifier_legion_duel_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1) 
end


function modifier_legion_duel_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_speed:RemoveOnDeath() return false end