modifier_alchemist_rage_legendary = class({})

function modifier_alchemist_rage_legendary:IsHidden() return true end
function modifier_alchemist_rage_legendary:IsPurgable() return false end

function modifier_alchemist_rage_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end

function modifier_alchemist_rage_legendary:RemoveOnDeath() return false end