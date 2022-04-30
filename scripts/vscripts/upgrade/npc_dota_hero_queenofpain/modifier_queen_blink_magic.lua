

modifier_queen_Blink_magic = class({})


function modifier_queen_Blink_magic:IsHidden() return true end
function modifier_queen_Blink_magic:IsPurgable() return false end



function modifier_queen_Blink_magic:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_magic:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_magic:RemoveOnDeath() return false end