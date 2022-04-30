

modifier_queen_Blink_absorb = class({})


function modifier_queen_Blink_absorb:IsHidden() return true end
function modifier_queen_Blink_absorb:IsPurgable() return false end



function modifier_queen_Blink_absorb:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_absorb:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_absorb:RemoveOnDeath() return false end