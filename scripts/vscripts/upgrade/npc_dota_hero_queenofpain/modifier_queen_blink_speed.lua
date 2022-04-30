

modifier_queen_Blink_speed = class({})


function modifier_queen_Blink_speed:IsHidden() return true end
function modifier_queen_Blink_speed:IsPurgable() return false end



function modifier_queen_Blink_speed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_speed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_speed:RemoveOnDeath() return false end