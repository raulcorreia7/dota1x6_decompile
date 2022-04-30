

modifier_queen_Blink_cd = class({})


function modifier_queen_Blink_cd:IsHidden() return true end
function modifier_queen_Blink_cd:IsPurgable() return false end



function modifier_queen_Blink_cd:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_cd:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_cd:RemoveOnDeath() return false end