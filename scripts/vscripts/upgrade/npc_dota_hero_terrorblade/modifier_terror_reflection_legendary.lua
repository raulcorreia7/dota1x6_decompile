

modifier_terror_reflection_legendary = class({})


function modifier_terror_reflection_legendary:IsHidden() return true end
function modifier_terror_reflection_legendary:IsPurgable() return false end



function modifier_terror_reflection_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.ActiveTalent = true
end



function modifier_terror_reflection_legendary:RemoveOnDeath() return false end