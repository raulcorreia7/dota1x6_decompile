

modifier_puck_shift_legendary = class({})


function modifier_puck_shift_legendary:IsHidden() return true end
function modifier_puck_shift_legendary:IsPurgable() return false end



function modifier_puck_shift_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
end



function modifier_puck_shift_legendary:RemoveOnDeath() return false end