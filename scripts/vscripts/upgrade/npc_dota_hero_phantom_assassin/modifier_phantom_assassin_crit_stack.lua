

modifier_phantom_assassin_crit_stack = class({})


function modifier_phantom_assassin_crit_stack:IsHidden() return true end
function modifier_phantom_assassin_crit_stack:IsPurgable() return false end



function modifier_phantom_assassin_crit_stack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_phantom_assassin_crit_stack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end



function modifier_phantom_assassin_crit_stack:RemoveOnDeath() return false end
