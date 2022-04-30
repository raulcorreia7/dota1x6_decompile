

modifier_queen_Blink_legendary = class({})


function modifier_queen_Blink_legendary:IsHidden() return true end
function modifier_queen_Blink_legendary:IsPurgable() return false end



function modifier_queen_Blink_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_legendary:RemoveOnDeath() return false end