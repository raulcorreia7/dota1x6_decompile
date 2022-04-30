

modifier_queen_Blink_spells = class({})


function modifier_queen_Blink_spells:IsHidden() return true end
function modifier_queen_Blink_spells:IsPurgable() return false end



function modifier_queen_Blink_spells:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_queen_Blink_spells:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_queen_Blink_spells:RemoveOnDeath() return false end