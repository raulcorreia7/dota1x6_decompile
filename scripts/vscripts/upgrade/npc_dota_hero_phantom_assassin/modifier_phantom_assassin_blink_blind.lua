

modifier_phantom_assassin_blink_blind = class({})


function modifier_phantom_assassin_blink_blind:IsHidden() return true end
function modifier_phantom_assassin_blink_blind:IsPurgable() return false end



function modifier_phantom_assassin_blink_blind:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_blink_blind:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_blink_blind:RemoveOnDeath() return false end
