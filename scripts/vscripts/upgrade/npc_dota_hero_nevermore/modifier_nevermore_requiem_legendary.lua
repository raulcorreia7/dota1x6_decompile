

modifier_nevermore_requiem_legendary = class({})


function modifier_nevermore_requiem_legendary:IsHidden() return true end
function modifier_nevermore_requiem_legendary:IsPurgable() return false end



function modifier_nevermore_requiem_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true

end



function modifier_nevermore_requiem_legendary:RemoveOnDeath() return false end