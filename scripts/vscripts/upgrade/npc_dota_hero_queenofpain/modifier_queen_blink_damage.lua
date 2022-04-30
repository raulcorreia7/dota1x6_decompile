

modifier_queen_Blink_damage = class({})


function modifier_queen_Blink_damage:IsHidden() return true end
function modifier_queen_Blink_damage:IsPurgable() return false end



function modifier_queen_Blink_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_damage:RemoveOnDeath() return false end