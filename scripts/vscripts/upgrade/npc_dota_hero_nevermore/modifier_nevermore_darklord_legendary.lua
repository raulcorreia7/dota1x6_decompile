

modifier_nevermore_darklord_legendary = class({})


function modifier_nevermore_darklord_legendary:IsHidden() return true end
function modifier_nevermore_darklord_legendary:IsPurgable() return false end



function modifier_nevermore_darklord_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self.ActiveTalent = true
end



function modifier_nevermore_darklord_legendary:RemoveOnDeath() return false end