

modifier_huskar_passive_legendary = class({})


function modifier_huskar_passive_legendary:IsHidden() return true end
function modifier_huskar_passive_legendary:IsPurgable() return false end



function modifier_huskar_passive_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true
end




function modifier_huskar_passive_legendary:RemoveOnDeath() return false end